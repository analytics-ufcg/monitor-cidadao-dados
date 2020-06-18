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

