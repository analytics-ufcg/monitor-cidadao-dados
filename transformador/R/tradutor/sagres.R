# No caso dos dados vindos do Sagres (2017 e 2019), estes já estão em formato tabular,
# portanto, apenas uniformizamos o nome de suas colunas.

#' @title Traduz dado recebido para dataset
#' @param licitacoes_raw Dados brutos das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname translate_licitacoes
#' @examples
#' licitacoes_dt <- translate_licitacoes(licitacoes_raw)
translate_licitacoes <- function(licitacoes_raw) {
  licitacoes_raw %<>% janitor::clean_names()
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

#' @param codigo_funcao_raw Dados brutos dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname translate_codigo_funcao
#' @examples
#' codigo_funcao_dt <- translate_codigo_funcao(codigo_funcao_raw)
translate_codigo_funcao <- function(codigo_funcao_raw) {
  codigo_funcao_raw %<>% janitor::clean_names()
}
