library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/sagres.R"))

.HELP <- "Rscript fetch_sagres_data.R"

sagres <- NULL

tryCatch({sagres <- DBI::dbConnect(odbc::odbc(),
                                   Driver = "ODBC Driver 17 for SQL Server",
                                   Database = SQLSERVER_SAGRES19_Database,
                                   Server = paste0(SQLSERVER_SAGRES19_HOST,",", SQLSERVER_SAGRES19_PORT),
                                   UID = SQLSERVER_SAGRES19_USER,
                                   PWD = SQLSERVER_SAGRES19_PASS)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco Sagres (SQLServer): ", e)))

#DBI::dbGetQuery(sagres, "SET NAMES 'utf8'")

licitacoes <- fetch_licitacoes(sagres)
readr::write_csv(licitacoes, here::here("./data/licitacoes.csv"))

codigo_funcao <- fetch_codigo_funcao(sagres)
readr::write_csv(codigo_funcao, here::here("./data/codigo_funcao.csv"))

codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres)
readr::write_csv(codigo_elemento_despesa, here::here("./data/codigo_elemento_despesa.csv"))

tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres)
readr::write_csv(tipo_objeto_licitacao, here::here("./data/tipo_objeto_licitacao.csv"))

tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(sagres)
readr::write_csv(tipo_modalidade_licitacao, here::here("./data/tipo_modalidade_licitacao.csv"))

regime_execucao <- fetch_regime_execucao(sagres)
readr::write_csv(regime_execucao, here::here("./data/regime_execucao.csv"))

contratos <- fetch_contratos(sagres)
readr::write_csv(contratos, here::here("./data/contratos.csv"))

codigo_subfuncao <- fetch_codigo_subfuncao(sagres)
readr::write_csv(codigo_subfuncao, here::here("./data/codigo_subfuncao.csv"))

codigo_subelemento <- fetch_codigo_subelemento(sagres)
readr::write_csv(codigo_subelemento, here::here("./data/codigo_subelemento.csv"))

codigo_unidade_gestora <- fetch_codigo_unidade_gestora(sagres)
readr::write_csv(codigo_unidade_gestora, here::here("./data/codigo_unidade_gestora.csv"))

empenhos <- fetch_empenhos(sagres)
readr::write_csv(empenhos, here::here("./data/empenhos.csv"))

DBI::dbDisconnect(sagres)
