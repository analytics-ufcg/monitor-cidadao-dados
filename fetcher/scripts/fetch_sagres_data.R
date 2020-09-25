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


print("Iniciando Fetch ------------------------ 18 TABELAS")
print("\n")

print("1/18 ---------: Obtendo dados da tabela -- Aditivos")
aditivos <- fetch_aditivos(sagres)
print("Salvando tabela -- Aditivos --")
readr::write_csv(aditivos, here::here("./data/aditivos.csv"))
print("----------------------------------------------------\n")

print("2/18 ---------: Obtendo dados da tabela -- Contratos")
contratos <- fetch_contratos(sagres)
print("Salvando tabela -- Contratos --")
readr::write_csv(contratos, here::here("./data/contratos.csv"))
print("----------------------------------------------------\n")

print("3/18 ---------: Obtendo dados da tabela -- Convênios")
convenios <- fetch_convenios(sagres)
print("Salvando tabela -- Convênios --")
readr::write_csv(convenios, here::here("./data/convenios.csv"))
print("----------------------------------------------------\n")

print("4/18 ---------: Obtendo dados da tabela -- Código Elemento Despesa")
codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres)
print("Salvando tabela -- Código Elemento Despesa --")
readr::write_csv(codigo_elemento_despesa, here::here("./data/codigo_elemento_despesa.csv"))
print("----------------------------------------------------\n")

print("5/18 ---------: Obtendo dados da tabela -- Código Função")
codigo_funcao <- fetch_codigo_funcao(sagres)
print("Salvando tabela -- Código Função (Orçamentária) --")
readr::write_csv(codigo_funcao, here::here("./data/codigo_funcao.csv"))
print("----------------------------------------------------\n")

print("6/18 ---------: Obtendo dados da tabela -- Código Município")
codigo_municipio <- fetch_codigo_municipio(sagres)
print("Salvando tabela -- Código Município --")
readr::write_csv(codigo_municipio, here::here("./data/codigo_municipio.csv"))
print("----------------------------------------------------\n")

print("7/18 ---------: Obtendo dados da tabela -- Código Subelemento")
codigo_subelemento <- fetch_codigo_subelemento(sagres)
print("Salvando tabela -- Código Subelemento --")
readr::write_csv(codigo_subelemento, here::here("./data/codigo_subelemento.csv"))
print("----------------------------------------------------\n")

print("8/18 ---------: Obtendo dados da tabela -- Código Subfunção")
codigo_subfuncao <- fetch_codigo_subfuncao(sagres)
print("Salvando tabela -- Código Subfunção --")
readr::write_csv(codigo_subfuncao, here::here("./data/codigo_subfuncao.csv"))
print("----------------------------------------------------\n")

print("9/18 ---------: Obtendo dados da tabela -- Código Unidade Gestora")
codigo_unidade_gestora <- fetch_codigo_unidade_gestora(sagres)
print("Salvando tabela -- Código Unidade Gestora --")
readr::write_csv(codigo_unidade_gestora, here::here("./data/codigo_unidade_gestora.csv"))
print("----------------------------------------------------\n")

print("10/18 ---------: Obtendo dados da tabela -- Estorno Pagamento")
estorno_pagamento <- fetch_estorno_pagamento(sagres)
print("Salvando tabela -- Estorno Pagamento --")
readr::write_csv(estorno_pagamento, here::here("./data/estorno_pagamento.csv"))
print("----------------------------------------------------\n")

print("11/18 ---------: Obtendo dados da tabela -- Fornecedores")
fornecedores<- fetch_fornecedores(sagres)
print("Salvando tabela -- Fornecedores --")
readr::write_csv(fornecedores, here::here("./data/fornecedores.csv"))
print("----------------------------------------------------\n")

print("12/18 ---------: Obtendo dados da tabela -- Licitações")
licitacoes <- fetch_licitacoes(sagres)
print("Salvando tabela -- Licitações --")
readr::write_csv(licitacoes, here::here("./data/licitacoes.csv"))
print("----------------------------------------------------\n")

print("13/18 ---------: Obtendo dados da tabela -- Participantes")
participantes<- fetch_participantes(sagres)
print("Salvando tabela -- Participantes --")
readr::write_csv(participantes, here::here("./data/participantes.csv"))
print("----------------------------------------------------\n")

print("14/18 ---------: Obtendo dados da tabela -- Propostas")
propostas<- fetch_propostas(sagres)
print("Salvando tabela -- Propostas --")
readr::write_csv(propostas, here::here("./data/propostas.csv"))
print("----------------------------------------------------\n")

print("15/18 ---------: Obtendo dados da tabela -- Regime Execução")
regime_execucao <- fetch_regime_execucao(sagres)
print("Salvando tabela -- Regime Execução --")
readr::write_csv(regime_execucao, here::here("./data/regime_execucao.csv"))
print("----------------------------------------------------\n")

print("16/18 ---------: Obtendo dados da tabela -- Tipo Objeto Licitação")
tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres)
print("Salvando tabela -- Tipo Objeto Licitação --")
readr::write_csv(tipo_objeto_licitacao, here::here("./data/tipo_objeto_licitacao.csv"))
print("----------------------------------------------------\n")

print("17/18 ---------: Obtendo dados da tabela -- Tipo Modalidade Licitação")
tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(sagres)
print("Salvando tabela -- Tipo Modalidade Licitação --")
readr::write_csv(tipo_modalidade_licitacao, here::here("./data/tipo_modalidade_licitacao.csv"))
print("----------------------------------------------------\n")


#
# Recupera os dados por unidade gestora para empenhos e pagamentos
#
print("18/18 ---------: Obtendo dados das tabelas -- Empenhos e Pagamentos")
output_dir_empenhos = 'data/empenhos/'
if (!dir.exists(output_dir_empenhos)){
    dir.create(output_dir_empenhos)
}
output_dir_pagamentos = 'data/pagamentos/'
if (!dir.exists(output_dir_pagamentos)){
    dir.create(output_dir_pagamentos)
}
for (cd_Ugestora in codigo_unidade_gestora$cd_Ugestora) {
    print(sprintf('[%s] empenhos da unidade gestora = %s', Sys.time(), cd_Ugestora))
    empenhos <- fetch_empenhos(sagres, cd_Ugestora)
    readr::write_csv(empenhos, here::here(sprintf("./data/empenhos/empenhos_%s.csv", cd_Ugestora)))

    print(sprintf('[%s] pagamentos da unidade gestora = %s', Sys.time(), cd_Ugestora))
    pagamentos <- fetch_pagamentos(sagres, cd_Ugestora)
    readr::write_csv(pagamentos, here::here(sprintf("./data/pagamentos/pagamentos_%s.csv", cd_Ugestora)))
    
    rm(empenhos)  # remove o dataframe 'empenhos'
    rm(pagamentos)  # remove o dataframe 'pagamentos'
    gc() # permite que o R retorne memória pro sistema operacional
}

print("18/18 ---------: FETCH FINALIZADO")

DBI::dbDisconnect(sagres)
