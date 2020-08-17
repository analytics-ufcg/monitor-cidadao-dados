# ---------------------------
# Este script utiliza como entrada os arquivos:
#
# Para treinamento e avaliação dos modelos: 
#   Floresta Aleatória e Regressão Logística
#
# Outputs desejados:
#   indice_part.csv
#   metricas.csv
#   experimento.csv
#     objeto_modelo?
# ---------------------------




# ---------------------------
# File Help
# ---------------------------


displayhelpmenu <- function() {
  # falta inserir as instruções sobre previsão nos contratos vigentes
  cat("---------------------------------------Help treinamento_exc.R-----------------------------------------------------\n")
  cat("Este script irá buscar pelas tipologias de contratos.\n")
  cat("\n")
  cat("Outputs desejados:\n   indice_part.csv \n   metricas.csv\n")
  cat("---------------------------------------Help treinamento_exc.R-----------------------------------------------------\n")
  
}



# ---------------------------
# Recebimento de Parâmetros
# ---------------------------

if (length(args) == 0)
  stop("Este script precisa de 1 parâmetros para execução. Execute --help.")

if (length(grep('--help', args))) {
  displayhelpmenu()
  quit()
}

if (length(args) < 5)
  stop("Este script precisa de 1 parâmetros para execução. Execute --help.")




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


index_treino_df <- as.data.frame(index) %>% mutate(indice_treino = Resample1) %>% select(-Resample1)

readr::write_csv(index_treino_df, 
                 paste("data/indice_part/indices_exp",
                       "_",
                       gsub(":", "", gsub("[[:space:]]", "_", Sys.Date())), ".csv", sep = ""))

treino_feat <- treino %>% select(!features_exc)


rm(index_treino_df)
mygc()



# ---------------------------
# Parte III:
#   Pré-processamento dos dados
#   (alguns modelos têm melhor desempenho com dados escalados ou precisam de conversão factor-dummy manual)
# ---------------------------

rl_receita <- recipe(status_tramita ~ ., data = treino_feat) %>% 
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>% 
  prep()

treino_assado <- juice(rl_receita)
teste_assado <- bake(rl_receita, new_data = teste)




# ---------------------------
# Parte IV:
#   Criação dos workflows para cada tipo de algoritmo
# ---------------------------

reglog_mod <- logistic_reg() %>% set_engine("glm") %>% set_mode("classification") %>% translate()

reglog_wf <- 
  workflow() %>%
  add_model(reglog_mod) %>%
  add_formula(status_tramita ~ .)


# rf_mod <- rand_forest() %>% set_engine("randomForest") %>% set_mode("classification") %>% translate()
# 
# rf_wf <- 
#   workflow() %>%
#   add_model(rf_mod) %>%
#   add_formula(status_tramita ~ .)


# ---------------------------
# Parte V:
#   Validação cruzada 
# ---------------------------

cv_folds <- vfold_cv(treino_feat, v = 5)

reglog_fit <- 
  reglog_wf %>% 
  fit_resamples(cv_folds,
                metrics = metric_set(roc_auc, accuracy))

reglog_metrics <- collect_metrics(reglog_fit) %>% mutate(model = "RegLog", balance = "none") 




# ---------------------------
# Parte V:
#   Fit
# ---------------------------

reglog_fit <- reglog_wf %>% fit(treino_feat)


# ---------------------------
# Parte VI:
#   Previsão do risco
# ---------------------------


reglog_pred <- reglog_fit %>% predict(new_data = test_baked) %>% 
  mutate(reglog_class_pred = .pred_class) %>% select(-.pred_class)

reglog_probs <- reglog_fit %>% predict(new_data = test_baked, type = "prob") %>% 
  mutate(reglog_prob_0 = .pred_0, reglog_prob_1 = .pred_1) %>% select(-.pred_1, -.pred_0)

teste <- teste %>% 
  cbind(reglog_pred, reglog_probs) %>% 
  mutate(reglog_class_pred = as.character(reglog_class_pred))




# ---------------------------
# Parte V:
#   Calcula as métricas avaliativas para a previsão
# ---------------------------

av_reglog <- avaliacao("Reg Logística", teste, "reglog_class_pred", "status_tramita")







# entrada:
#   feature set


# saídas:
#   experimento
#       id_experimento
#       data
#       objeto_modelo
#       tipo_modelo
#       modelo_hiperparams
#       tipo_balanceamento
#       fk_indice_part
#       fk_feature_set
#       fk_contratos_mutados
#       previsoes_teste
#       hash_codigo_gerador_modelo

#   tabelas
#     indice_part
#     métricas avaliativas do experimento
#     previsão producão










