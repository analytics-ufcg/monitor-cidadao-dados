# No caso dos dados vindos do Sagres (2017 e 2019), estes já estão em formato tabular,
# portanto, apenas uniformizamos o nome de suas colunas.

#' @title Traduz dado recebido para dataset
#' @param licitacoes_raw Dados brutos das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname translate_licitacoes
#' @examples
#' licitacoes_dt <- translate_licitacoes(licitacoes_raw)
translate_licitacoes <- function(licitacoes_raw) {
  licitacoes_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(de_obs = stringr::str_replace(de_obs, "\uFFFD", ""))
}

#' @title Traduz dado recebido para dataset
#' @param tipo_objeto_licitacao_raw Dados brutos do tipo dos objetos das licitações
#' @return Dataframe contendo informações sobre o tipo dos objetos das licitações
#' @rdname translate_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao_dt <- translate_tipo_objeto_licitacao(tipo_objeto_licitacao_raw)
translate_tipo_objeto_licitacao <- function(tipo_objeto_licitacao_raw) {
  tipo_objeto_licitacao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param tipo_modalidade_licitacao_raw Dados brutos do tipo das modalidades das licitações
#' @return Dataframe contendo informações sobre o tipo das modalidades das licitações
#' @rdname translate_tipo_modalidade_licitacao
#' @examples
#' tipo_modalidade_licitacao_dt <- translate_tipo_modalidade_licitacao(tipo_modalidade_licitacao_raw)
translate_tipo_modalidade_licitacao <- function(tipo_modalidade_licitacao_raw) {
  tipo_modalidade_licitacao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param regime_execucao_raw Dados brutos do regime de execução
#' @return Dataframe contendo informações sobre o regime de execução
#' @rdname translate_regime_execucao
#' @examples
#' regime_execucao_dt <- translate_regime_execucao(regime_execucao_raw)
translate_regime_execucao <- function(regime_execucao_raw) {
  regime_execucao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_unidade_gestora_raw Dados brutos do codigo da unidade gestora
#' @return Dataframe contendo informações sobre o codigo da unidade gestora
#' @rdname translate_codigo_unidade_gestora
#' @examples
#' codigo_unidade_gestora_dt <- translate_codigo_unidade_gestora(codigo_unidade_gestora_raw)
translate_codigo_unidade_gestora <- function(codigo_unidade_gestora_raw) {
  codigo_unidade_gestora_raw %<>% janitor::clean_names() %>%
  dplyr::mutate(codigo_u_gestora = cd_ugestora)
}

#' @title Traduz dado recebido para dataset
#' @param codigo_funcao_raw Dados brutos dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname translate_codigo_funcao
#' @examples
#' codigo_funcao_dt <- translate_codigo_funcao(codigo_funcao_raw)
translate_codigo_funcao <- function(codigo_funcao_raw) {
  codigo_funcao_raw %<>% janitor::clean_names()
}


#' @title Traduz dado recebido para dataset
#' @param contratos_raw Dados brutos dos contratos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname translate_contratos
#' @examples
#' contratos_dt <- translate_contratos(contratos_raw)
translate_contratos <- function(contratos_raw) {
  contratos_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(de_obs = stringr::str_replace(de_obs, "\uFFFD", "")) %>%
    dplyr::mutate(nu_contrato = stringr::str_replace(nu_contrato, "\uFFFD", ""))
}

#' @title Traduz dado recebido para dataset
#' @param codigo_subfuncao_raw Dados brutos dos códigos de subfunções
#' @return Dataframe contendo informações sobre os códigos de subfunções
#' @rdname translate_codigo_subfuncao
#' @examples
#' codigo_subfuncao_dt <- translate_codigo_subfuncao(codigo_subfuncao_raw)
translate_codigo_subfuncao <- function(codigo_subfuncao_raw) {
  codigo_subfuncao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_elemento_despesa_raw Dados brutos dos códigos de elementos de despesas
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname translate_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa_dt <- translate_codigo_elemento_despesa(codigo_elemento_despesa_raw)
translate_codigo_elemento_despesa <- function(codigo_elemento_despesa_raw) {
  codigo_elemento_despesa_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_subelemento_raw Dados brutos dos códigos de subelementos
#' @return Dataframe contendo informações sobre os códigos de subelementos
#' @rdname translate_codigo_subelemento
#' @examples
#' codigo_subelemento_dt <- translate_codigo_subelemento(codigo_subelemento_raw)
translate_codigo_subelemento <- function(codigo_subelemento_raw) {
  codigo_subelemento_raw %<>% janitor::clean_names()
}


#' @param empenhos_raw Dados brutos dos empenhos
#' @return Dataframe contendo informações sobre empenhos
#' @rdname translate_empenhos
#' @examples
#' empenhos_dt <- translate_empenhos(translate_empenhos_raw)
translate_empenhos <- function(empenhos_raw) {
  empenhos_raw %<>% janitor::clean_names()
}

#' @param aditivos_raw Dados brutos dos aditivos
#' @return Dataframe contendo informações sobre aditivos
#' @rdname translate_aditivos
#' @examples
#' aditivos_dt <- translate_aditivos(translate_aditivos_raw)
translate_aditivos <- function(aditivos_raw) {
  aditivos_raw %<>% janitor::clean_names()
}

#' @param pagamentos_raw Dados brutos dos pagamentos
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname translate_pagamentos
#' @examples
#' pagamentos_dt <- translate_pagamentos(translate_pagamentos_raw)
translate_pagamentos <- function(pagamentos_raw) {
  pagamentos_raw %<>% janitor::clean_names()
}

#' @param convenios_raw Dados brutos dos Convênios
#' @return Dataframe contendo informações sobre Convênios
#' @rdname translate_convenios
#' @examples
#' convenios_dt <- translate_convenios(translate_convenios_raw)
translate_convenios <- function(convenios_raw) {
  convenios_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_municipio_raw Dados brutos dos municípios
#' @return Dataframe contendo informações sobre os municípios
#' @rdname translate_codigo_municipio
#' @examples
#' codigo_municipio_dt <- translate_codigo_municipio(codigo_municipio_raw)
translate_codigo_municipio <- function(codigo_municipio_raw) {
  codigo_municipio_raw %<>% janitor::clean_names()
}
