library(jsonlite)


POSTGRES_MCDB_HOST="localhost"
POSTGRES_MCDB_DB="mc_db"
POSTGRES_MCDB_USER="postgres"
POSTGRES_MCDB_PASSWORD="secret"
POSTGRES_MCDB_PORT=7656

mc_db_con <- NULL

tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres): ", e)))

feature <- tibble::tibble()

template <- ('SELECT id_feature, nome_feature 
              FROM feature')

query <- template %>% 
  dplyr::sql()

tryCatch({
  feature <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar features no Banco MC_DB (Postgres): ", e))
)

#Criando feature_set
features_descricao <- feature %>% dplyr::select(nome_feature) %>% dplyr::distinct() %>% list()
id_feature_set <- digest::digest(features_descricao[[1]]$nome_feature, algo="md5", serialize=F)
feature_set <- data.frame(id_feature_set, 'timestamp' = Sys.time()) %>% 
  dplyr::mutate(features_descricao = features_descricao[[1]]$nome_feature %>% toJSON())

#Criando relação
feature_set_has_feature <- data.frame('id_feature' = feature$id_feature, id_feature_set)

readr::write_csv(feature_set, "data/feature_set.csv")
readr::write_csv(feature_set_has_feature, "data/feature_set_has_feature.csv")

  
