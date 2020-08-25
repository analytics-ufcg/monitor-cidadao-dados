library(magrittr)

source(here::here("../lib_modelos/modelagem_medidas_avaliacao.R"))
source(here::here("R/MC_DB_DAO.R"))


.HELP <- "
\t   Rscript gera_experimento.R
\t   Modelos treinados: Floresta Aleatória e Regressão Logística.
\t   Outputs desejados:
\t   indice_exp_<data_geracao>.csv
\t   metricas_<data_geracao>.csv
\t   experimento_<data_geracao>.csv
"

POSTGRES_MCDB_HOST="localhost"
POSTGRES_MCDB_DB="mc_db"
POSTGRES_MCDB_USER="postgres"
POSTGRES_MCDB_PASSWORD="secret"
POSTGRES_MCDB_PORT=7656

#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("-v", "--vigentes"),
                          type="logical",
                          default="TRUE",
                          help=.HELP,
                          metavar="logical")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}

mygc <- function() invisible(gc())

#' @title Gera hashcode do código fonte do treinamento
generate_hash_sourcecode <- function() {
  source_code_string <- paste(readr::read_file(here::here("scripts/gera_experimento.R")))
  
  hash_source_code <- digest::digest(source_code_string, algo="md5", serialize=F)
}


#' @title Gera identificador do experimento
generate_id_experimento <- function(momentum) {
  return(digest::digest(paste(momentum), algo="md5", serialize=F))
}


#-----------------------------------------------------------------------------#


#-------------------------CONFIG E VARIÁVEIS GLOBAIS--------------------------#

mc_db_con <- NULL

tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres): ", e)))

set.seed(123)
options(scipen = 999)
invisible(Sys.setlocale(category = "LC_ALL", locale = "pt_PT.UTF-8"))

args <- get_args()

data_hora <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))
id_experimento <- generate_id_experimento(data_hora)

algoritmo <- c("Regressão Logístia",
               "Floresta Aleatória")

#-----------------------------------------------------------------------------#

#-----------------------------------EXECUÇÃO-----------------------------------#

# ---------------------------
# Parte I:
#   Obtenção dos dados
# ---------------------------

feature_set <- tibble::tibble()

template <- ('SELECT * FROM feature_set')

query <- template %>%
  dplyr::sql()

