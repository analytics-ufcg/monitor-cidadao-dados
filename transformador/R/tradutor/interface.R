library(magrittr)

source(here::here("R/tradutor/sagres.R"))
source(here::here("R/tradutor/read_utils.R"))

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
#' get_tipo_objeto_licitacao_dt <- get_tipo_objeto_licitacao()
get_tipo_objeto_licitacao <- function() {
  tipo_objeto_licitacao_dt <- read_tipo_objeto_licitacao() %>%
    translate_tipo_objeto_licitacao()
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
