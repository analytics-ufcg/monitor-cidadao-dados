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

template <- ('SELECT *
              FROM feature')

query <- template %>% 
  dplyr::sql()

tryCatch({
  feature <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar features no Banco MC_DB (Postgres): ", e))
)


feautre_compress <- compress.data.frame(feature)

json <- toJSON(feautre_compress)

  
