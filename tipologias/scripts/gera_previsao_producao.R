message("")
message(" ------------------------------------------")
message("    INICIANDO SCRIPT - PREVISÃO PRODUÇÃO   ")
message(" ------------------------------------------")
message("")

library(magrittr)

source(here::here("R/MC_DB_DAO.R"))
source(here::here("R/setup/constants.R"))

#-----------------------------------------------------------------------------#
#-------------------------         FUNÇÕES          --------------------------#
#-----------------------------------------------------------------------------#
message(" CARREGANDO FUNÇÕES...")
message("")

#' @title Gera identificador da tabela previsão_prod pelo timestamp
generate_id_previsao_prod <- function(momentum) {
  return(digest::digest(paste(momentum), algo="md5", serialize=F))
}

message("   Funções carregadas com sucesso!")
message("")
message("")
#-----------------------------------------------------------------------------#
#-------------------------CONFIG E VARIÁVEIS GLOBAIS--------------------------#
#-----------------------------------------------------------------------------#
message(" REALIZANDO CONFIG. DO BD E SETANDO VARIÁVEIS GLOBAIS...")
message("")

.HELP <- "Rscript script/gera_previsao_producao.R --algoritmo <reglog ou randonforest> --data <ano-mes-dia> --tipo_balanceamento <nenhum>"

#----Variáveis de acesso ao banco MCDB caso esteja rodando o script localmente----#
POSTGRES_MCDB_HOST="localhost"
POSTGRES_MCDB_DB="mc_db"
POSTGRES_MCDB_USER="postgres"
POSTGRES_MCDB_PASSWORD="secret"
POSTGRES_MCDB_PORT=7656

algoritmo <- "reglog" #randomforest
data<-"2020-09-04" #caso tenha dois modelos treinados no mesmo dia, o último será recuperado.
tipo_balanceamento <- "nenhum"

mc_db_con <- NULL

# Conexão com o banco MC
tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) stop(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres): \n", e)))

message("   Banco MC_DB configurado com sucesso!")
message("")

set.seed(123)
options(scipen = 999)

invisible(Sys.setlocale(category = "LC_ALL", locale = "C.UTF-8"))

data_hora_previsao_prod <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))
id_previsao_prod <- generate_id_previsao_prod(data_hora_previsao_prod)

# <<TO DO>> Transformar isso em um ENUM
imput_algoritmos_list <- list()
imput_algoritmos_list[[ "reglog" ]] <- "Regressão Logística"
imput_algoritmos_list[[ "randomforest" ]] <- "Floresta Aleatória"

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
message(" - RECUPERANDO EXPERIMENTO... ")
message("")
message("   Termos utilizados:")
message(paste0("    algoritmo:           ", imput_algoritmos_list[algoritmo]))
message(paste0("    data_hora:           ", data))
message(paste0("    tipo_balanceamento:  ", tipo_balanceamento))
message("")

experimento <- get_experimento(mc_db_con, imput_algoritmos_list[algoritmo], data, tipo_balanceamento)

# Interrompe a aplicação caso não seja retornado um experimento
error_not_found_message <- "Nenhum experimento foi encontrado:\n- Verifique se existem experimentos cadastrados;\n- Verifique se os termos inseridos estão presentes em algum dos experimentos.\n "
if ( nrow(experimento) == 0 ) stop ( error_not_found_message )

message("   Experimento recuperando com sucesso!")
message("")


# -----------------------------------------#
# Parte II:
#   Recupera contratos vigentes
# -----------------------------------------#
message(" - RECUPERANDO CONTRATOS VIGENTES...")
message("")

# pega o ultimo feature_set cadastrado no banco
feature_set <- get_ultimo_feature_set(mc_db_con)
# inputs do feature_set
entrada <- read.table("data/input_features.txt")$V1
# adiciona match
feature_set %<>% dplyr::mutate(match = all(entrada %>% purrr::map(~.x%in% jsonlite::fromJSON(features_descricao)))
                               & length(entrada) == length(jsonlite::fromJSON(features_descricao)))
# recuepra apenas aqueles que deram match com a lista
matched_set <- (feature_set %>% dplyr::filter(match == TRUE) %>% tail(1))$id_feature_set
# carrega as features pelo id do feature_set
features <- carrega_features_by_id_feature_set(mc_db_con, feature_set$id_feature_set)

tipologias_cgerais <- features %>% 
  dplyr::select(id_contrato, nome_feature, valor_feature) %>% 
  tidyr::spread(key = nome_feature, value = valor_feature)
# filtra os contratos vigentes
tipologias_cgerais <- tipologias_cgerais %>% 
  dplyr::filter_all(dplyr::all_vars(!is.na(.))) %>% 
  dplyr::filter(vigente == "TRUE") %>% dplyr::select(-vigente)
# transforma status tramita em fator
tipologias_cgerais$status_tramita <- as.factor(tipologias_cgerais$status_tramita)
# transforma tipo da licitação em fator
tipologias_cgerais$tp_licitacao <- as.factor(tipologias_cgerais$tp_licitacao)


message("   Contratos vigentes recuperados com sucesso!")
message("")


# -----------------------------------------#
# Parte III:
#   Traduz experimento (unserialize arquivo)
# -----------------------------------------#
message(" - INICIANDO A TRADUÇÃO DO EXPERIMENTO SERIALIZADO...")
message("")

# adiciona os devidos caracteres
fit_model <- substring(experimento$modelo, seq(1,nchar(experimento$modelo),2), seq(2,nchar(experimento$modelo),2))
# transforma em hex
fit_model = as.raw(as.integer(paste0('0x', fit_model)))
# traduz modelo salvo
fit_model <- unserialize(fit_model)

message("   Modelo traduzido com sucesso!")
message("")

# -----------------------------------------#
# Parte IV:
#   Previsão do risco dos contratos vigentes
# -----------------------------------------#
message(" - REALIZANDO PREVISAO DE RISCO DOS CONTRATOS VIGENTES...")
message("")


# Regressão Logística
reglog_pred <- fit_model %>% stats::predict(new_data = tipologias_cgerais)

reglog_probs <- fit_model %>% stats::predict(new_data = teste_assado, type = "prob") %>% 
  dplyr::mutate(reglog_prob_0 = .pred_1, reglog_prob_1 = .pred_2) %>% dplyr::select(-.pred_2, -.pred_1)
  




message("")