
#' @description Filtra o Dataframe de propostas, a partir do Dataframe de contratos
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre o número de contratos por cnpj 
#' @param propostas_df Dataframe contendo informações sobre as propostas
#' @return Dataframe contendo informações sobre os fornecedores e suas propostas 
#' @rdname filter_propostas
#' @examples
#' propostas_filtradas <- filter_propostas(contratos_by_cnpj_df, propostas_df) 
filter_propostas <- function(contratos_by_cnpj_df, propostas_df) {
  propostas_filtradas_fornecedores <- contratos_by_cnpj_df %>% 
    dplyr::left_join(propostas_df, by = "nu_cpfcnpj") %>% 
    dplyr::mutate(dt_homologacao = as.Date(dt_homologacao, "%Y-%m-%d")) %>% 
    dplyr::filter(dt_homologacao < data_inicio)
}

#' @description Agrupa propostas por CNPJ e data de início
#' @param propostas_df Dataframe contendo informações sobre as propostas
#' @return Dataframe contendo informações sobre o número de propostas por CNPJ 
#' @rdname get_propostas_by_cnpj
#' @examples
#' propostas_group <- get_propostas_by_cnpj(propostas_df) 
get_propostas_by_cnpj <- function(propostas_df) {
  propostas_group <- propostas_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup()
}

#' @description Calcula a média de propostas por CNPJ
#' @param propostas_df Dataframe contendo informações sobre as propostas
#' @return Dataframe contendo informações sobre a média de propostas por CNPJ 
#' @rdname media_propostas_by_cnpj
#' @examples
#' media_propostas_group <- media_propostas_by_cnpj(propostas_df)
media_propostas_by_cnpj <- function(propostas_df) {
  media_propostas_group <- propostas_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_propostas = mean(n_propostas)) %>% 
    dplyr::ungroup()
}

#' @description Cruza features de propostas
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre o número de contratos por cnpj
#' @param propostas_by_cnpj_df Dataframe contendo informações sobre o número de propostas por CNPJ 
#' @param media_propostas_by_cnpj Dataframe contendo informações sobre a média de propostas por CNPJ
#' @return Dataframe contendo informações sobre as propostas e suas tipologias 
#' @rdname merge_features_propostas
#' @examples
#' propostas_features <- merge_features_propostas(contratos_by_cnpj_df, n_propostas_df, media_propostas_df) 
merge_features_propostas <- function(contratos_by_cnpj_df, propostas_by_cnpj_df, media_propostas_by_cnpj) {
  propostas_features <- contratos_by_cnpj_df %>%
    dplyr::left_join(propostas_by_cnpj_df, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_propostas_by_cnpj, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), 
                     .vars = dplyr::vars(dplyr::starts_with("n_propostas"), dplyr::starts_with("media_n_propostas")))
}


