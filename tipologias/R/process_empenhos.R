process_empenhos <- function(empenhos, pagamentos, estorno_pagamentos, contratos_by_cnpj) {
  
  
  lista_cnpjs <- contratos_by_cnpj %>% 
    dplyr::distinct(nu_cpfcnpj) %>% 
    dplyr::pull(nu_cpfcnpj)
  
  datas_lista <- contratos_by_cnpj %>% 
    dplyr::distinct(data_inicio) %>% 
    dplyr::pull(data_inicio)
  
  ## Carrega as informações de empenho 
  ## (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, total_pago, total_estornado)
  empenhos_data <- tibble::tibble(data = datas_lista) %>%
    dplyr::mutate(dados = purrr::map(
      data,
      empenhos_credores_data,
      empenhos,
      pagamentos,
      estorno_pagamentos,
      contratos_by_cnpj
    )) %>% 
    tidyr::unnest(dados)
}

#' @description Cruza informações sobre empenhos, pagamentos e estornos a partir de uma data de limite. Retorna todos os empenhos até esta data.
#' @param data_limite_superior Data limite para a data do pagamento e do estorno
#' @param empenhos Data frame com todos os empenhos recuperados do SAGRES
#' @param pagamentos Data frame com todos os pagamentos recuperados do SAGRES
#' @param estorno_pagamentos Data frame com todos os estornos de pagamentos recuperados do SAGRES
#' @param contratos_by_cnpj Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações do empenho, do valor de pagamentos associados a este empenho e o valor estornado associado aos pagamentos
#' Data frame retornado (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, total_pago, total_estornado)
empenhos_credores_data <- function(data_limite_superior, empenhos, pagamentos, estorno_pagamentos, contratos_by_cnpj) {
  library(tidyverse)
  
  lista_cnpjs <- contratos_by_cnpj %>% 
    dplyr::filter(data_inicio == data_limite_superior) %>% 
    dplyr::distinct(nu_cpfcnpj) %>% 
    dplyr::pull(nu_cpfcnpj)
  
  empenhos_credor <- empenhos %>% 
    dplyr::filter(cd_credor %in% lista_cnpjs)
  
  pagamentos_data <- pagamentos %>% 
    dplyr::filter(dt_pagamento < data_limite_superior) %>% 
    dplyr::inner_join(empenhos_credor %>% dplyr::select(id_empenho))
  
  estornos_pagamento_data <- estorno_pagamentos %>% 
    dplyr::filter(dt_estorno < data_limite_superior)
  
  pagamentos_data_merge <- pagamentos_data %>% 
    dplyr::left_join(estornos_pagamento_data, by = c("cd_u_gestora" = "cd_u_gestora", "cd_unid_orcamentaria" = "cd_unid_orcamentaria",
                                              "nu_empenho" = "nu_empenho_estorno", "nu_parcela" = "nu_parcela_estorno", 
                                              "tp_lancamento" = "tp_lancamento", "dt_ano" = "dt_ano")) %>% 
    dplyr::mutate(vl_estorno = tidyr::replace_na(vl_estorno, 0)) %>% 
    dplyr::group_by(cd_u_gestora, dt_ano, cd_unid_orcamentaria, nu_empenho, nu_parcela, tp_lancamento) %>% 
    dplyr::summarise(vl_pagamento = dplyr::first(vl_pagamento),
              total_estornado = sum(vl_estorno)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(cd_u_gestora, nu_empenho, cd_unid_orcamentaria, dt_ano, total_pago = vl_pagamento, total_estornado)
  
  empenhos_credor_merge <- empenhos_credor %>% 
    dplyr::inner_join(pagamentos_data_merge, by = c("cd_u_gestora", "nu_empenho", "cd_unid_orcamentaria", "dt_ano")) %>% 
    dplyr::group_by(cd_credor, cd_u_gestora, dt_ano, cd_unid_orcamentaria, nu_empenho) %>% 
    dplyr::summarise(nu_licitacao = dplyr::first(nu_licitacao),
              tp_licitacao = dplyr::first(tp_licitacao),
              no_credor = dplyr::first(no_credor),
              total_pago = sum(total_pago),
              total_estornado = sum(total_estornado)) %>% 
    dplyr::ungroup()
  
  return(empenhos_credor_merge)
}
