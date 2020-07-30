#' @description Cruza os participantes para as licitações com todas as licitações do Sagre
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @param participantes_df Dataframe contendo informações sobre os participantes
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre os contratos por cnpj 
#' @return Dataframe contendo os fornecedores das licitações, com data de homologação anterior a data de início do contrato
#' @rdname get_vencedores_by_contratos
#' @examples
#' licitacoes_fornecedor <- get_fornecedores_licitacao(licitacao_df, participantes_df, contratos_by_cnpj_df)
get_fornecedores_licitacao <- function(licitacoes_df, participantes_df, contratos_by_cnpj_df) {
  licitacoes_fornecedor <- participantes_df %>% 
    dplyr::select(-dt_ano) %>% 
    dplyr::inner_join(licitacoes_df, by = c("cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr:: mutate(dt_homologacao = as.Date(dt_homologacao, "%Y-%m-%d"))
  
  ## Filtra licitações deixando apenas aquelas com data de homologação anterior a data de início do contrato
  licitacoes_fornecedor_data <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_fornecedor, by = c("nu_cpfcnpj")) %>% 
    dplyr::rowwise() %>% 
    dplyr::filter(dt_homologacao < data_inicio) %>% 
    dplyr::ungroup()
}

#' @description Calcula informações de vitória em licitações para os cnpjs das empresas
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre os contratos por cnpj 
#' @param licitacoes_vencedores_df Dataframe contendo informações sobre as licitações vencedoras 
#' @return Dataframe contendo informações sobre a quantidade de vitórias em licitações das empresas
#' @rdname get_info_vencedores
#' @examples
#' licitacoes_fornecedor_vencedores <- get_info_vencedores(licitacao_df, contratos_by_cnpj_df, licitacoes_vencedores_df) 
get_info_vencedores <- function(licitacao_df, contratos_by_cnpj_df, licitacoes_vencedores_df) {
  licitacoes_fornecedor_vencedores <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_vencedores_df, by = "nu_cpfcnpj") %>% 
    dplyr::filter(min_dt_contrato < data_inicio) %>% 
    dplyr::left_join(licitacao_df %>% 
                       dplyr::select(cd_u_gestora, nu_licitacao, tp_licitacao, vl_licitacao), 
                     by = c("cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr::filter(nu_licitacao != "000000000") %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_venceu = dplyr::n_distinct(nu_cpfcnpj, nu_licitacao, tp_licitacao),
                     montante_lic_venceu = sum(vl_licitacao)) %>% 
    dplyr::ungroup()
}


#' @description Cruza as features dos vencedores com os fornecedores
#' @param fornecedores_df Dataframe contendo informações sobre os participantes
#' @param vencedores_df Dataframe contendo informações sobre os vencedores de licitações 
#' @return Dataframe contendo informações sobre fornecedores e vencedores das licitações
#' @rdname join_fornecedores_e_vencedores
#' @examples
#' licitacoes_completa <- join_fornecedores_e_vencedores(licitacoes_fornecedor, licitacoes_fornecedor_vencedores)
join_fornecedores_e_vencedores <- function(fornecedores_df, vencedores_df) {
  licitacoes_completa <- fornecedores_df %>% 
    dplyr::left_join(vencedores_df, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate(n_licitacoes_venceu = tidyr::replace_na(n_licitacoes_venceu, 0),
                  montante_lic_venceu = tidyr::replace_na(montante_lic_venceu, 0))
}

#' @description Calcula o número de licitações ganhas pela empresa até uma data limite
#' @param vencedores_df Dataframe contendo informações sobre os vencedores de licitações 
#' @return Dataframe com o número de vezes que a empresa ganhou uma licitação
#' @rdname n_vitorias
#' @examples
#' n_licitacoes_empresa_ganhou <- n_vitorias(licitacoes_fornecedor_vencedores)
n_vitorias <- function(vencedores_df) {
  n_licitacoes_empresa_ganhou <- vencedores_df %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, n_licitacoes_venceu)
}

#' @description Calcula o número de licitações que a empresa participou até uma data limite
#' @param fornecedores_df Dataframe contendo informações sobre os participantes de uma licitações 
#' @return O número de vezes que a empresa participou de licitações
#' @rdname n_participacoes
#' @examples
#' n_licitacoes_empresa_participou <- n_participacoes(licitacoes_fornecedor)
n_participacoes <- function(fornecedores_df) {
  n_licitacoes_empresa_participou <- fornecedores_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
}

#' @description Calcula informações de licitações que a empresa participou e venceu
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre os contratos por cnpj 
#' @param licitacoes_vencedores_df Dataframe contendo informações sobre as licitações vencedoras 
#' @return Dataframe com as licitações que a empresa ganhou
#' @rdname get_licitacoes_ganhas
#' @examples
#' licitacoes_empresa_ganhou <- get_licitacoes_ganhas(contratos_by_cnpj_df, licitacoes_vencedores_df)
get_licitacoes_ganhas <- function(contratos_by_cnpj_df, licitacoes_vencedores_df) {
  licitacoes_empresa_ganhou <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_vencedores_df, by = "nu_cpfcnpj") %>% 
    dplyr::filter(min_dt_contrato < data_inicio) %>% 
    dplyr::filter(nu_licitacao != "000000000")
}

