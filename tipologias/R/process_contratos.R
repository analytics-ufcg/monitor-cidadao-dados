
process_contratos <- function(contratos_df) {
  contratos_df %<>% dplyr::mutate(data_inicio = as.Date(dt_assinatura, "%Y-%m-%d")) %>% 
    dplyr::select(cd_u_gestora, nu_contrato, dt_ano, data_inicio, nu_cpfcnpj, tp_licitacao, vl_total_contrato)
}

count_contratos_by_cnpj <- function(contratos_df) {
  cnpjs_datas_contratos <- contratos_df %>%
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(nu_cpfcnpj, data_inicio) %>% 
    dplyr::filter(nu_cpfcnpj != "")
}
