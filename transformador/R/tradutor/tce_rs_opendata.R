#' @param contratos_tce_rs_raw Dados brutos dos contratos do TCE
#' @return Dataframe contendo informações sobre os contratos do TCE-RS
#' @rdname translate_contratos_tce_rs
#' @examples
#' contratos_tce_rs_dt <- translate_contratos_tce_rs(contratos_tce_rs_raw)
translate_contratos_tce_rs <- function(contratos_tce_rs_raw){
  contratos_tce_rs_raw %<>% janitor::clean_names() %>%
    dplyr::rename(cd_u_gestora = cd_orgao) %>%
    dplyr::rename(dt_ano = ano_contrato) %>%
    dplyr::rename(nu_contrato = nr_contrato) %>%
    dplyr::rename(pr_vigencia = dt_final_vigencia) %>%
    dplyr::rename(nu_cpfcnpj = nr_documento) %>%
    dplyr::rename(nu_licitacao = nr_licitacao) %>%
    dplyr::rename(vl_total_contrato = vl_contrato) %>%
    dplyr::rename(de_obs = ds_objeto) %>%
    dplyr::rename(de_ugestora = nm_orgao)
}

#' @param orgaos_tce_rs_raw Dados brutos dos órgãos auditados pelo TCE-RS
#' @return Dataframe contendo informações sobre os órgãos
#' @rdname translate_orgaos_tce_rs
#' @examples
#' orgaos_tce_rs_dt <- translate_orgaos_tce_rs(orgaos_tce_rs_raw)
translate_orgaos_tce_rs <- function(orgaos_tce_rs_raw){
  orgaos_tce_rs_raw %<>% janitor::clean_names() %>%
    dplyr::rename(cd_u_gestora = cd_orgao) %>%
    dplyr::rename(de_ugestora = nome_orgao) %>%
    dplyr::rename(cd_ibge = cd_municipio_ibge)
}


#' @param licitacoes_tce_rs_raw Dados brutos das licitações do TCE
#' @return Dataframe contendo informações sobre as licitações do TCE-RS
#' @rdname translate_licitacoes_tce_rs
#' @examples
#' licitacoes_tce_rs_dt <- translate_licitacoes_tce_rs(licitacoes_tce_rs_raw)
translate_licitacoes_tce_rs <- function(licitacoes_tce_rs_raw){
  licitacoes_tce_rs_raw %<>% janitor::clean_names() %>%
    dplyr::rename(cd_u_gestora = cd_orgao) %>%
    dplyr::rename(dt_ano = ano_licitacao) %>%
    dplyr::rename(nu_licitacao = nr_licitacao) %>% #tp_licitacao, dt_homologacao,vl_licitacao ok
    dplyr::rename(de_obs = ds_objeto) %>%
    dplyr::rename(de_ugestora = nm_orgao)
}

#' @param pessoas_tce_rs_raw Dados brutos das pessoas/fornecedores
#' @return Dataframe contendo informações sobre os fornecedores da base do TCE-RS
#' @rdname translate_pessoas_tce_rs
#' @examples
#' pessoas_tce_rs_dt <- translate_pessoas_tce_rs(pessoas_tce_rs_raw)
translate_pessoas_tce_rs <- function(pessoas_tce_rs_raw){
  pessoas_tce_rs_raw %<>% janitor::clean_names() %>%
    dplyr::rename(cd_u_gestora = cd_orgao) %>%
    dplyr::rename(nu_cpfcnpj = nr_documento) %>%
    dplyr::rename(no_fornecedor = nm_pessoa)
}




