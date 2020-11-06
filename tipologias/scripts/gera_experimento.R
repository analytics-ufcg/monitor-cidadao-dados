message("")
message(" ------------------------------------------")
message("    INICIANDO SCRIPT - PREVISÃO PRODUÇÃO   ")
message(" ------------------------------------------")
message("")


library(magrittr)

source(here::here("lib_modelos/modelagem_medidas_avaliacao.R"))
source(here::here("R/MC_DB_DAO.R"))
source(here::here("R/setup/constants.R"))


#-----------------------------------------------------------------------------#
#-------------------------         FUNÇÕES          --------------------------#
#-----------------------------------------------------------------------------#
message(" CARREGANDO FUNÇÕES...")
message("")


.HELP <- "Rscript script/gera_experimento.R --tipo_contrucao_feature_set vigentes"

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("--tipo_contrucao_feature_set"),
                          type="character",
                          default="recentes",
                          help="Tipo de construções possíveis: recentes (as features mais atuais)",
                          metavar="character")
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

#' @title Gera identificador da previsao prod
generate_id_previsa_prod <- function(id_experimento, id_contrato, momentum) {
  return(digest::digest(paste(id_experimento, id_contrato, momentum), algo="md5", serialize=F))
}


message("   Funções carregadas com sucesso!")
message("")
message("")
#-----------------------------------------------------------------------------#
#-------------------------CONFIG E VARIÁVEIS GLOBAIS--------------------------#
#-----------------------------------------------------------------------------#
message(" REALIZANDO CONFIG. DO BD E SETANDO VARIÁVEIS GLOBAIS...")
message("")

#----Variáveis de acesso ao banco MCDB caso esteja rodando o script localmente----#
# POSTGRES_MCDB_HOST="localhost"
# POSTGRES_MCDB_DB="mc_db"
# POSTGRES_MCDB_USER="postgres"
# POSTGRES_MCDB_PASSWORD="secret"
# POSTGRES_MCDB_PORT=7656

mc_db_con <- NULL

tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) stop(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres):\n", e)))

set.seed(123)
options(scipen = 999)
invisible(Sys.setlocale(category = "LC_ALL", locale = "C.UTF-8"))

data_hora <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))
id_experimento <- generate_id_experimento(data_hora)

algoritmo <- c("Regressão Logístia",
               "Floresta Aleatória")


message("   Variáveis setadas com sucesso!")
message("")
message("")


#-----------------------------------------------------------------------------#
#-------------------------         EXECUÇÃO         --------------------------#
#-----------------------------------------------------------------------------#
message(" INICIANDO A EXECUÇÃO DA PREVISÃO DOS CONTRATOS VIGENTES...")
message("")

# -----------------------------------------#
# Parte I:
#   Recuperando os dados
# -----------------------------------------#

# Parâmetros/Argumentos
RECENTES <- "recentes"
args <- get_args()
tipo_contrucao_feature_set <- args$tipo_contrucao_feature_set

message(" - RECUPERANDO/CRIANDO FEATURE_SET... ")
message("")
message("   Termos utilizados:")
message(paste0("  tipo_contrucao_feature_set:           ", tipo_contrucao_feature_set))
message("")


# Verifica se o feature set contém as features mais atuais
is_feature_set_atualizado = as.logical(is_features_sets_atualizados(mc_db_con)$case)

# recupera o feature set de acordo com os argumentos de entrada
if(tipo_contrucao_feature_set == RECENTES) {
  if (!is_feature_set_atualizado) {
    message ("   Atualizando feature_set com as features mais recentes:")
    stop ("   Rscript scripts/gera_feature_set.R --tipo_construcao_features recentes")
  } else {
    message ("   Já existe um feature_set com o conjunto de features atuais. Utilizando o mais atual..")
  }
} else {
  stop("Tipo de construção do feature_set não existe.")
  message("")
}

# pega o ultimo feature_set cadastrado no banco
feature_set <- get_ultimo_feature_set(mc_db_con)

entrada <- read.table("data/input_features.txt")$V1

feature_set %<>% dplyr::mutate(match = all(entrada %>% purrr::map(~.x%in% jsonlite::fromJSON(features_descricao)))
                                       & length(entrada) == length(jsonlite::fromJSON(features_descricao)))

matched_set <- (feature_set %>% dplyr::filter(match == TRUE) %>% tail(1))$id_feature_set

message("   Recuperando features gerais...")
message("")
features <- carrega_features_by_id_feature_set(mc_db_con, feature_set$id_feature_set)

tipologias_cgerais <- features %>% 
  dplyr::select(id_contrato, nome_feature, valor_feature) %>% 
  tidyr::spread(key = nome_feature, value = valor_feature)

tipologias_cgerais$status_tramita <- as.factor(tipologias_cgerais$status_tramita)
tipologias_cgerais$tp_licitacao <- as.factor(tipologias_cgerais$tp_licitacao)


