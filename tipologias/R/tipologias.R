source(here::here("R/process_licitacoes.R"))
source(here::here("R/process_propostas.R"))
source(here::here("R/process_contratos.R"))

#' @description Gera as tipologias do Dataframe de licitações
#' @param licitacao_df Dataframe contendo informações sobre as licitações
#' @param contratos_processados_df Dataframe contendo informações sobre os contratos
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre o número de contratos por cnpj
#' @param licitacoes_vencedores_df Dataframe contendo informações sobre os vencedores das licitações
#' @param participantes_df Dataframe contendo informações sobre os participantes das licitações
#' @return Dataframe contendo as tipologias das licitações
#' @rdname gera_tipologia_licitacao
#' @examples
#' tipologias_licitacao <- gera_tipologia_licitacao(licitacao_df, contratos_processados_df, contratos_by_cnpj_df, licitacoes_vencedoras_df, participantes_df)
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

#' @description Gera as tipologias do Dataframe de propostas
#' @param propostas_df Dataframe contendo informações sobre as propostas
#' @param contratos_by_cnpj_df Dataframe contendo informações sobre o número de contratos por CNPJ 
#' @return Dataframe contendo as tipologias das propostas
#' @rdname gera_tipologia_proposta
#' @examples
#' tipologias_proposta <- gera_tipologia_proposta(propostas_licitacoes, contratos_by_cnpj)
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

#' @description Gera as tipologias do Dataframe de contratos
#' @param tipologias_df Dataframe contendo informações sobre as tipologias das licitações e propostas
#' @param contratos_df Dataframe contendo informações processadas sobre os contratos
#' @param contratos_raw Dataframe contendo informações brutas sobre os contratos
#' @return Dataframe contendo as tipologias dos contratos
#' @rdname gera_tipologia_contrato
#' @examples
#' tipologias_contrato <- gera_tipologia_contrato(tipologias_df, contratos_processados_df, contratos_df)
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

gera_tipologia_fornecimento <- function(empenhos_data) {
  ## Separa nome dos Credores
  cnpjs_nome <- empenhos_data %>% 
    dplyr::group_by(cd_credor) %>% 
    dplyr::summarise(no_credor = dplyr::first(no_credor))
  
  ## Calcula o total ganho por Credor, Data, Unidade Gestora e Ano
  empenhos_group <- empenhos_data %>% 
    group_by(cd_credor, data, cd_u_gestora, dt_ano) %>% 
    summarise(total_ganho = sum(total_pago - replace_na(total_estornado, 0))) %>% 
    ungroup()
  
  ## Calcula a Feature do número de municípios agrupando por Credor e Ano
  empenhos_por_fornecedor_ano <- empenhos_group %>% 
    dplyr::mutate(cd_u_gestora_copy = cd_u_gestora) %>% 
    tidyr::separate(cd_u_gestora_copy, c('cd_u_gestora_prefix', 'cd_municipio'), -3) %>%
    dplyr::group_by(cd_credor, data, dt_ano) %>% 
    dplyr::summarise(n_municipios = dplyr::n_distinct(cd_municipio),
              n_ugestora = dplyr::n_distinct(cd_u_gestora),
              total_ganho = sum(total_ganho)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(cd_credor, data, dt_ano, n_municipios, n_ugestora, total_ganho)
  
  # empenhos_features <- empenhos_por_fornecedor_ano %>% 
  #   dplyr::group_by(cd_credor, data) %>% 
  #   dplyr::summarise(media_municipio = mean(n_municipios), # ordem das operações importa. Média calculada apenas para o anos com observações (fornecimento da empresa).
  #             n_municipios = sum(n_municipios),
  #             media_ugestora = mean(n_ugestora),
  #             n_ugestora = sum(n_ugestora),
  #             media_ganho = mean(total_ganho),
  #             total_ganho = sum(total_ganho)) %>% 
  #   dplyr::ungroup()
  # 
  empenhos_features_nome <- empenhos_por_fornecedor_ano %>% 
    dplyr::left_join(cnpjs_nome, by = "cd_credor") %>% 
    dplyr::select(cd_credor, no_credor, dplyr::everything())
  
  return(empenhos_features_nome)
}


#' @description Cruza as tipologias dos Dataframes de licitações e de propostas à tabela de contratos
#' @param contratos_df Dataframe contendo informações processadas sobre os contratos
#' @param tipologias_licitacao_df Dataframe contendo informações sobre as tipologias das licitações
#' @param tipologias_proposta_df Dataframe contendo informações sobre as tipologias das propostas
#' @param tipologias_fornecimento_df Dataframe contendo informações sobre as tipologias de fornecimento
#' @return Dataframe contendo as tipologias das licitações e das propostas, associadas aos contratos
#' @rdname merge_tipologias
#' @examples
#' tipologias_merge <- merge_tipologias(contratos_processados_df, tipologias_licitacao_df, tipologias_proposta_df) 
merge_tipologias <- function(contratos_df, tipologias_licitacao_df, tipologias_proposta_df, tipologias_fornecimento_df) {
  
  contratos_total_ganho <- contratos_df %>% #ISSO ESTA ERRADO, USAR PAGAMENTOS PARA FAZER ESSE CALCULO DO TOTAL GANHO
    dplyr::group_by(nu_cpfcnpj) %>% 
    dplyr::summarise(total_ganho = sum(vl_total_contrato))
  
  tipologias_merge <- contratos_df %>% 
    #dplyr::left_join(tipologias_fornecimento_df, by = c("nu_cpfcnpj" = "cd_credor", "data_inicio" = "data")) %>% 
    dplyr::left_join(tipologias_licitacao_df, by = c("nu_cpfcnpj" = "nu_cpfcnpj", "data_inicio" = "data_inicio")) %>% 
    dplyr::left_join(tipologias_proposta_df, by = c("nu_cpfcnpj" = "nu_cpfcnpj", "data_inicio" = "data_inicio")) %>% 
    dplyr::left_join(contratos_total_ganho) 
    #dplyr::select(-nu_cpfcnpj)
}
