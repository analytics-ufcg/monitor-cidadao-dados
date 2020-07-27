#' @description Substitui valores NA, no Dataframe recebido, pelo valor 0 
#' @param tipologias_df Dataframe contendo as tipologias das licitações e das propostas, associadas aos contratos
#' @return Dataframe com valores NA substituidos por 0 nas colunas explicitadas
replace_nas <- function(tipologias_df) {
  tipologias_df %<>% dplyr::mutate_at(.funs =  dplyr::funs(tidyr::replace_na(., 0)), 
                                      .vars = dplyr::vars(
                                                   dplyr::starts_with("n_municipios"), dplyr::starts_with("n_ugestora"),
                                                   dplyr::starts_with("total_ganho"), dplyr::starts_with("media"),
                                                   dplyr::starts_with("montante_lic_venceu"), dplyr::starts_with("n_licitacoes_part"),
                                                   dplyr::starts_with("n_licitacoes_venceu"), dplyr::starts_with("n_propostas"),
                                                   dplyr::starts_with("n_contratos"), dplyr::starts_with("perc_vitoria")))
}