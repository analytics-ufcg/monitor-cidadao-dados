library(jsonlite)
library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/MC_DB_DAO.R"))


.HELP <- "Rscript gera_feature_set.R --tipo_construcao_features <recentes>"


#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("--tipo_construcao_features"), 
                          type="character",
                          default="recentes",
                          help="Tipo de construções possíveis: recentes (as features mais atuais)",
                          metavar="character")
  )
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt)
}


#-----------------------------------CONFIG-----------------------------------#

mc_db_con <- NULL

tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres): ", e)))

#-----------------------------------------------------------------------------#


#-----------------------------------EXECUÇÃO-----------------------------------#
#----CONSTANTES---#
RECENTES <- "recentes"

args <- get_args()
tipo_construcao_features <- args$tipo_construcao_features


#Carrega dados
print("Carregando features")
features <- NULL
if (tipo_construcao_features == RECENTES) {
  features <- carrega_features_recentes(mc_db_con)
}

#Criando feature_set
features_descricao <- features %>% dplyr::select(nome_feature) %>% dplyr::distinct() %>% list()
id_feature_set <- digest::digest(features_descricao[[1]]$nome_feature, algo="md5", serialize=F)
feature_set <- data.frame(id_feature_set, 'timestamp' = Sys.time()) %>% 
  dplyr::mutate(features_descricao = features_descricao[[1]]$nome_feature %>% toJSON())

#Criando relação
feature_set_has_feature <- data.frame('id_feature' = features$id_feature, id_feature_set)

output_dir_feature_set = 'data/feature_set'
if (!dir.exists(output_dir_feature_set)){
  dir.create(output_dir_feature_set)
}

output_dir_feature_set_has_feature = 'data/feature_set_has_feature'
if (!dir.exists(output_dir_feature_set_has_feature)){
  dir.create(output_dir_feature_set_has_feature)
}

data_hora <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))

  
readr::write_csv(feature_set, 
                 paste("data/feature_set/feature_set", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))
readr::write_csv(feature_set_has_feature, 
                 paste("data/feature_set_has_feature/feature_set_has_feature", "_",
                       gsub(":", "", gsub("[[:space:]]", "_", data_hora)), ".csv", sep = ""))

