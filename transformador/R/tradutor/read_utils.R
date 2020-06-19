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
                                     nu_Licitacao = readr::col_double(),
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

#' @title Lê dataframe contendo informações do tipo da modalidade das licitações
#' @return Dataframe contendo informações sobre o tipo da modalidade das licitações
#' @rdname read_tipo_modalidade_licitacao
#' @examples
#' tipo_modalidade_licitacao_dt <- read_tipo_modalidade_licitacao()
read_tipo_modalidade_licitacao <- function() {
  tipo_modalidade_licitacao_dt <- readr::read_csv(here::here("../fetcher/data/tipo_modalidade_licitacao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_TipoLicitacao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações do tipo do regime de execução
#' @return Dataframe contendo informações sobre o tipo do regime de execução
#' @rdname read_regime_execucao
#' @examples
#' regime_execucao_dt <- read_regime_execucao()
read_regime_execucao <- function() {
  regime_execucao_dt <- readr::read_csv(here::here("../fetcher/data/regime_execucao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_regimeExecucao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos das unidades gestoras
#' @return Dataframe contendo informações sobre os códigos das unidades gestoras
#' @rdname read_codigo_unidade_gestora
#' @examples
#' codigo_unidade_gestora_dt <- read_codigo_unidade_gestora()
read_codigo_unidade_gestora <- function() {
  codigo_unidade_gestora_dt <- readr::read_csv(here::here("../fetcher/data/codigo_unidade_gestora.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_Ibge = readr::col_number(),
                                     cd_Ugestora = readr::col_number()
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


#' @title Lê dataframe contendo informações do objeto dos contratos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname read_contratos
#' @examples
#' contratos_dt <- read_contratos()
read_contratos <- function() {
  contratos_df <- readr::read_csv(here::here("../fetcher/data/contratos.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_UGestora = readr::col_integer(),
                                     dt_Ano = readr::col_integer(),
                                     tp_Licitacao = readr::col_integer(),
                                     vl_TotalContrato = readr::col_double(),
                                     dt_Assinatura = readr::col_datetime(format = ""),
                                     dt_Recebimento = readr::col_datetime(format = "")
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de subfunções
#' @return Dataframe contendo informações sobre os códigos de subfunções
#' @rdname read_codigo_subfuncao
#' @examples
#' codigo_subfuncao_dt <- read_codigo_subfuncao()
read_codigo_subfuncao <- function() {
  codigo_subfuncao_df <- readr::read_csv(here::here("../fetcher/data/codigo_subfuncao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_SubFuncao = readr::col_integer(),
                                     de_SubFuncao = readr::col_character(),
                                     st_Ativo = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de elementos de despesas
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname read_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa_dt <- read_codigo_elemento_despesa()
read_codigo_elemento_despesa <- function() {
  codigo_elemento_despesa_df <- readr::read_csv(here::here("../fetcher/data/codigo_elemento_despesa.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Elemento = readr::col_character(),
                                     de_Elemento = readr::col_character(),
                                     de_Abreviacao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de subelementos
#' @return Dataframe contendo informações sobre os códigos de subelementos
#' @rdname read_codigo_subelemento
#' @examples
#' codigo_subelemento_dt <- read_codigo_subelemento()
read_codigo_subelemento <- function() {
  codigo_subelemento_df <- readr::read_csv(here::here("../fetcher/data/codigo_subelemento.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Subelemento = readr::col_character(),
                                     de_Subelemento = readr::col_character(),
                                     de_Conteudo = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos municípios
#' @return Dataframe contendo informações sobre os municípios
#' @rdname read_codigo_municipio
#' @examples
#' codigo_municipio_dt <- read_codigo_municipio()
read_codigo_municipio <- function() {
  codigo_municipio_dt <- readr::read_csv(here::here("../fetcher/data/codigo_municipio.csv"),
                                           col_types = list(
                                             .default = readr::col_character(),
                                             cd_Ibge = readr::col_number()
                                           ))
}

