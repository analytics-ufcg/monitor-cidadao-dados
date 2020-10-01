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
suppressMessages(library(yaml))

set.seed(123)
options(scipen = 999)
invisible(Sys.setlocale(category = "LC_ALL", locale = "pt_PT.UTF-8"))

source(here::here("../lib_modelos/modelagem_medidas_avaliacao.R"))



# ---------------------------
# Funções
# ---------------------------

mygc <- function() invisible(gc())

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

algoritmo <- c("Regressão Logístia",
               "Floresta Aleatória")

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


index <- createDataPartition(tipologias_cgerais$status_tramita, 
                             p = .8, list = FALSE, times = 1)

treino <- tipologias_cgerais[index,]
teste  <- tipologias_cgerais[-index,]

  # remove previamente as features que não serão utilizadas no treinamento
treino_exc <- treino %>% select(features_exc)
treino_fil <- treino %>% select(!features_exc)


index <- paste(index, collapse = ',')
indice_particionamento <- data.frame(id_experimento = c(id_experimento),
                       index_treino = index)

readr::write_csv(indice_particionamento, 
                 paste("data/indice_part/indices_exp", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))

rm(index, indice_particionamento, treino)
mygc()




# ---------------------------
# Parte III:
#   Pré-processamento dos dados
# ---------------------------

# Dados escalados e conversão factor-dummy manual
rl_receita <- recipe(status_tramita ~ ., data = treino_fil) %>% 
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

reglog_resmetrics <- collect_metrics(reglog_fit) 

reglog_resmetrics <- reglog_resmetrics %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  mutate(modelo = algoritmo[1],
         tipo_metrica = "cv",
         balanceamento = "-")


  # Floresta Aleatória
rf_fit <- 
  rf_wf %>% 
  fit_resamples(cv_folds,
                metrics = metric_set(roc_auc, accuracy))

rf_resmetrics <- collect_metrics(rf_fit) 

rf_resmetrics <- rf_resmetrics %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  mutate(modelo = algoritmo[2], 
         tipo_metrica = "cv",
         balanceamento = "-")



  # Salva em formato gather
resample_metrics <- bind_rows(reglog_resmetrics, 
                              rf_resmetrics)

resample_metrics <- resample_metrics %>% 
  dplyr::mutate(id_experimento = id_experimento) %>% 
  dplyr::select(id_experimento, dplyr::everything())


# rm(reglog_resmetrics, rf_resmetrics)
mygc()


# ---------------------------
# Parte V:
#   Fit
# ---------------------------


  # Regressão Logística
reglog_fit_model <- reglog_wf %>% fit(treino_assado)


  # Floresta Aleatória
rf_fit_model <- rf_wf %>% fit(treino_assado)





# ---------------------------
# Parte VI:
#   Previsão do risco
# ---------------------------

# Separa apenas o gabarito
ground_truth <- as.data.frame(teste$status_tramita)
colnames(ground_truth) <- c("ground_truth")


  # Regressão Logística
reglog_pred <- reglog_fit_model %>% predict(new_data = teste_assado) %>% 
  mutate(reglog_class_pred = .pred_class) %>% select(-.pred_class)

reglog_probs <- reglog_fit_model %>% predict(new_data = teste_assado, type = "prob") %>% 
  mutate(reglog_prob_0 = .pred_0, reglog_prob_1 = .pred_1) %>% select(-.pred_1, -.pred_0)



  # Floresta Aleatória
rf_class_pred <- rf_fit_model %>% predict(teste_assado) %>% 
  mutate(rf_class_pred = .pred_class) %>% select(-.pred_class)

rf_class_probs <- rf_fit_model %>% predict(teste_assado, type = "prob") %>% 
  mutate(rf_prob_0 = .pred_0, rf_prob_1 = .pred_1) %>% select(-.pred_1, -.pred_0)


previsoes <- bind_cols(ground_truth, 
                       reglog_pred, 
                       reglog_probs,
                       rf_class_pred,
                       rf_class_probs)


previsoes$id_experimento <- id_experimento

previsoes <- previsoes %>% 
  dplyr::select(id_experimento, dplyr::everything())



# rm(reglog_pred, reglog_probs, rf_class_pred, rf_class_probs)
mygc()




# ---------------------------
# Parte V:
#   Calcula as métricas avaliativas para a previsão
#   Formato: gather
# ---------------------------




av_reglog <- avaliacao(algoritmo[1], previsoes, 
                       "reglog_class_pred", "ground_truth") %>%
  select(!modelo)

av_reglog <- av_reglog %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  mutate(modelo = algoritmo[1], 
         tipo_metrica = "oob",
         balanceamento = "-")



av_rf <- avaliacao(algoritmo[2], previsoes, 
                   "rf_class_pred", "ground_truth") %>% 
  select(!modelo)

av_rf <- av_rf %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  mutate(modelo = algoritmo[2],
         tipo_metrica = "oob",
         balanceamento = "-")


avaliacao_modelos <- bind_rows(av_reglog,
                       av_rf)

avaliacao_modelos <- avaliacao_modelos %>%
  dplyr::mutate(id_experimento = id_experimento) %>% 
  dplyr::select(id_experimento, dplyr::everything()) %>% 
  dplyr::mutate(valor_metrica = as.character(valor_metrica)) 



  # Junção das métricas de cv com oob
metricas <- bind_rows(resample_metrics,
                      avaliacao_modelos)

readr::write_csv(metricas, 
                 paste("data/metricas/metricas", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))



# ---------------------------
# Parte VI:
#   Salva experimento
# ---------------------------

experimento_reglog <- data.frame(id_experimento = c(id_experimento),
                          data_hora = c(data_hora),
                          algoritmo = c("Regressão Logística"),
                          modelo = c("objeto_modelo"),
                          hiperparametros = c("crossvalidation 5 folds"),
                          tipo_balanceamento = c("-"),
                          fk_indice_part = c(id_experimento),
                          fk_feature_set = c("feature_set"),
                          hash_codigo_gerador = c(generate_hash_sourcecode()))

experimento_rf <- data.frame(id_experimento = c(id_experimento),
                             data_hora = c(data_hora),
                             algoritmo = c("Floresta Aleatória"),
                             modelo = c("objeto_modelo"),
                             hiperparametros = c("crossvalidation 5 folds"),
                             tipo_balanceamento = c("-"),
                             fk_indice_part = c(id_experimento),
                             fk_feature_set = c("feature_set"),
                             hash_codigo_gerador = c(generate_hash_sourcecode()))


experimento <- bind_rows(experimento_reglog,
                         experimento_rf)

readr::write_csv(experimento, 
                 paste("data/experimento/experimento", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))


# ---------------------------
# Outputs desejados:
#   experimento.csv ok
#     objeto_modelo?
# ---------------------------

# saídas:
#   experimento
#       id_experimento ok
#       data ok
#       objeto_modelo
#       tipo_modelo ok
#       modelo_hiperparams ok
#       tipo_balanceamento ok
#       fk_indice_part ok
#       fk_feature_set
#       previsoes_teste
#       hash_codigo_gerador_modelo ok