message("   Recuperando features de contratos vigentes...")
message("")

tipologias_vigentes <- tipologias_cgerais %>% 
  dplyr::filter_all(dplyr::all_vars(!is.na(.))) %>% 
  dplyr::filter(vigente == "TRUE") %>% dplyr::select(-vigente)


message("   Recuperando features de contratos finalizados...")
message("")

tipologias_cgerais <- tipologias_cgerais %>% 
  dplyr::filter_all(dplyr::all_vars(!is.na(.))) %>% 
  dplyr::filter(vigente == "FALSE") %>% dplyr::select(-vigente)

message("   Dataframes com o com as features foi criado com sucesso!")
message("")

# -----------------------------------------#
# Parte II:
#   Separação dos conjuntos de dados para treinamento e teste
# -----------------------------------------#
message(" SEPARANDO CONJUNTO DE TREINO E TESTE...")
message("")

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

previsao_vigentes_fil <- tipologias_vigentes %>% dplyr::select(!dplyr::all_of(features_exc)) %>%  
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

message("   Conjuntos separados e indices salvos com sucesso!")
message("")

# -----------------------------------------#
# Parte III:
#   Pré-processamento dos dados
# -----------------------------------------#
message(" PRÉ-PROCESSANDO OS DADOS...")
message("")


# Dados escalados e conversão factor-dummy manual
rl_receita <- recipes::recipe(status_tramita ~ ., data = treino_fil) %>% 
  recipes::step_scale(recipes::all_numeric(), -recipes::all_outcomes()) %>%
  recipes::step_dummy(recipes::all_nominal(), -recipes::all_outcomes()) %>% 
  recipes::prep()

teste_feature <- teste_fil %>% dplyr::select(-id_contrato) %>% 
  sapply(as.numeric) %>%
  as.data.frame() %>% 
  dplyr::mutate(tp_licitacao = as.character(tp_licitacao),
                status_tramita = as.factor(status_tramita))

previsao_features_vigentes <- previsao_vigentes_fil %>% 
  sapply(as.numeric) %>%
  as.data.frame() %>% 
  dplyr::mutate(tp_licitacao = as.character(tp_licitacao),
                status_tramita = as.factor(status_tramita))


treino_assado <- recipes::juice(rl_receita)
teste_assado <- recipes::bake(rl_receita, new_data = teste_fil)

previsao_vigentes_assado <- recipes::bake(rl_receita, new_data = previsao_features_vigentes)

message("   Processamento finalizado com sucesso!")
message("")


# -----------------------------------------#
# Parte IV:
#   Criação dos workflows para cada tipo de algoritmo
# -----------------------------------------#
message(" CRIANDO WORKFLOW DOS ALGORÍTMOS DE IA...")
message("")

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

message("   Workflow finalizado com sucesso!")
message("")

# -----------------------------------------#
# Parte V:
#   Validação cruzada 
# -----------------------------------------#
message(" REALIZANDO A VALIDAÇÃO CRUZADA...")
message("")

cv_folds <- rsample::vfold_cv(treino_assado, v = 5)

message("  Realizando validação cruzada do modelo de Regressão Logística")
message("")
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

message("  Realizando validação cruzada do modelo RandomForest...")
message("")
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


rm(reglog_resmetrics, rf_resmetrics)
mygc()

message("  Validação cruzada finalizada com sucesso!")
message("")

# -----------------------------------------#
# Parte V:
#   Fit
# -----------------------------------------#
message(" CRIANDO FIT DOS MODELOS...")
message("")


# Regressão Logística
reglog_fit_model <- reglog_wf %>% parsnip::fit(treino_assado)


# Floresta Aleatória
rf_fit_model <- rf_wf %>% parsnip::fit(treino_assado)


message("  Fit dos modelos criados com sucesso!")
message("")

# -----------------------------------------#
# Parte VI:
#   Previsão do risco
# -----------------------------------------#
message(" REALIZANDO A PREVISÃO DE RISCO...")
message("")


# Separa apenas o gabarito
ground_truth <- as.data.frame(teste$status_tramita)
colnames(ground_truth) <- c("ground_truth")

message("  Realizando previsão de risco com o modelo de regressão logística...")
message("")
# Regressão Logística
reglog_pred <- reglog_fit_model %>% stats::predict(new_data = teste_assado) %>% 
  dplyr::mutate(reglog_class_pred = .pred_class) %>% dplyr::select(-.pred_class)

reglog_probs <- reglog_fit_model %>% stats::predict(new_data = teste_assado, type = "prob") %>% 
  dplyr::mutate(reglog_prob_0 = .pred_1, reglog_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)


message("  Realizando previsão de risco com o modelo RandomForest...")
message("")
# Floresta Aleatória
rf_class_pred <- rf_fit_model %>% stats::predict(teste_assado) %>% 
  dplyr::mutate(rf_class_pred = .pred_class) %>% dplyr::select(-.pred_class)

