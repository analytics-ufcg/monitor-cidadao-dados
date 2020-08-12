#' @title Realiza o join dos contratos com o dataframe das licitações
#' @param df_contratos dataframe com os contratos
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações dos contratos com os ids das licitações
#' @rdname join_contratos_licitacao
#' @examples
#' join_contrato_licitacao_dt <- join_contratos_licitacao(df_contratos, df_licitacoes)
#'
join_contratos_licitacao <- function(df_contratos, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                     tp_licitacao, id_licitacao)

  df_contratos %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_contrato, id_licitacao, cd_municipio, dplyr::everything())
}

#' @title Realiza o join dos contratos com os códigos das unidades gestoras
#' @param df_contratos dataframe com os contratos
#' @param df_codigo_unidade_gestora dataframe com os códigos das unidades gestoras
#' @return Dataframe contendo informações dos contratos com nomes das unidades gestoras
#' @rdname join_contratos_codigo_unidade_gestora
#' @examples
#' join_contratos_codigo_unidade_gestora_dt <- join_contratos_codigo_unidade_gestora(
#'          df_contratos, df_codigo_unidade_gestora)
#'
join_contratos_codigo_unidade_gestora <- function(df_contratos, df_codigo_unidade_gestora) {
  df_codigo_unidade_gestora %<>% dplyr::select(cd_u_gestora, de_ugestora)

  df_contratos %<>% dplyr::left_join(df_codigo_unidade_gestora) %>%
    dplyr::select(id_contrato, id_licitacao, cd_municipio, dplyr::everything())
}


#' @title Realiza o join das licitações com os códigos das unidades gestoras
#' @param df_licitacoes dataframe com as licitações
#' @param df_codigo_unidade_gestora dataframe com os códigos das unidades gestoras
#' @return Dataframe contendo informações das licitações com nomes das unidades gestoras
#' @rdname join_licitações_codigo_unidade_gestora
#' @examples
#' join_licitacoes_codigo_unidade_gestora_dt <- join_licitacoes_codigo_unidade_gestora(
#'          df_licitacoes, df_codigo_unidade_gestora)
#'
join_licitacoes_codigo_unidade_gestora <- function(df_licitacoes, df_codigo_unidade_gestora){
  df_codigo_unidade_gestora %<>% dplyr::select(cd_u_gestora, de_ugestora)

  df_licitacoes %<>% dplyr::left_join(df_codigo_unidade_gestora) %>%
    dplyr::select(id_licitacao, cd_municipio, dplyr::everything())
}


#' @title Realiza o join dos contratos com os fornecedores
#' @param df_contratos dataframe com os contratos
#' @param df_fornecedores dataframe com os fornecedores
#' @return Dataframe contendo informações dos contratos com os nomes dos fornecedores
#' @rdname join_contratos_fornecedores
#' @examples
#' join_contratos_fornecedores_dt <- join_contratos_fornecedores(
#'          df_contratos, df_fornecedores)
#'
join_contratos_fornecedores <- function(df_contratos, df_fornecedores) {
  df_fornecedores %<>% dplyr::select(nu_cpfcnpj, no_fornecedor) %>%
    dplyr::distinct(nu_cpfcnpj, .keep_all=TRUE)

  df_contratos %<>% dplyr::left_join(df_fornecedores) %>%
    dplyr::select(id_contrato, dplyr::everything())
}


#' @title Realiza o join das licitações com os tipos de modalidade de licitações
#' @param df_licitacoes dataframe com as licitações
#' @param df_tipo_modalidade_licitacao dataframe com os tipos de modalidade de licitações
#' @return Dataframe contendo informações das licitações com nome da modalidade de licitação
#' @rdname join_licitacoes_tipo_modalidade_licitacao
#' @examples
#' join_licitacoes_tipo_modalidade_licitacao_dt <- join_licitacoes_tipo_modalidade_licitacao(
#'          df_licitacoes, df_tipo_modalidade_licitacao)
#'
join_licitacoes_tipo_modalidade_licitacao <- function(df_licitacoes, df_tipo_modalidade_licitacao) {
  df_tipo_modalidade_licitacao %<>% dplyr::select(tp_licitacao, de_tipo_licitacao)

  df_licitacoes %<>% dplyr::left_join(df_tipo_modalidade_licitacao) %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Realiza o join dos participantes com o dataframe das licitações
#' @param df_participantes dataframe com os participantes
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações dos participantes com os ids das licitações
#' @rdname join_participantes_licitacao
#' @examples
#' join_participantes_licitacao_dt <- join_participante_licitacao(df_participantes, df_licitacoes)
#'
join_participantes_licitacao <- function(df_participantes, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                   tp_licitacao, id_licitacao)

  df_participantes %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_participante, id_licitacao, dplyr::everything())
}


#' @title Realiza o join dos participantes com os fornecedores
#' @param df_participantes dataframe com os participantes
#' @param df_fornecedores dataframe com os fornecedores
#' @return Dataframe contendo informações dos participantes com os nomes dos fornecedores
#' @rdname join_participantes_fornecedores
#' @examples
#' join_participantes_fornecedores_dt <- join_participantes_fornecedores(
#'          df_participantes, df_fornecedores)
#'
join_participantes_fornecedores <- function(df_participantes, df_fornecedores) {
  df_fornecedores %<>% dplyr::select(nu_cpfcnpj, no_fornecedor) %>%
    dplyr::distinct(nu_cpfcnpj, .keep_all=TRUE)

  df_participantes %<>% dplyr::left_join(df_fornecedores) %>%
    dplyr::select(id_participante, dplyr::everything())
}

#' @title Realiza o join dos contratos mutados com os contratos
#' @param df_contratos dataframe com os contratos
#' @param df_contratos_mutados dataframe com os contratos mutados
#' @return Dataframe contendo informações dos contratos mutados com o id do contrato
#' @rdname join_contratos_mutados_contratos
#' @examples
#' join_contratos_mutados_contratos_dt <- join_contratos_mutados_contratos(
#'          df_contratos, df_contratos_mutados)
#'
join_contratos_mutados_contratos <- function(df_contratos_mutados, df_contratos) {
 df_contratos %<>% dplyr::select(id_contrato,nu_contrato)

  df_contratos_mutados %<>% dplyr::left_join(df_contratos) %>%
    dplyr::select(nu_contrato, cd_u_gestora, nu_cpfcnpj, nu_licitacao, dplyr::everything())
}

