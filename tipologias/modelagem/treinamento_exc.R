# ---------------------------
# File Help
# ---------------------------

#' @title Definição da mensagem de ajuda do script
displayhelpmenu <- function() {
  # falta inserir as instruções sobre previsão nos contratos vigentes
  cat("-----------------------------Help treinamento_exc.R--------------------------\n")
  cat("\n")
  cat("Modelos treinados: Floresta Aleatória e Regressão Logística.\n")
  cat("\n")
  cat("Outputs desejados:\n")
  cat("indice_exp_<data_geracao>.csv\n")
  cat("metricas_<data_geracao>.csv\n")
  cat("experimento_<data_geracao>.csv\n")
  cat("-----------------------------Help treinamento_exc.R--------------------------\n")
}



# ---------------------------
# Recebimento de Parâmetros
# ---------------------------

args <- commandArgs(trailingOnly = TRUE)

if (length(grep('--help', args))) {
  displayhelpmenu()
  quit()
}

# if (length(args) == 0)
#   stop("Este script precisa de 1 parâmetros para execução. Execute --help.")



# ---------------------------
# Bibliotecas e auxiliares
# ---------------------------

suppressMessages(library(here))
suppressMessages(library(readr))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(kableExtra))
suppressMessages(library(tidymodels))
suppressMessages(library(caret))
suppressMessages(library(unbalanced))

set.seed(123)
options(scipen = 999)
invisible(Sys.setlocale(category = "LC_ALL", locale = "pt_PT.UTF-8"))

source(here::here("../lib_modelos/modelagem_medidas_avaliacao.R"))

mygc <- function() invisible(gc())



# ---------------------------
# Funções
# ---------------------------

#' @title Gera hashcode do código fonte do treinamento
generate_hash_sourcecode <- function() {
  source_code_string <- paste(readr::read_file(here::here("modelagem/treinamento_exc.R")))
  
  hash_source_code <- digest::digest(source_code_string, algo="md5", serialize=F)
}


#' @title Gera identificador do experimento
generate_id_experimento <- function(momentum) {
  return(digest::digest(paste(momentum), algo="md5", serialize=F))
}



# ---------------------------
# Variáveis Globais
# ---------------------------

data_hora <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))
id_experimento <- generate_id_experimento(data_hora)




# ---------------------------
# Parte I:
#   Obtenção dos dados
# ---------------------------

tipologias_cgerais <- read_csv(here::here("data/tipologias_contratos_gerais_2020-07-22.csv"),
                               col_types = cols(id_contrato = col_character(),
                                                cd_u_gestora = col_character(), 
                                                nu_licitacao = col_character(), 
                                                nu_contrato = col_character(), 
                                                nu_cpfcnpj = col_character()))

# aqui seria a leitura de contratos vigentes

tipologias_cgerais <- tipologias_cgerais %>% filter_all(all_vars(!is.na(.)))

tipologias_cgerais$status_tramita <- as.factor(tipologias_cgerais$status_tramita)
tipologias_cgerais$tp_licitacao <- as.factor(tipologias_cgerais$tp_licitacao)




# ---------------------------
# Parte II:
#   Separação dos conjuntos de dados para treinamento e teste
# ---------------------------

features_exc <- c("id_contrato", 
                  "cd_u_gestora", 
                  "nu_licitacao", 
                  "nu_contrato", 
                  "dt_ano", 
                  "data_inicio", 
                  "nu_cpfcnpj")


index <- createDataPartition(tipologias_cgerais$status_tramita, p = .8, list = FALSE, times = 1)

treino <- tipologias_cgerais[index,]
teste  <- tipologias_cgerais[-index,]

treino_feat <- treino %>% select(!features_exc)


testinho <- data.frame(id_experimento = c(id_experimento),
                       index_treino = as.list(index))

index_treino_df <- as.data.frame(index) %>% mutate(indice_treino = Resample1) %>% select(-Resample1)


