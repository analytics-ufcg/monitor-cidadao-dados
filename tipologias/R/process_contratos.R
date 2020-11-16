
#' @description Processa o Dataframe de contratos
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações processadas sobre os contratos
#' @rdname process_contratos
#' @examples
#' contratos <- process_contratos(contratos_df)
process_contratos <- function(contratos_df) {
  contratos_df %<>% dplyr::mutate(data_inicio = as.Date(dt_assinatura, "%Y-%m-%d")) %>% 
    dplyr::filter(!is.na(id_licitacao)) %>% 
    dplyr::select(cd_u_gestora, nu_licitacao, nu_contrato, dt_ano, data_inicio, nu_cpfcnpj, tp_licitacao, vl_total_contrato)
}

#' @description Conta o número de contratos por CNPJ
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre o número de contratos por cnpj
#' @rdname count_contratos_by_cnpj
#' @examples
#' cnpjs_datas <- count_contratos_by_cnpj(contratos_df)
count_contratos_by_cnpj <- function(contratos_df) {
  cnpjs_datas_contratos <- contratos_df %>%
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(nu_cpfcnpj, data_inicio) %>% 
    dplyr::filter(nu_cpfcnpj != "")
}

#' @description Busca os vencedores por contratos, na tabela de contratos
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre os vencedores dos contratos
#' @rdname get_vencedores_by_contratos
#' @examples
#' vencedores_by_contratos <- get_vencedores_by_contratos(contratos_df)
get_vencedores_by_contratos <- function(contratos_df){
  contratos_df %<>% 
    dplyr::group_by(cd_u_gestora, nu_licitacao, tp_licitacao, nu_cpfcnpj) %>% 
    dplyr::summarise(min_dt_contrato = min(dt_ano)) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(venceu = 1)  
}

#' @description Cruza as tipologias com os contratos
#' @param tipologias_df Dataframe contendo informações sobre as tipologias das licitações e propostas
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre contratos e tipologias 
#' @rdname join_tipologias_contratos
#' @examples
#' contratos <- join_tipologias_contratos(tipologias_df, contratos_df)
join_tipologias_contratos <- function(tipologias_df, contratos_df){
  contratos <- tipologias_df %>% 
    dplyr::left_join(contratos_df %>% dplyr::select(id_contrato, 
                                                     cd_u_gestora, 
                                                     dt_ano, 
                                                     nu_contrato, 
                                                     nu_licitacao, 
                                                     tp_licitacao, 
                                                     pr_vigencia, 
                                                     vigente)) %>% 
    dplyr::select(id_contrato,cd_u_gestora, nu_contrato, pr_vigencia, nu_cpfcnpj, data_inicio, vl_total_contrato, total_ganho, vigente) #BAD SMELL - Refatorar
}

#' @description Calcula a razão entre o valor do contrato e o total recebido pela empresa
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre o valor percentual recebido pela empresa
#' @rdname razao_contrato_recebido
#' @examples
#' contratos_razao <- razao_contrato_recebido(contratos_df)
razao_contrato_recebido <- function(contratos_df) {
  contratos_razao <- contratos_df %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = vl_total_contrato/ (vl_total_contrato + total_ganho)) %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = ifelse(is.infinite(razao_contrato_por_vl_recebido), NA, razao_contrato_por_vl_recebido)) %>% 
    dplyr::select(id_contrato, cd_u_gestora, nu_contrato, pr_vigencia, nu_cpfcnpj, data_inicio, razao_contrato_por_vl_recebido, vigente)
}

#' @description Busca contratos por CNPJ e data de início
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre os CNPJ associados aos contratos
#' @rdname get_cnpj
#' @examples
#' cnpjs_contratos <- get_cnpj(contratos_df)
get_cnpj <- function(contratos_df){
  cnpjs_contratos <- contratos_df %>% 
    dplyr::distinct(nu_cpfcnpj, data_inicio)
}

#' @description Calcula a quantidade de contratos por CNPJ e data (tomando como limite superior a data de início dos contratos para os CNPJ's)
#' @param cnpj_contratos_df Dataframe contendo CNPJ e data de início dos contratos
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre número de contratos associados aos CNPJ
#' @rdname n_contratos_by_cnpj
#' @examples
#' contratos_merge <- n_contratos_by_cnpj(cnpjs_contratos_df, contratos_df)
n_contratos_by_cnpj <- function(cnpj_contratos_df, contratos_df){
  contratos_merge <- cnpj_contratos_df %>% 
    dplyr::left_join(contratos_df) %>% 
    dplyr::filter(dt_assinatura < data_inicio) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(num_contratos = dplyr::n_distinct(cd_u_gestora, nu_contrato)) %>% 
    dplyr::ungroup()
}

#' @description Calcula a média de contratos por CNPJ
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre o número médio de contratos associados aos CNPJ
#' @rdname media_n_contratos_by_cnpj
#' @examples
#' contratos_data <- media_n_contratos_by_cnpj(contratos_df)
media_n_contratos_by_cnpj <- function(contratos_df){
  contratos_data <- contratos_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_num_contratos = mean(num_contratos),
                     num_contratos = sum(num_contratos)) %>% 
    dplyr::ungroup()
}

#' @description Cruza features de contratos
#' @param contratos_razao_df Dataframe contendo informações sobre o valor recebido pela empresa
#' @param contratos_df Dataframe contendo informações sobre o número médio de contratos associados aos CNPJ
#' @return Dataframe contendo informações sobre os contratos e suas tipologias
#' @rdname merge_features_contratos
#' @examples
#' contratos_features <- merge_features_contratos(contratos_razao_df, contratos_df)
merge_features_contratos <- function(contratos_razao_df, contratos_df){
  contratos_features <- contratos_razao_df %>% 
    dplyr::inner_join(contratos_df, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("num_contratos"), "media_num_contratos"))
}
  