#' @description Calcula o número de licitações que a empresa participou e venceu
#' @param fornecedores_df Dataframe contendo informações sobre participantes das licitações
#' @param licitacoes_ganhas_df Dataframe contendo informações sobre as licitações vencedoras 
#' @return A quantidade de licitações que a empresa ganhou
#' @rdname get_participacoes_ganhas
#' @examples
#' n_licitacoes_empresa_ganhou_participou <- get_participacoes_ganhas(licitacoes_fornecedor, licitacoes_empresa_ganhou)
get_participacoes_ganhas <- function(fornecedores_df, licitacoes_ganhas_df) {
  n_licitacoes_empresa_ganhou_participou <- fornecedores_df %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, cd_u_gestora, nu_licitacao, tp_licitacao, vl_licitacao) %>% 
    dplyr::inner_join(licitacoes_ganhas_df, by = c("nu_cpfcnpj", "data_inicio", "cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part_venceu = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
}

#' @description Calcula o percentual de licitações vencidas por empresa
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre os contratos por cnpj
#' @param n_participacoes Dataframe contendo o numero de participações das 
#' @param n_vitorias Dataframe contendo o número de vitórias da empresa
#' @param n_participacoes_ganhas Dataframe contendo o numero de participações que as empresas ganharam
#' @return O percentual de licitações vencidas por empresa
#' @rdname get_perc_licitacoes_associadas
#' @examples
#' perc_licitacoes_associadas <- get_perc_licitacoes_associadas(contratos_by_cnpj_df, n_licitacoes_empresa_participou,n_licitacoes_empresa_ganhou,n_licitacoes_empresa_ganhou_participou)
get_perc_licitacoes_associadas <- function(contratos_by_cnpj_df, n_participacoes, n_vitorias, n_participacoes_ganhas) {
  perc_licitacoes_associadas <- contratos_by_cnpj_df %>% 
    dplyr::left_join(n_participacoes, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(n_vitorias, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(n_participacoes_ganhas, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("n_licitacoes"))) %>% 
    dplyr::mutate(perc_vitoria = n_licitacoes_venceu / (n_licitacoes_venceu + (n_licitacoes_part - n_licitacoes_part_venceu))) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("perc_vitoria")))
}

#' @description Filtra as features das licitações
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @return Dataframe com algumas features selecionadas (nu_cpfcnpj, data_inicio, n_licitacoes_part, n_licitacoes_venceu, montante_lic_venceu)
#' @rdname filter_licitacoes_features
#' @examples
#' licitacoes_features <- filter_licitacoes_features(licitacoes_completa) 
filter_licitacoes_features <- function(licitacoes_df) {
  licitacoes_features <- licitacoes_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part =  dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao),
                     n_licitacoes_venceu = dplyr::first(n_licitacoes_venceu),
                     montante_lic_venceu = dplyr::first(montante_lic_venceu)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, n_licitacoes_part, n_licitacoes_venceu, montante_lic_venceu)
}

#' @description Cálculo das médias de licitações que a empresa participou por ano e da média de licitações que a empresa tem empenhos associados
#' @param licitacoes_fornecedores_df Dataframe contendo informações sobre os participantes de licitações 
#' @return Dataframe com a média de licitações que a empresa participou
#' @rdname media_participacoes_by_empresa
#' @examples
#' media_licitacoes_part_empresa <- media_participacoes_by_empresa(licitacoes_fornecedor)
media_participacoes_by_empresa <- function(licitacoes_fornecedores_df) {
  media_licitacoes_part_empresa <- licitacoes_fornecedores_df %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(n_licitacoes = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_licitacoes_part = mean(n_licitacoes)) %>% 
    dplyr::ungroup()
}

#' @description Cálculo das médias de vitórias em licitações por empresa
#' @param licitacoes_ganhas_df Dataframe contendo informações sobre as licitações ganhas 
#' @return Dataframe com a média de vitórias da empresa 
#' @rdname media_vitorias_by_empresa
#' @examples
#' media_licitacoes_venceu_empresa <- media_vitorias_by_empresa(licitacoes_empresa_ganhou) 
media_vitorias_by_empresa <- function(licitacoes_ganhas_df) {
  media_licitacoes_venceu_empresa <- licitacoes_ganhas_df %>% 
    dplyr::mutate(dt_Ano = as.numeric(substr(min_dt_contrato, 1, 4))) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_Ano) %>% 
    dplyr::summarise(n_licitacoes = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_licitacoes_venceu = mean(n_licitacoes)) %>% 
    dplyr::ungroup()
}

#' @description Merge das informações das licitações com cálculos de média e percentuais sobre as mesmas
#' @param licitacoes_features_df Dataframe contendo informações sobre as licitações 
#' @param perc_licitacoes_associadas_df Dataframe contendo informações sobre percentual das licitações vencedoras 
#' @param media_licitacoes_part_empresa_df Dataframe contendo informações sobre média de participações da empresas em licitações 
#' @param media_licitacoes_venceu_empresa_df Dataframe contendo informações sobre médias de participações ganhas por empresa
#' @return Dataframe com a as informações das licitações junto com médias calculadas 
#' @rdname merge_features_licitacoes
#' @examples
#' licitacoes_features_merge <- merge_features_licitacoes(licitacoes_features, perc_licitacoes_associadas,media_licitacoes_part_empresa, media_licitacoes_venceu_empresa)                                                                                                                                         
merge_features_licitacoes <- function(licitacoes_features_df, 
                           perc_licitacoes_associadas_df,
                           media_licitacoes_part_empresa_df, 
                           media_licitacoes_venceu_empresa_df) {
  
  licitacoes_features_merge <- licitacoes_features_df %>% 
    dplyr::left_join(perc_licitacoes_associadas_df %>% 
                       dplyr::select(nu_cpfcnpj, data_inicio, perc_vitoria), by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_licitacoes_part_empresa_df, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_licitacoes_venceu_empresa_df, by = c("nu_cpfcnpj", "data_inicio"))
}


