library(jsonlite)
library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/MC_DB_DAO.R"))

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
#Carrega dados
print("Carregando features")
features <- carrega_features(mc_db_con)

#Criando feature_set
features_descricao <- features %>% dplyr::select(nome_feature) %>% dplyr::distinct() %>% list()
id_feature_set <- digest::digest(features_descricao[[1]]$nome_feature, algo="md5", serialize=F)
feature_set <- data.frame(id_feature_set, 'timestamp' = Sys.time()) %>% 
  dplyr::mutate(features_descricao = features_descricao[[1]]$nome_feature %>% toJSON())

#Criando relação
feature_set_has_feature <- data.frame('id_feature' = features$id_feature, id_feature_set)

readr::write_csv(feature_set, "data/feature_set.csv")
readr::write_csv(feature_set_has_feature, "data/feature_set_has_feature.csv")

  
