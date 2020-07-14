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
    dplyr::select(id_licitacao, cd_municipio, dplyr::everything())
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

#' @title Gera um identificador único para cada participante
#' @param participantes_df Dataframe contendo informações sobre os participantes
#' @return Dataframe contendo informações sobre os participantes e seus ids
#' @rdname generate_participante_id
#' @examples
#' participantes_dt <- generate_licitacao_id(licitacoes_df)
generate_participante_id <- function(participantes_df) {
  participantes_df %<>% .generate_hash_id(c("nu_licitacao", "dt_ano",
                                            "cd_u_gestora", "tp_licitacao", "nu_cpfcnpj"),
                                       "id_participante") %>%
    dplyr::select(id_participante, dplyr::everything())
}

#' @title Gera um identificador único para cada proposta
#' @param propostas_df Dataframe contendo informações sobre as propostas
#' @return Dataframe contendo informações sobre as propostas e seus ids
#' @rdname generate_proposta_id
#' @examples
#' propostas_dt <- generate_proposta_id(propostas_df)
generate_proposta_id <- function(propostas_df) {
  propostas_df %<>% .generate_hash_id(c("cd_u_gestora", "nu_licitacao",
                                        "tp_licitacao", "nu_cpfcnpj"),
                                      "id_proposta") %>%
    dplyr::select(id_proposta, dplyr::everything())
}

#' @title Processa dataframe de contratos
#' @description Manipula tabela pra forma que será utilizada no banco
#' @param contratos_df Dataframe contendo informações dos contratos
#' @return Dataframe contendo informações dos contratos processados
process_contrato <- function(contratos_df) {
  contratos_df %<>% .extract_cd_municipio("cd_u_gestora") %>%
    dplyr::filter(cd_municipio != "612") %>%  #registro preenchido errado
    generate_contrato_id() %>%
    dplyr::mutate(language = 'portuguese')
}

#' @title Processa dataframe de licitações
#' @description Manipula tabela pra forma que será utilizada no banco
#' @param licitacoes_df Dataframe contendo informações das licitações
#' @return Dataframe contendo informações das licitações processados
process_licitacao <- function(licitacoes_df) {
  licitacoes_df %<>% .extract_cd_municipio("cd_u_gestora") %>%
    generate_licitacao_id()
}

#' @title Processa dataframe dos participantes
#' @description Manipula tabela que será utilizada no banco
#' @param participantes_df Dataframe contendo informações dos participantes
#' @return Dataframe contendo informações os participantes processados
process_participante <- function(participantes_df) {
  participantes_df %<>% generate_participante_id()
}

#' @title Processa dataframe de municipios
#' @description Manipula tabela pra forma que será utilizada no banco
#' @param municipios_df Dataframe contendo informações dos municipios
#' @return Dataframe contendo informações dos municipios processados
process_municipio <- function(municipios_df) {
  municipios_df %<>% dplyr::select(cd_municipio, dplyr::everything())
}

#' @title Processa dataframe de propostas
#' @description Manipula tabela pra forma que será utilizada no banco
#' @param propostas_df Dataframe contendo informações das propostas
#' @return Dataframe contendo informações das propostas processadss
process_proposta <- function(propostas_df) {
  propostas_df %<>% generate_proposta_id()
}