readr::write_csv(index_treino_df, 
                 paste("data/indice_part/indices_exp", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", Sys.Date())), ".csv", sep = ""))


rm(index_treino_df)
mygc()




# ---------------------------
# Parte III:
#   Pré-processamento dos dados
# ---------------------------

# Dados escalados e conversão factor-dummy manual
rl_receita <- recipe(status_tramita ~ ., data = treino_feat) %>% 
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>% 
  prep()

treino_assado <- juice(rl_receita)
teste_assado <- bake(rl_receita, new_data = teste)


# Balanceamento de classes

# balance <- ubBalance(treino_exc, treino_exc$status_tramita, 
#                      type = "ubSMOTE", positive = 1, k = 5, percOver = 1000, verbose = TRUE)
# 
# treino_upsample <- balance$X




# ---------------------------
# Parte IV:
#   Criação dos workflows para cada tipo de algoritmo
# ---------------------------

  # Regressão Logística
reglog_mod <- logistic_reg() %>% set_engine("glm") %>% set_mode("classification") %>% translate()

reglog_wf <- 
  workflow() %>%
  add_model(reglog_mod) %>%
  add_formula(status_tramita ~ .)


  # Floresta Aleatória
rf_mod <- rand_forest() %>% set_engine("randomForest") %>% set_mode("classification") %>% translate()

rf_wf <-
  workflow() %>%
  add_model(rf_mod) %>%
  add_formula(status_tramita ~ .)




# ---------------------------
# Parte V:
#   Validação cruzada 
# ---------------------------

cv_folds <- vfold_cv(treino_assado, v = 5)

  # Regressão Logística
reglog_fit <- 
  reglog_wf %>% 
  fit_resamples(cv_folds,
                metrics = metric_set(roc_auc, accuracy))

reglog_resmetrics <- collect_metrics(reglog_fit) %>% mutate(model = "Reg Logistica", balance = "none") 


  # Floresta Aleatória
rf_fit <- 
  rf_wf %>% 
  fit_resamples(cv_folds,
                metrics = metric_set(roc_auc, accuracy))

rf_resmetrics <- collect_metrics(rf_fit) %>% mutate(model = "Flo Aleatoria", balance = "none") 



resample_metrics <- bind_rows(reglog_resmetrics, 
                              rf_resmetrics)


readr::write_csv(resample_metrics, 
                 paste("data/metricas/resamples/cv_exp", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", Sys.Date())), ".csv", sep = ""))



# ---------------------------
# Parte V:
#   Fit
# ---------------------------


  # Regressão Logística
reglog_fit <- reglog_wf %>% fit(treino_assado)


  # Floresta Aleatória
rf_fit <- rf_wf %>% fit(treino_assado)





# ---------------------------
# Parte VI:
#   Previsão do risco
# ---------------------------

# Separa apenas o gabarito
ground_truth <- as.data.frame(teste$status_tramita)
colnames(ground_truth) <- c("ground_truth")


  # Regressão Logística
reglog_pred <- reglog_fit %>% predict(new_data = teste_assado) %>% 
  mutate(reglog_class_pred = .pred_class) %>% select(-.pred_class)

reglog_probs <- reglog_fit %>% predict(new_data = teste_assado, type = "prob") %>% 
  mutate(reglog_prob_0 = .pred_0, reglog_prob_1 = .pred_1) %>% select(-.pred_1, -.pred_0)



  # Floresta Aleatória
rf_class_pred <- rf_fit %>% predict(teste_assado) %>% 
  mutate(rf_class_pred = .pred_class) %>% select(-.pred_class)

rf_class_probs <- rf_fit %>% predict(teste_assado, type = "prob") %>% 
  mutate(rf_prob_0 = .pred_0, rf_prob_1 = .pred_1) %>% select(-.pred_1, -.pred_0)


previsoes <- bind_cols(ground_truth, 
                       reglog_pred, 
                       reglog_probs,
                       rf_class_pred,
                       rf_class_probs)


rm(reglog_pred, reglog_probs, rf_class_pred, rf_class_probs)
mygc()




# ---------------------------
# Parte V:
#   Calcula as métricas avaliativas para a previsão
# ---------------------------


av_reglog <- avaliacao("Reg Logistica", previsoes, "reglog_class_pred", "ground_truth")

av_rf <- avaliacao("Flo Aleatoria", previsoes, "rf_class_pred", "ground_truth")




avaliacao <- bind_rows(av_reglog,
                       av_rf)


readr::write_csv(avaliacao, 
                 paste("data/metricas/metricas", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", Sys.Date())), ".csv", sep = ""))




# ---------------------------
# Parte VI:
#   Salva experimento
# ---------------------------






