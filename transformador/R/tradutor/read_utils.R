#' @title Lê dataframe contendo informações das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname read_licitacoes
#' @examples
#' licitacoes_dt <- read_licitacoes()
read_licitacoes <- function() {
  licitacoes_dt <- readr::read_csv(here::here("../fetcher/data/licitacoes.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     nu_Licitacao = readr::col_character(),
                                     dt_Homologacao = readr::col_datetime(format = ""),
                                     de_Obs = readr::col_character(),
                                     dt_MesAno = readr::col_character(),
                                     registroCGE= readr::col_character()
                                   ))
}


#' @title Lê dataframe contendo informações do tipo do objeto das licitações
#' @return Dataframe contendo informações sobre o tipo do objeto das licitações
#' @rdname read_licitacoes
#' @examples
#' tipo_objeto_licitacao_dt <- read_tipo_objeto_licitacao()
read_tipo_objeto_licitacao <- function() {
  tipo_objeto_licitacao_dt <- readr::read_csv(here::here("../fetcher/data/tipo_objeto_licitacao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_TipoObjeto = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname read_codigo_funcao
#' @examples
#' codigo_funcao_dt <- read_codigo_funcao()
read_codigo_funcao <- function() {
  codigo_funcao_df <- readr::read_csv(here::here("../fetcher/data/codigo_funcao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Funcao = readr::col_integer(),
                                     de_Funcao = readr::col_character(),
                                     st_Ativo = readr::col_character()
                                   ))
}