rf_class_probs <- rf_fit_model %>% stats::predict(teste_assado, type = "prob") %>% 
  dplyr::mutate(rf_prob_0 = .pred_1, rf_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)

message("  Realizando previsão de risco com o modelo RandomForest para os contratos vigentes...")
message("")
# Floresta Aleatória - Vigentes
rf_class_pred_vigentes <- rf_fit_model %>% stats::predict(previsao_vigentes_assado) %>% 
  dplyr::mutate(rf_class_pred = .pred_class) %>% dplyr::select(-.pred_class)

rf_class_probs_vigentes <- rf_fit_model %>% stats::predict(previsao_vigentes_assado, type = "prob") %>% 
  dplyr::mutate(rf_prob_0 = .pred_1, rf_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)

previsoes <- dplyr::bind_cols(ground_truth, 
                              reglog_pred, 
                              reglog_probs,
                              rf_class_pred,
                              rf_class_probs)

previsoes$id_experimento <- id_experimento

previsoes <- previsoes %>% 
  dplyr::select(id_experimento, dplyr::everything())



rm(reglog_pred, reglog_probs, rf_class_pred, rf_class_probs)
mygc()

message("  Previsão de risco realizada com sucesso!")
message("")

# -----------------------------------------#
# Parte V:
#   Calcula as métricas avaliativas para a previsão
#   Formato: gather
# -----------------------------------------#
message(" CALCULANDO MÉTRICAS...")
message("")


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
                      avaliacao_modelos) %>%
                      dplyr::distinct ()

readr::write_csv(metricas, 
                 paste("data/metricas/metricas", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))

message("  Métricas calculadas e salvas com sucesso!")
message("")

# -----------------------------------------#
# Parte VI:
#   Salva experimento
# -----------------------------------------#
message(" SALVANDO EXPERIMENTO...")
message("")

# PARA RECUPERAR O MODELO SALVO NO BANCO DE DADOS UTILIZE O CÓDIGO ABAIXO:
#
# adiciona os devidos caracteres
#fit_model <- substring(experimento$modelo, seq(1,nchar(experimento$modelo),2), seq(2,nchar(experimento$modelo),2))
# transforma em hex
#fit_model = as.raw(as.integer(paste0('0x', fit_model)))
# traduz modelo salvo
#fit_model <- unserialize(fit_model)

experimento_reglog <- data.frame(id_experimento = c(id_experimento),
                                 data_hora = c(data_hora),
                                 algoritmo = c("Regressão Logística"),
                                 modelo = c(paste0(serialize(reglog_fit_model, NULL), collapse = "")),
                                 hiperparametros = c("crossvalidation 5 folds"),
                                 tipo_balanceamento = c("nenhum"),
                                 fk_indice_part = c(id_experimento),
                                 fk_feature_set = c("feature_set"),
                                 hash_codigo_gerador = c(generate_hash_sourcecode()))

experimento_rf <- data.frame(id_experimento = c(id_experimento),
                             data_hora = c(data_hora),
                             algoritmo = c("Floresta Aleatória"),
                             modelo = c(paste0(serialize(rf_fit_model, NULL), collapse = "")),
                             hiperparametros = c("crossvalidation 5 folds"),
                             tipo_balanceamento = c("nenhum"),
                             fk_indice_part = c(id_experimento),
                             fk_feature_set = c("feature_set"),
                             hash_codigo_gerador = c(generate_hash_sourcecode()))


experimento <- dplyr::bind_rows(experimento_reglog,
                         experimento_rf) 

output_dir = 'data/experimento'
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

readr::write_csv(experimento, 
                 paste("data/experimento/experimento", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))

message("  Experimento salvo com sucesso!")
message("")

# -----------------------------------------#
# Parte V:
#   Cria previsão prod
# -----------------------------------------#
message(" CRIANDO PREVISÃO PRODUÇÃO...")
message("")

ident_tipologias_vigentes <- tipologias_vigentes %>% 
  dplyr::select(dplyr::all_of(c("id_contrato")))

previsao_prod <- ident_tipologias_vigentes %>% 
  dplyr::mutate(id_experimento = c(id_experimento)) %>% 
  dplyr::bind_cols(rf_class_probs_vigentes) %>% 
  dplyr::mutate(risco = rf_prob_1) %>% 
  dplyr::mutate(timestamp = data_hora) %>%
  dplyr::select(-rf_prob_0, -rf_prob_1) %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(id_previsao_prod = digest::digest(paste(id_contrato,
                                                  id_experimento,
                                                  data_hora), algo="md5", serialize=F)) %>% 
  dplyr::select(id_previsao_prod, dplyr::everything())


output_dir_experimento = 'data/previsao_prod'
if (!dir.exists(output_dir_experimento)){
  dir.create(output_dir_experimento)
}

readr::write_csv(previsao_prod, 
                 paste("data/previsao_prod/previsao_prod", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))

message("  Previsão prod salvo com sucesso!")
message("")




