library(magrittr)

source(here::here("R/utils.R"))

#' @title Gera um identificador único para cada contrato do RS
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre os contratos e seus ids
#' @rdname generate_contrato_id
#' @examples
#' contratos_tce_rs_dt <- generate_contrato_tce_rs_id(contrato_df)
generate_contrato_tce_rs_id <- function(contratos_tce_rs_dt) {
  contratos_tce_rs_dt %<>% .generate_hash_id(c("cd_u_gestora", "nu_cpfcnpj", "ano_licitacao","nu_licitacao",
                                        "cd_tipo_modalidade", "nu_contrato", "dt_ano",
                                        "tp_instrumento"),
                                       "id_contrato") %>%
    dplyr::select(id_contrato, dplyr::everything())
}

#' @title Gera um identificador único para cada licitação do RS
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @return Dataframe contendo informações sobre as licitações e seus ids
#' @rdname generate_licitacao_tce_rs_id
#' @examples
#' licitacoes_tce_rs_dt <- generate_licitacao_tce_rs_id(licitacoes_tce_rs_dt)
generate_licitacao_tce_rs_id <- function(licitacoes_tce_rs_dt) {
  licitacoes_tce_rs_dt %<>% .generate_hash_id(c("cd_u_gestora", "nu_licitacao", "dt_ano", "cd_tipo_modalidade"),
                                      "id_licitacao") %>%
    dplyr::select(id_licitacao, dplyr::everything())
}


#' @title Processa dataframe de contratos
#' @description Manipula a tabela pra forma que será utilizada no banco
#' @param contratos_df Dataframe contendo informações dos contratos
#' @return Dataframe contendo informações dos contratos processados
process_contrato_tce_rs <- function(contratos_df) {
    contratos_df %<>% generate_contrato_tce_rs_id() %>%
    dplyr::mutate(language = 'portuguese')
}

#' @title Processa dataframe de licitações
#' @description Manipula a tabela pra forma que será utilizada no banco
#' @param licitacoes_df Dataframe contendo informações das licitações
#' @return Dataframe contendo informações das licitações processados
process_licitacao_tce_rs <- function(licitacoes_df) {
  licitacoes_df %<>% generate_licitacao_tce_rs_id()
}

#' @title Processa dataframe de licitações
#' @description Manipula a tabela para se adequar aos outros estados
#' @param licitacoes_df Dataframe contendo informações das licitações
#' @return Dataframe contendo informações das licitações processados
format_licitacao_tce_rs <- function(licitacoes_transformadas_rs_df) {
  colunas_licitacoes <- c("id_licitacao", "cd_u_gestora", "dt_ano", "nu_licitacao", "tp_licitacao", "dt_homologacao",
                         "nu_propostas", "vl_licitacao", "tp_objeto", "de_obs", "dt_mes_ano", "registro_cge", "tp_regime_execucao",
                         "de_ugestora", "de_tipo_licitacao", "cd_ibge", "uf", "mesorregiao_geografica", "microrregiao_geografica")

  licitacoes_rs_formatadas <- fncols(licitacoes_transformadas_rs_df, colunas_licitacoes) %>%
    dplyr::select(colunas_licitacoes)
}

#' @title Processa dataframe dos contratos
#' @description Manipula a tabela para se adequar aos outros estados
#' @param contratos_df Dataframe contendo informações dos contratos
#' @return Dataframe contendo informações dos contratos processados
format_contrato_tce_rs <- function(contratos_transformados_rs_df) {
  colunas_contratos <- c("id_contrato", "id_licitacao", "cd_u_gestora", "dt_ano", "nu_contrato",
                         "dt_assinatura", "pr_vigencia", "nu_cpfcnpj", "nu_licitacao", "tp_licitacao",
                         "vl_total_contrato", "de_obs", "dt_mes_ano", "registro_cge", "cd_siafi", "dt_recebimento",
                         "foto",	"planilha", "ordem_servico", "language", "de_ugestora", "no_fornecedor", "cd_ibge", "uf",
                         "mesorregiao_geografica", "microrregiao_geografica")

  contratos_rs_formatados <-fncols(contratos_transformados_rs_df, colunas_contratos) %>%
    dplyr::select(colunas_contratos)
}





