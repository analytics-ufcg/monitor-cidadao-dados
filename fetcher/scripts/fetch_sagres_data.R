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


aditivos <- fetch_aditivos(sagres)
readr::write_csv(aditivos, here::here("./data/aditivos.csv"))

contratos <- fetch_contratos(sagres)
readr::write_csv(contratos, here::here("./data/contratos.csv"))

convenios <- fetch_convenios(sagres)
readr::write_csv(convenios, here::here("./data/convenios.csv"))

codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres)
readr::write_csv(codigo_elemento_despesa, here::here("./data/codigo_elemento_despesa.csv"))

codigo_funcao <- fetch_codigo_funcao(sagres)
readr::write_csv(codigo_funcao, here::here("./data/codigo_funcao.csv"))

codigo_municipio <- fetch_codigo_municipio(sagres)
readr::write_csv(codigo_municipio, here::here("./data/codigo_municipio.csv"))

codigo_subelemento <- fetch_codigo_subelemento(sagres)
readr::write_csv(codigo_subelemento, here::here("./data/codigo_subelemento.csv"))

codigo_subfuncao <- fetch_codigo_subfuncao(sagres)
readr::write_csv(codigo_subfuncao, here::here("./data/codigo_subfuncao.csv"))

codigo_unidade_gestora <- fetch_codigo_unidade_gestora(sagres)
readr::write_csv(codigo_unidade_gestora, here::here("./data/codigo_unidade_gestora.csv"))

estorno_pagamento <- fetch_estorno_pagamento(sagres)
readr::write_csv(estorno_pagamento, here::here("./data/estorno_pagamento.csv"))

fornecedores<- fetch_fornecedores(sagres)
readr::write_csv(fornecedores, here::here("./data/fornecedores.csv"))

licitacoes <- fetch_licitacoes(sagres)
readr::write_csv(licitacoes, here::here("./data/licitacoes.csv"))

participantes<- fetch_participantes(sagres)
readr::write_csv(participantes, here::here("./data/participantes.csv"))

propostas<- fetch_propostas(sagres)
readr::write_csv(propostas, here::here("./data/propostas.csv"))

regime_execucao <- fetch_regime_execucao(sagres)
readr::write_csv(regime_execucao, here::here("./data/regime_execucao.csv"))

tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres)
readr::write_csv(tipo_objeto_licitacao, here::here("./data/tipo_objeto_licitacao.csv"))

tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(sagres)
readr::write_csv(tipo_modalidade_licitacao, here::here("./data/tipo_modalidade_licitacao.csv"))

#
# Recupera os dados por unidade gestora para empenhos
#
output_dir_empenhos = 'data/empenhos/'
if (!dir.exists(output_dir_empenhos)){
    dir.create(output_dir_empenhos)
}

for (cd_Ugestora in codigo_unidade_gestora$cd_Ugestora) {
    print(sprintf('[%s] empenhos da unidade gestora = %s', Sys.time(), cd_Ugestora))
    empenhos <- fetch_empenhos(sagres, cd_Ugestora)
    readr::write_csv(empenhos, here::here(sprintf("./data/empenhos/empenhos_%s.csv", cd_Ugestora)))

    rm(empenhos)  # remove o dataframe 'empenhos'
    gc() # permite que o R retorne memória pro sistema operacional
}

#
# Recupera os dados por unidade gestora para pagamentos
#
output_dir_pagamentos = 'data/pagamentos/'
if (!dir.exists(output_dir_pagamentos)){
    dir.create(output_dir_pagamentos)
}

for (cd_Ugestora in codigo_unidade_gestora$cd_Ugestora) {
    print(sprintf('[%s] pagamentos da unidade gestora = %s', Sys.time(), cd_Ugestora))
    pagamentos <- fetch_pagamentos(sagres, cd_Ugestora)
    readr::write_csv(pagamentos, here::here(sprintf("./data/pagamentos/pagamentos_%s.csv", cd_Ugestora)))

    rm(pagamentos)  # remove o dataframe 'pagamentos'
    gc() # permite que o R retorne memória pro sistema operacional
}


DBI::dbDisconnect(sagres)
