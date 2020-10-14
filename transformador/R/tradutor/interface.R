library(magrittr)

source(here::here("R/tradutor/sagres.R"))
source(here::here("R/tradutor/read_utils.R"))

source(here::here("R/tradutor/tce_rs_opendata.R"))
source(here::here("R/tradutor/read_utils_tce_rs.R"))

#-----------------------------------------------------------------------------#
#-------------------------          SAGRES          --------------------------#
#-----------------------------------------------------------------------------#

#' @title Obtem dados das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname get_licitacoes
#' @examples
#' licitacoes_dt <- get_licitacoes()
get_licitacoes <- function() {
  licitacoes_dt <- read_licitacoes() %>%
    translate_licitacoes()
}

#' @title Obtem dados do tipo do objeto das licitações
#' @return Dataframe contendo informações sobre o tipo do objeto das licitações
#' @rdname get_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao_dt <- get_tipo_objeto_licitacao()
get_tipo_objeto_licitacao <- function() {
  tipo_objeto_licitacao_dt <- read_tipo_objeto_licitacao() %>%
    translate_tipo_objeto_licitacao()
}

#' @title Obtem dados do tipo da modalidade das licitações
#' @return Dataframe contendo informações sobre o tipo da modalidade das licitações
#' @rdname get_tipo_modalidade_licitacao
#' @examples
#' tipo_modalidade_licitacao_dt <- get_tipo_modalidade_licitacao()
get_tipo_modalidade_licitacao <- function() {
  tipo_modalidade_licitacao_dt <- read_tipo_modalidade_licitacao() %>%
    translate_tipo_modalidade_licitacao()
}

#' @title Obtem dados do regime de execução
#' @return Dataframe contendo informações sobre o tipo do regime de execução
#' @rdname get_regime_execucao
#' @examples
#' regime_execucao_dt <- get_tipo_modalidade_licitacao()
get_regime_execucao <- function() {
  regime_execucao_dt <- read_regime_execucao() %>%
    translate_regime_execucao()
}

#' @title Obtem dados do código da unidade gestora
#' @return Dataframe contendo informações sobre o código da unidade gestora
#' @rdname get_codigo_unidade_gestora
#' @examples
#' codigo_unidade_gestora_dt <- get_codigo_unidade_gestora()
get_codigo_unidade_gestora <- function() {
  codigo_unidade_gestora_dt <- read_codigo_unidade_gestora() %>%
    translate_codigo_unidade_gestora()
}

#' @title Obtem dados dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname get_codigo_funcao
#' @examples
#' codigo_funcao_dt <- get_codigo_funcao()
get_codigo_funcao <- function() {
  codigo_funcao_dt <- read_codigo_funcao() %>%
    translate_codigo_funcao()
}

#' @title Obtem dados dos contratos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname get_contratos
#' @examples
#' get_contratos_dt <- get_contratos()
get_contratos <- function() {
  contratos_dt <- read_contratos() %>%
    translate_contratos()
}

#' @title Obtem dados dos códigos de subfunções
#' @return Dataframe contendo informações sobre os códigos de subfunções
#' @rdname get_codigo_subfuncao
#' @examples
#' codigo_subfuncao_dt <- get_codigo_subfuncao()
get_codigo_subfuncao <- function() {
  codigo_subfuncao_dt <- read_codigo_subfuncao() %>%
    translate_codigo_subfuncao()
}

#' @title Obtem dados dos códigos de elementos de despesas
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname get_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa_dt <- get_codigo_elemento_despesa()
get_codigo_elemento_despesa <- function() {
  codigo_elemento_despesa_dt <- read_codigo_elemento_despesa() %>%
    translate_codigo_elemento_despesa()
}

#' @title Obtem dados dos códigos de subelementos
#' @return Dataframe contendo informações sobre os códigos de subelementos
#' @rdname get_codigo_subelemento
#' @examples
#' codigo_subelemento_dt <- get_codigo_subelemento()
get_codigo_subelemento <- function() {
  codigo_subelemento_dt <- read_codigo_subelemento() %>%
    translate_codigo_subelemento()
}

#' @title Obtem dados dos empenhos pelo codigo da unidade gestora
#' @return Dataframe contendo informações sobre empenhos
#' @rdname get_empenhos_by_unidade_gestora
#' @examples
#' empenhos_dt <- get_empenhos_by_unidade_gestora()
get_empenhos_by_unidade_gestora <- function(codigo_u_gestora) {
  empenhos_dt <- read_empenhos_by_unidade_gestora(codigo_u_gestora) %>%
    translate_empenhos()
}

#' @title Obtem dados dos aditivos de licitação/contrato
#' @return Dataframe contendo informações sobre os aditivos
#' @rdname get_aditivos
#' @examples
#' aditivos_dt <- get_aditivos()
get_aditivos <- function() {
  aditivos_dt <- read_aditivos() %>%
    translate_aditivos()
}

