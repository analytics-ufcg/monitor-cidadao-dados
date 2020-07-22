source(here::here("R/process_licitacoes.R"))
source(here::here("R/process_propostas.R"))

gera_tipologia_licitacao <- function(licitacao_df,
                                     contratos_processados_df,
                                     contratos_by_cnpj_df,
                                     licitacoes_vencedores_df,
                                     participantes_df){

  print("Buscando informações dos fornecedores...")
  licitacoes_fornecedor <- get_fornecedores_licitacao(licitacao_df, participantes_df, contratos_by_cnpj_df)

  print("Buscando informações dos vencedores...")
  licitacoes_fornecedor_vencedores <- get_info_vencedores(licitacao_df, contratos_by_cnpj_df, licitacoes_vencedores_df) 

  print("Cruzando fornecedores e vencedores...")
  licitacoes_completa <- join_fornecedores_e_vencedores(licitacoes_fornecedor, licitacoes_fornecedor_vencedores)

  print("Calculando numero de vitórias...")
  n_licitacoes_empresa_ganhou <- n_vitorias(licitacoes_fornecedor_vencedores)
  
  print("Calculando numero de participações...")
  n_licitacoes_empresa_participou <- n_participacoes(licitacoes_fornecedor)

  print("Buscando licitações ganhas...")
  licitacoes_empresa_ganhou <- get_licitacoes_ganhas(contratos_by_cnpj_df, licitacoes_vencedores_df)

  print("Buscando licitações que empresa participou e ganhou...")
  n_licitacoes_empresa_ganhou_participou <- get_participacoes_ganhas(licitacoes_fornecedor, licitacoes_empresa_ganhou)
  
  print("Calculando percentual de licitações associadas...")
  perc_licitacoes_associadas <- get_perc_licitacoes_associadas(contratos_by_cnpj_df, 
                                                               n_licitacoes_empresa_participou, 
                                                               n_licitacoes_empresa_ganhou, 
                                                               n_licitacoes_empresa_ganhou_participou)
  print("Filtrando features de licitações...")
  licitacoes_features <- filter_licitacoes_features(licitacoes_completa) 
  
  print("Calculando média de participações de uma empresa...")
  media_licitacoes_part_empresa <- media_participacoes_by_empresa(licitacoes_fornecedor)
  
  print("Calculando média de vitórias de uma empresa...")
  media_licitacoes_venceu_empresa <- media_vitorias_by_empresa(licitacoes_empresa_ganhou) 
  
  print("Cruzando features das licitações...")
  licitacoes_features_merge <- merge_features_licitacoes(licitacoes_features, 
                                              perc_licitacoes_associadas,
                                              media_licitacoes_part_empresa, 
                                              media_licitacoes_venceu_empresa)
  
  return(licitacoes_features_merge)
  
}

gera_tipologia_proposta <- function(propostas_df, contratos_by_cnpj_df) {
  
  print("Filtrando propostas...")
  propostas_filtradas_fornecedores <- filter_propostas(contratos_by_cnpj_df, propostas_df) 
  
  print("Agrupando propostas...")
  propostas_group <- get_propostas_by_cnpj(propostas_filtradas_fornecedores) 
  
  print("Calculando média de propostas por cnpj...")
  media_propostas_group <- media_propostas_by_cnpj(propostas_filtradas_fornecedores)
  
  print("Cruzando features das propostas...")
  propostas_features <- merge_features_propostas(contratos_by_cnpj_df, propostas_group, media_propostas_group) 
  
  return(propostas_features)
}

gera_tipologia_contrato <- function(tipologias_df, contratos_df, contratos_raw) {
  
  contratos <- tipologias_df %>% 
    dplyr::left_join(contratos_raw %>% dplyr::select(id_contrato, 
                                                     cd_u_gestora, 
                                                     dt_ano, 
                                                     nu_contrato, 
                                                     nu_licitacao, 
                                                     tp_licitacao)) %>% 
    dplyr::select(id_contrato,cd_u_gestora, nu_contrato, nu_cpfcnpj, data_inicio, vl_total_contrato, total_ganho) #BAD SMELL - Refatorar

  
  ## Calcula a razão entre o valor do contrato e o total recebido pela empresa
  contratos_razao <- contratos %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = vl_total_contrato/ (vl_total_contrato + total_ganho)) %>% 
    dplyr::mutate(razao_contrato_por_vl_recebido = ifelse(is.infinite(razao_contrato_por_vl_recebido), NA, razao_contrato_por_vl_recebido)) %>% 
    dplyr::select(id_contrato, cd_u_gestora, nu_contrato, nu_cpfcnpj, data_inicio, razao_contrato_por_vl_recebido)
  
  cnpjs_contratos <- contratos %>% 
    dplyr::distinct(nu_cpfcnpj, data_inicio)
  
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