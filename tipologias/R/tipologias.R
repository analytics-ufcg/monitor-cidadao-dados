
gera_tipologia_licitacao <- function(licitacao_df,
                                     contratos_processados_df,
                                     contratos_by_cnpj_df,
                                     licitacoes_vencedores_df_df,
                                     participantes_df){
  
  ## Cruza as propostas para licitações (a partir da lista de cnpjs) com todas as licitações do sagres usando a chave de licitação
  licitacoes_fornecedor <- participantes_df %>% 
    dplyr::select(-dt_ano) %>% 
    dplyr::inner_join(licitacoes, by = c("cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr:: mutate(dt_homologacao = as.Date(dt_homologacao, "%Y-%m-%d"))
  
  ## Filtra licitações deixando apenas aquelas com data de homologação anterior a data de início do contrato
  licitacoes_fornecedor_data <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_fornecedor, by = c("nu_cpfcnpj")) %>% 
    dplyr::rowwise() %>% 
    dplyr::filter(dt_homologacao < data_inicio) %>% 
    dplyr::ungroup()
  
  ## Calcula informações de vitória em licitações para os cnpjs das empresas
  licitacoes_fornecedor_vencedores <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_vencedores_df_df, by = "nu_cpfcnpj") %>% 
    dplyr::filter(min_dt_contrato < data_inicio) %>% 
    dplyr::left_join(licitacao_df %>% 
                       dplyr::select(cd_u_gestora, nu_licitacao, tp_licitacao, vl_licitacao), 
              by = c("cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr::filter(nu_licitacao != "000000000") %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_venceu = dplyr::n_distinct(nu_cpfcnpj, nu_licitacao, tp_licitacao),
              montante_lic_venceu = sum(vl_licitacao)) %>% 
    dplyr::ungroup()
  
  ## Cruza as features dos vencedores com todas as licitações (que serão usadas nas features)
  licitacoes_completa <- licitacoes_fornecedor_data %>% 
    dplyr::left_join(licitacoes_fornecedor_vencedores, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate(n_licitacoes_venceu = tidyr::replace_na(n_licitacoes_venceu, 0),
           montante_lic_venceu = tidyr::replace_na(montante_lic_venceu, 0))
  
  ## Calcula o número de licitações ganhas pela empresa até uma data limite
  n_licitacoes_empresa_ganhou <- licitacoes_fornecedor_vencedores %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, n_licitacoes_venceu)
  
  ## Calcula o número de licitações que a empresa participou até uma data limite
  n_licitacoes_empresa_participou <- licitacoes_fornecedor_data %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part = n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
  
  ## Calcula o número de licitações que a empresa participou e venceu parte1
  licitacoes_empresa_ganhou <- contratos_by_cnpj_df %>% 
    dplyr::left_join(licitacoes_vencedores_df, by = "nu_cpfcnpj") %>% 
    dplyr::filter(min_dt_contrato < data_inicio) %>% 
    dplyr::filter(nu_licitacao != "000000000")
  
  ## Calcula o número de licitações que a empresa participou e venceu parte2
  n_licitacoes_empresa_ganhou_participou <- licitacoes_fornecedor_data %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, cd_u_gestora, nu_licitacao, tp_licitacao, vl_licitacao) %>% 
    dplyr::inner_join(licitacoes_empresa_ganhou, by = c("nu_cpfcnpj", "data_inicio", "cd_u_gestora", "nu_licitacao", "tp_licitacao")) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part_venceu = n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
  
  perc_licitacoes_associadas <- contratos_by_cnpj_df %>% 
    dplyr::left_join(n_licitacoes_empresa_participou, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(n_licitacoes_empresa_ganhou, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(n_licitacoes_empresa_ganhou_participou, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("n_licitacoes"))) %>% 
    dplyr::mutate(perc_vitoria = n_licitacoes_venceu / (n_licitacoes_venceu + (n_licitacoes_part - n_licitacoes_part_venceu))) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("perc_vitoria")))
  
  licitacoes_features <- licitacoes_completa %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_licitacoes_part =  dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao),
              n_licitacoes_venceu = dplyr::first(n_licitacoes_venceu),
              montante_lic_venceu = dplyr::first(montante_lic_venceu)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(nu_cpfcnpj, data_inicio, n_licitacoes_part, n_licitacoes_venceu, montante_lic_venceu)
  
  ## Cálculo das médias de licitações que a empresa participou por ano e da média de licitações que a empresa tem empenhos associados
  media_licitacoes_part_empresa <- licitacoes_fornecedor_data %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(n_licitacoes = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_licitacoes_part = mean(n_licitacoes)) %>% 
    dplyr::ungroup()
  
  media_licitacoes_venceu_empresa <- licitacoes_empresa_ganhou %>% 
    dplyr::mutate(dt_Ano = as.numeric(substr(min_dt_contrato, 1, 4))) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_Ano) %>% 
    dplyr::summarise(n_licitacoes = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_licitacoes_venceu = mean(n_licitacoes)) %>% 
    dplyr::ungroup()
  
  # Merge das features
  licitacoes_features_merge <- licitacoes_features %>% 
    dplyr::left_join(perc_licitacoes_associadas %>% 
                       dplyr::select(nu_cpfcnpj, data_inicio, perc_vitoria), by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_licitacoes_part_empresa, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_licitacoes_venceu_empresa, by = c("nu_cpfcnpj", "data_inicio"))
  
  return(licitacoes_features_merge)
  
}

