source(here::here("R/process_licitacoes.R"))
source(here::here("R/process_propostas.R"))
source(here::here("R/process_contratos.R"))


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
  
  print("Cruzando tipologias e contratos...")
  contratos <- join_tipologias_contratos(tipologias_df, contratos_raw)
  
  print("Calculando razão do valor do contrato...")
  contratos_razao <- razao_contrato_recebido(contratos)

  print("Buscando contratos por cnpj...")
  cnpjs_contratos <- get_cnpj(contratos)
  
  print("Cruzando tipologias e contratos/cnpj...")
  contratos_merge <- n_contratos_by_cnpj(cnpjs_contratos, contratos_raw)
  
  print("Calculando media de contratos/cnpj...")
  contratos_data <- media_n_contratos_by_cnpj(contratos_merge)
  
  print("Cruzando features dos contratos...")
  contratos_features <- merge_features_contratos(contratos_razao, contratos_data)

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