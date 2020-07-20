
gera_tipologia_licitacao <- function(licitacao_df,
                                     contratos_processados_df,
                                     contratos_by_cnpj_df,
                                     licitacoes_vencedores_df,
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
    dplyr::summarise(n_licitacoes_part = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
  
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
    dplyr::summarise(n_licitacoes_part_venceu = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao))
  
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

gera_tipologia_proposta <- function(propostas_df, contratos_by_cnpj_df) {
  ano_inicial_sagres <- 2003
  
  propostas_filtradas_fornecedores <- contratos_by_cnpj_df %>% 
    dplyr::left_join(propostas_df, by = "nu_cpfcnpj") %>% 
    dplyr::mutate(dt_homologacao = as.Date(dt_homologacao, "%Y-%m-%d")) %>% 
    dplyr::filter(dt_homologacao < data_inicio)
  
  propostas_group <- propostas_filtradas_fornecedores %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup()
  
  media_propostas_group <- propostas_filtradas_fornecedores %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(n_propostas = dplyr::n_distinct(cd_u_gestora, nu_licitacao, tp_licitacao, cd_item, cd_sub_grupo_item, nu_cpfcnpj)) %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_n_propostas = mean(n_propostas)) %>% 
    dplyr::ungroup()
  
  propostas_features <- contratos_by_cnpj_df %>%
    dplyr::left_join(propostas_group, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::left_join(media_propostas_group, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), 
                     .vars = dplyr::vars(dplyr::starts_with("n_propostas"), dplyr::starts_with("media_n_propostas")))
  
  return(propostas_features)
}

gera_tipologia_contrato <- function(tipologias_df, contratos_df, contratos_raw) {
  
  contratos <- tipologias_df %>% 
    dplyr::select(cd_u_gestora, nu_contrato, nu_cpfcnpj, data_inicio, vl_total_contrato, total_ganho)
  
  ## Calcula a razão entre o valor do contrato e o total recebido pela empresa
  contratos_razao <- contratos %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = vl_total_contrato/ (vl_total_contrato + total_ganho)) %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = ifelse(is.infinite(razao_contrato_por_vl_recebido), NA, razao_contrato_por_vl_recebido)) %>% 
    dplyr::select(cd_u_gestora, nu_contrato, nu_cpfcnpj, data_inicio, razao_contrato_por_vl_recebido)
  
  cnpjs_contratos <- contratos %>% 
    dplyr::distinct(nu_cpfcnpj, data_inicio)
  
  ano_inicial_sagres <- 2003
  contratos_all <- contratos_raw
  
  # Calcula a quantidade de contratos por CNPJ e data (tomando como limite superior a data de início dos contratos para os CNPJ's)
  contratos_merge <- cnpjs_contratos %>% 
    dplyr::left_join(contratos_all) %>% 
    dplyr::filter(dt_assinatura < data_inicio) %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio, dt_ano) %>% 
    dplyr::summarise(num_contratos = dplyr::n_distinct(cd_u_gestora, nu_contrato)) %>% 
    dplyr::ungroup()
  
  contratos_data <- contratos_merge %>% 
    dplyr::group_by(nu_cpfcnpj, data_inicio) %>% 
    dplyr::summarise(media_num_contratos = mean(num_contratos),
              num_contratos = sum(num_contratos)) %>% 
    dplyr::ungroup()
  
  contratos_features <- contratos_razao %>% 
    dplyr::left_join(contratos_data, by = c("nu_cpfcnpj", "data_inicio")) %>% 
    dplyr::mutate_at(.funs = dplyr::funs(tidyr::replace_na(., 0)), .vars = dplyr::vars(dplyr::starts_with("num_contratos"), "media_num_contratos"))
  
  return(contratos_features)
  
}

merge_tipologias <- function(contratos_df, tipologias_licitacao_df, tipologias_proposta_df) {
  
  contratos_total_ganho <- contratos_df %>% #ISSO ESTA ERRADO, USAR PAGAMENTOS PARA FAZER ESSE CALCULO DO TOTAL GANHO
    dplyr::group_by(nu_cpfcnpj) %>% 
    dplyr::summarise(total_ganho = sum(vl_total_contrato))
  
  tipologias_merge <- contratos_df %>% 
    dplyr::left_join(tipologias_licitacao_df, by = c("nu_cpfcnpj" = "nu_cpfcnpj", "data_inicio" = "data_inicio")) %>% 
    dplyr::left_join(tipologias_proposta_df, by = c("nu_cpfcnpj" = "nu_cpfcnpj", "data_inicio" = "data_inicio")) %>% 
    dplyr::left_join(contratos_total_ganho) 
    #dplyr::select(-nu_cpfcnpj)
}