#' @title Obtem dados dos pagamentos pelo codigo da unidade gestora
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname get_pagamentos_by_unidade_gestora
#' @examples
#' pagamentos_dt <- get_pagamentos_by_unidade_gestora()
get_pagamentos_by_unidade_gestora <- function(codigo_u_gestora) {
  pagamentos_dt <- read_pagamentos_by_unidade_gestora(codigo_u_gestora) %>%
    translate_pagamentos()
}

#' @title Obtem dados dos aditivos de convênios
#' @return Dataframe contendo informações sobre convênios
#' @rdname get_convenios
#' @examples
#' convenios_dt <- get_convenios()
get_convenios <- function() {
  convenios_dt <- read_convenios() %>%
    translate_convenios()
}

#' @title Obtem dados dos municípios
#' @return Dataframe contendo informações sobre os municípios
#' @rdname get_codigo_municipio
#' @examples
#' codigo_municipio_dt <- get_codigo_municipio()
get_codigo_municipio <- function() {
  codigo_municipio_dt <- read_codigo_municipio() %>%
    translate_codigo_municipio()
}

#' @title Obtem dados dos participantes de uma licitação
#' @return Dataframe contendo informações sobre os participantes
#' @rdname get_participantes
#' @examples
#' participantes_dt <- get_participantes()
get_participantes <- function() {
  participantes_dt <- read_participantes() %>%
    translate_participantes()
}

#' @title Obtem dados dos fornecedores
#' @return Dataframe contendo informações sobre os fornecedores
#' @rdname get_fornecedores
#' @examples
#' fornecedores_dt <- get_fornecedores()
get_fornecedores <- function() {
  fornecedores_dt <- read_fornecedores() %>%
    translate_fornecedores()
}

#' @title Obtem dados das propostas
#' @return Dataframe contendo informações sobre as propostas
#' @rdname get_propostas
#' @examples
#' propostas_dt <- get_propostas()
get_propostas <- function() {
  propostas_dt <- read_propostas() %>%
    translate_propostas()
}


#' @title Obtem dados do estorno de pagamento
#' @return Dataframe contendo informações sobre o estorno de pagamento
#' @rdname get_estorno_pagamento
#' @examples
#' estorno_pagamento_dt <- get_estorno_pagamento()
get_estorno_pagamento <- function() {
  estorno_pagamento_dt <- read_estorno_pagamento() %>%
    translate_estorno_pagamento()
}

#' @title Obtem dados dos contratos mutados
#' @return Dataframe contendo informações sobre os contratos mutados
#' @rdname get_contratos_mutados
#' @examples
#' contratos_mutados_dt <- get_contratos_mutados()
get_contratos_mutados <-function(){
  contratos_mutados_dt <- read_contratos_mutados() %>%
    translate_contratos_mutados()
}

#' @title Obtem dados das localidades de acordo com o IBGE
#' @return Dataframe contendo informações sobre as localidades de acordo com o IBGE
#' @rdname get_codigo_localidades_ibge
#' @examples
#' codigo_localidades_ibge_dt <- get_codigo_localidades_ibge()
get_codigo_localidades_ibge <- function(){
  codigo_localidades_ibge_dt  <- read_codigo_localidades_ibge() %>%
    translate_codigo_localidades_ibge()
}

#-----------------------------------------------------------------------------#
#-------------------------          TCE-RS          --------------------------#
#-----------------------------------------------------------------------------#

#' @title Obtem dados dos contrato do TCE-RS
#' @return Dataframe contendo informações sobre os contratos
#' @rdname get_contratos_tce_rs
#' @examples
#' contratos_tce_rs_dt <- get_contratos_tce_rs(ano)
get_contratos_tce_rs <- function(ano){
  contratos_tce_rs_dt  <- read_contratos_tce_rs(ano) %>%
  translate_contratos_tce_rs()
}

#' @title Obtem dados dos ógãos do TCE-RS
#' @return Dataframe contendo informações sobre os órgãos
#' @rdname get_orgaos_tce_rs
#' @examples
#' orgaos_tce_rs_dt <- get_orgaos_tce_rs()
get_orgaos_tce_rs <- function(){
  orgaos_tce_rs_dt  <- read_orgaos_tce_rs() %>%
    translate_orgaos_tce_rs()
}

#' @title Obtem dados das modalidades das licitação do TCE-RS
#' @return Dataframe contendo informações sobre as modalidades de licitação existentes
#' @rdname get_modalidade_licitacao_tce_rs
#' @examples
#' modalidade_licitacao_tce_rs_dt <- get_modalidade_licitacao_tce_rs()
get_modalidade_licitacao_tce_rs <- function(){
  modalidade_licitacao_tce_rs_dt  <- read_modalidade_licitacoes_tce_rs()
}



#' @title Obtem dados das licitações do TCE-RS
#' @return Dataframe contendo informações sobre as licitações
#' @rdname get_licitacoes_tce_rs
#' @examples
#' licitacoes_tce_rs_dt <- get_licitacoes_tce_rs()
get_licitacoes_tce_rs <- function(ano){
  licitacoes_tce_rs_dt  <- read_licitacoes_tce_rs(ano) %>%
    translate_licitacoes_tce_rs()
}

