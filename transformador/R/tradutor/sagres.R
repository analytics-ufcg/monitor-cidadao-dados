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
#' @param codigo_funcao_raw Dados brutos dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname translate_codigo_funcao
#' @examples
#' codigo_funcao_dt <- translate_codigo_funcao(codigo_funcao_raw)
translate_codigo_funcao <- function(codigo_funcao_raw) {
  codigo_funcao_raw %<>% janitor::clean_names()
}