tryCatch({
  feature_set <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar feature_set no Banco MC_DB (Postgres): ", e)))

feature_set %<>% dplyr::mutate(match = all(entrada %>% purrr::map(~.x%in% jsonlite::fromJSON(features_descricao)))
                                       & length(entrada) == length(jsonlite::fromJSON(features_descricao)))

matched_set <- (feature_set %>% dplyr::filter(match == TRUE) %>% tail(1))$id_feature_set

features <- tibble::tibble()

template <- ('SELECT * 
              FROM feature
              INNER JOIN feature_set_has_feature
              ON feature_set_has_feature.id_feature_set = \'f8eac683daeabd41217776cd5cc0f6b9\' 
              AND feature.id_feature = feature_set_has_feature.id_feature
             ')

query <- template %>%
  dplyr::sql()

tryCatch({
  features <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar featuresno Banco MC_DB (Postgres): ", e)))

tipologias_cgerais <- features %>% 
  dplyr::select(id_contrato, nome_feature, valor_feature) %>% 
  tidyr::spread(key = nome_feature, value = valor_feature)

tipologias_cgerais <- tipologias_cgerais %>% 
  dplyr::filter_all(dplyr::all_vars(!is.na(.))) %>% 
  dplyr::filter(vigente == "FALSE") %>% dplyr::select(-vigente)

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


index <- caret::createDataPartition(tipologias_cgerais$status_tramita, 
                             p = .8, list = FALSE, times = 1)

treino <- tipologias_cgerais[index,] 

teste  <- tipologias_cgerais[-index,] 

# remove previamente as features que não serão utilizadas no treinamento
treino_exc <- treino %>% dplyr::select(dplyr::all_of(features_exc))
treino_fil <- treino %>% dplyr::select(!dplyr::all_of(features_exc)) %>%  
  sapply(as.numeric) %>%
  as.data.frame() %>% 
  dplyr::mutate(tp_licitacao = as.character(tp_licitacao),
                status_tramita = as.factor(status_tramita))

teste_fil <- teste %>% dplyr::select(!dplyr::all_of(features_exc)) %>%  
  sapply(as.numeric) %>%
  as.data.frame() %>% 
  dplyr::mutate(tp_licitacao = as.character(tp_licitacao),
                status_tramita = as.factor(status_tramita))


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
rl_receita <- recipes::recipe(status_tramita ~ ., data = treino_fil) %>% 
  recipes::step_scale(recipes::all_numeric(), -recipes::all_outcomes()) %>%
  recipes::step_dummy(recipes::all_nominal(), -recipes::all_outcomes()) %>% 
  recipes::prep()

teste_feature <- teste %>% dplyr::select(-id_contrato) %>% 
  sapply(as.numeric) %>%
  as.data.frame() %>% 
  dplyr::mutate(tp_licitacao = as.character(tp_licitacao),
                status_tramita = as.factor(status_tramita))


treino_assado <- recipes::juice(rl_receita)
teste_assado <- recipes::bake(rl_receita, new_data = teste_fil)

# ---------------------------
# Parte IV:
#   Criação dos workflows para cada tipo de algoritmo
# ---------------------------

# Regressão Logística
reglog_mod <- parsnip::logistic_reg() %>% 
  parsnip::set_engine("glm") %>% 
  parsnip::set_mode("classification") %>% 
  parsnip::translate()

reglog_wf <- 
  workflows::workflow() %>%
  workflows::add_model(reglog_mod) %>%
  workflows::add_formula(status_tramita ~ .)


# Floresta Aleatória
rf_mod <- parsnip::rand_forest() %>% 
  parsnip::set_engine("randomForest") %>% 
  parsnip::set_mode("classification") %>% 
  parsnip::translate()

rf_wf <-
  workflows::workflow() %>%
  workflows::add_model(rf_mod) %>%
  workflows::add_formula(status_tramita ~ .)


# ---------------------------
# Parte V:
#   Validação cruzada 
# ---------------------------

cv_folds <- rsample::vfold_cv(treino_assado, v = 5)

# Regressão Logística
reglog_fit <- 
  reglog_wf %>% 
  tune::fit_resamples(cv_folds,
                metrics = yardstick::metric_set(yardstick::roc_auc, yardstick::accuracy))

reglog_resmetrics <- tune::collect_metrics(reglog_fit)

reglog_resmetrics <- reglog_resmetrics %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  dplyr::mutate(modelo = algoritmo[1],
         tipo_metrica = "cv",
         balanceamento = "-")


# Floresta Aleatória
rf_fit <- 
  rf_wf %>% 
  tune::fit_resamples(cv_folds,
                metrics = yardstick::metric_set(yardstick::roc_auc, yardstick::accuracy))

rf_resmetrics <- tune::collect_metrics(rf_fit) 

rf_resmetrics <- rf_resmetrics %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  dplyr::mutate(modelo = algoritmo[2], 
         tipo_metrica = "cv",
         balanceamento = "-")



# Salva em formato gather
resample_metrics <- dplyr::bind_rows(reglog_resmetrics, 
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
reglog_fit_model <- reglog_wf %>% parsnip::fit(treino_assado)


# Floresta Aleatória
rf_fit_model <- rf_wf %>% parsnip::fit(treino_assado)





# ---------------------------
# Parte VI:
#   Previsão do risco
# ---------------------------

# Separa apenas o gabarito
ground_truth <- as.data.frame(teste$status_tramita)
colnames(ground_truth) <- c("ground_truth")


# Regressão Logística
reglog_pred <- reglog_fit_model %>% stats::predict(new_data = teste_assado) %>% 
  dplyr::mutate(reglog_class_pred = .pred_class) %>% dplyr::select(-.pred_class)

reglog_probs <- reglog_fit_model %>% stats::predict(new_data = teste_assado, type = "prob") %>% 
  dplyr::mutate(reglog_prob_0 = .pred_1, reglog_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)



# Floresta Aleatória
rf_class_pred <- rf_fit_model %>% stats::predict(teste_assado) %>% 
  dplyr::mutate(rf_class_pred = .pred_class) %>% dplyr::select(-.pred_class)

rf_class_probs <- rf_fit_model %>% stats::predict(teste_assado, type = "prob") %>% 
  dplyr::mutate(rf_prob_0 = .pred_1, rf_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)


previsoes <- dplyr::bind_cols(ground_truth, 
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
  dplyr::select(!modelo)

av_reglog <- av_reglog %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  dplyr::mutate(modelo = algoritmo[1], 
         tipo_metrica = "oob",
         balanceamento = "-")



av_rf <- avaliacao(algoritmo[2], previsoes, 
                   "rf_class_pred", "ground_truth") %>% 
  select(!modelo)

av_rf <- av_rf %>% 
  tidyr::gather(key = "nome_metrica",
                value = "valor_metrica") %>% 
  dplyr::mutate(modelo = algoritmo[2],
         tipo_metrica = "oob",
         balanceamento = "-")


avaliacao_modelos <- dplyr::bind_rows(av_reglog,
                               av_rf)

avaliacao_modelos <- avaliacao_modelos %>%
  dplyr::mutate(id_experimento = id_experimento) %>% 
  dplyr::select(id_experimento, dplyr::everything()) %>% 
  dplyr::mutate(valor_metrica = as.character(valor_metrica)) 



# Junção das métricas de cv com oob
metricas <- dplyr::bind_rows(resample_metrics,
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


experimento <- dplyr::bind_rows(experimento_reglog,
                         experimento_rf)

readr::write_csv(experimento, 
                 paste("data/experimento/experimento", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))