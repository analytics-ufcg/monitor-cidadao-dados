filter_propostas <- function(contratos_by_cnpj_df, propostas_df) {
  propostas_filtradas_fornecedores <- contratos_by_cnpj_df %>% 
    dplyr::left_join(propostas_df, by = "nu_cpfcnpj") %>% 
    dplyr::mutate(dt_homologacao = as.Date(dt_homologacao, "%Y-%m-%d")) %>% 
    dplyr::filter(dt_homologacao < data_inicio)
}

get_propostas_by_cnpj <- function(propostas_df) {
  propostas_group <- propostas_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup()
  
}

media_propostas_by_cnpj <- function(propostas_df) {
  media_propostas_group <- propostas_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_propostas = mean(n_propostas)) %>% 
    dplyr::ungroup()
  
}

merge_features_propostas <- function(contratos_by_cnpj_df, propostas_by_cnpj_df, media_propostas_by_cnpj) {
  propostas_features <- contratos_by_cnpj_df %>%
    dplyr::left_join(propostas_by_cnpj_df, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_propostas_by_cnpj, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), 
                     .vars = dplyr::vars(dplyr::starts_with("n_propostas"), dplyr::starts_with("media_n_propostas")))
}


