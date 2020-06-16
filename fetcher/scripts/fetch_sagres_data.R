library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/sagres.R"))

.HELP <- "Rscript fetch_sagres_data.R"

sagres_2017 <- NULL

tryCatch({sagres_2017 <- DBI::dbConnect(RMySQL::MySQL(),
                                dbname = MYSQL_DB,
                                host = MYSQL_HOST,
                                port = as.numeric(MYSQL_PORT),
                                user = MYSQL_USER,
                                password = MYSQL_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco Sagres (MySQL): ", e)))

DBI::dbGetQuery(sagres_2017, "SET NAMES 'utf8'")

licitacoes <- fetch_licitacoes(sagres_2017)

readr::write_csv(licitacoes, here::here("./data/licitacoes.csv"))

codigo_funcao <- fetch_codigo_funcao(sagres_2017)

readr::write_csv(codigo_funcao, here::here("./data/codigo_funcao.csv"))

DBI::dbDisconnect(sagres_2017)
