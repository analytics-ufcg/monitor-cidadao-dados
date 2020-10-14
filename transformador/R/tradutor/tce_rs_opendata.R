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
    # dt_assinatura ok
    # tp_licitacao not exists
    # dt_mes_ano,
    # registro_cge,
    # cd_siafi,
    # dt_recebimento,
    # foto,
    # planilha,
    # ordem_servico,
    # language,
    # no_forcenedor,
    # cd_ibge,
    # uf,
    # mesorregiao_geografia,
    # microrregiao_geografia
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

    # nu_propostas x
    # tp_objeto
    # dt_mes_ano
    # registro_cge
    # tp_regime_execucao
    # de_ugestora
    # de_tipo_licitacao
    # cd_ibge
    # uf
    # mesorregiao_geografica
    # microrregiao_geografica

}


