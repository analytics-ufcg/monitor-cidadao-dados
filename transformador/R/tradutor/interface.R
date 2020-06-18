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
