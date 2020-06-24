library(readr)

get_contratos <- function() {
  contratos <- read_csv(here::here("fetcher/data/contratos.csv"), 
                        col_types = cols(cd_UGestora = col_character(), 
                                         nu_Contrato = col_character(), tp_Licitacao = col_character()))
  return(contratos)
}


get_contratos_rescindidos <- function() {
  
}

# get_empenhos <- function() {
#   empenhos <- read_csv(here::here("../SAGRES-2017/Empenhos-Sagres2017.csv"),
#                 col_types = cols(cd_Acao = col_character(),
#                     cd_CatEconomica = col_character(),
#                     cd_Funcao = col_character(),
#                     cd_Modalidade = col_character(),
#                     cd_NatDespesa = col_character(),
#                     cd_Programa = col_character(),
#                     cd_Subfuncao = col_character(),
#                     cd_UGestora = col_character(),
#                     cd_UnidOrcamentaria = col_character(),
#                     cd_classificacao = col_character(),
#                     tp_Meta = col_character(),
#                     nu_Licitacao = col_character(),
#                     tp_Licitacao = col_character()))
#   
#   return(empenhos)
# }

get_fornecedores <- function() {
  fornecedores <- read_csv(here::here("fetcher/data/fornecedores.csv"), 
                           col_types = cols(cd_UGestora = col_character(), 
                                            dt_MesAno = col_character(), dt_MesAnoReferencia = col_character(), 
                                            no_Fornecedor = col_character(), 
                                            nu_CPFCNPJ = col_character()))
}

get_licitacoes <- function(){
  licitacoes <- read_csv(here::here("fetcher/data/licitacoes.csv"), 
                         col_types = cols(cd_UGestora = col_character(), 
                                          nu_Licitacao = col_character(), tp_Licitacao = col_character(),
                                          tp_Licitacao = col_character()))
  return(licitacoes)
}

get_municipios_list <- function() {
  municipios <- read_csv(here::here("fetcher/data/Municipios-Sagres2017.csv"), 
                         col_types = cols(cd_IBGE = col_character(), 
                                          cd_Municipio = col_character(), de_Municipio = col_character()))
  return(municipios)
}

get_participantes <- function() {
  participantes <- read_csv(here::here("fetcher/data/participantes.csv"), 
                            col_types = cols(cd_UGestora = col_character(), 
                                             dt_MesAno = col_character(), nu_CPFCNPJ = col_character(), 
                                             nu_Licitacao = col_character(), tp_Licitacao = col_character()))
    
  return(participantes)
}

get_tipo_modalidade <- function() {
  tipos_modalidade <- read_csv(here::here("fetcher/data/tipo_modalidade_licitacao.csv"),
                               col_types = cols(tp_Licitacao = col_character()))
  return(tipos_modalidade)
}






