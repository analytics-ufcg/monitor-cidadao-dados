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

codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres_2017)
readr::write_csv(codigo_elemento_despesa, here::here("./data/codigo_elemento_despesa.csv"))

tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres_2017)
readr::write_csv(tipo_objeto_licitacao, here::here("./data/tipo_objeto_licitacao.csv"))

tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(sagres_2017)
readr::write_csv(tipo_modalidade_licitacao, here::here("./data/tipo_modalidade_licitacao.csv"))

regime_execucao <- fetch_regime_execucao(sagres_2017)
readr::write_csv(regime_execucao, here::here("./data/regime_execucao.csv"))

contratos <- fetch_contratos(sagres_2017)
readr::write_csv(contratos, here::here("./data/contratos.csv"))

codigo_subfuncao <- fetch_codigo_subfuncao(sagres_2017)
readr::write_csv(codigo_subfuncao, here::here("./data/codigo_subfuncao.csv"))

codigo_subelemento <- fetch_codigo_subelemento(sagres_2017)
readr::write_csv(codigo_subelemento, here::here("./data/codigo_subelemento.csv"))


DBI::dbDisconnect(sagres_2017)
