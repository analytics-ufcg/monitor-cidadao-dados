
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
