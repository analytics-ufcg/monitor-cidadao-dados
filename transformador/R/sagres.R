library(magrittr)

source(here::here("R/utils.R"))

#' @title Gera um identificador único para cada licitação
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @return Dataframe contendo informações sobre as licitações e seus ids
#' @rdname generate_licitacao_id
#' @examples
#' licitacoes_dt <- generate_licitacao_id(licitacoes_df)
generate_licitacao_id <- function(licitacoes_df) {
  licitacoes_df %<>% .generate_hash_id(c("cd_u_gestora", "dt_ano",
                                        "nu_licitacao", "tp_licitacao"),
                                      "id_licitacao") %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Gera um identificador único para cada contrato
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre os contratos e seus ids
#' @rdname generate_contrato_id
#' @examples
#' contratos_dt <- generate_contrato_id(contrato_df)
generate_contrato_id <- function(contratos_df) {
  contratos_df %<>% .generate_hash_id(c("cd_u_gestora", "dt_ano",
                                         "nu_licitacao", "tp_licitacao", "nu_contrato"),
                                       "id_contrato") %>%
    dplyr::select(id_contrato, dplyr::everything())
} 

#' Extrai o código do município do código da unidade gestora. 
#' Essa estração é feita através da coleta dos últimos 3 digitos da unidade gestora.
#' @param df Dataframe sem o código do município
#' @param cd_u_gestora código da unidade gestora
#' @return Dataframe com o código do município
process_contrato <- function(contratos_df) {
  contratos_df %<>% .extract_cd_municipio("cd_u_gestora") %>% 
    generate_contrato_id()
} 