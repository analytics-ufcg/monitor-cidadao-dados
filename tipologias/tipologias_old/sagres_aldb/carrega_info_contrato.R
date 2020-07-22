# Features: 
# - Razão entre o valor do contrato e o montante total recebido até a data inicial do contrato
# - Número de contratos que celebrados com a empresa até a data de assinatura do contrato + Média por ano

#' @description Carrega a informações de contratos associadas a CNPJ's
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @param dados_contrato Informações dos contratos com pelo menos colunas informando o valor total do contrato e o montante recebido por ano
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @return Data frame com informações do contrato. Ex: Razão entre o valor do contrato e o montante recebido
carrega_info_contrato <- function(ano_inicial = 2011, ano_final = 2016, dados_contrato, limite_inferior = 0) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/load_fornecedores_pagamentos.R"))
    
    ## Soma o valor recebido pela empresa considerando todos os pagamentos anteriores a data de início do contrato
    contratos <- dados_contrato %>% 
        select(cd_UGestora, nu_Contrato, nu_CPFCNPJ, data_inicio, vl_TotalContrato, total_ganho)
    
    ## Calcula a razão entre o valor do contrato e o total recebido pela empresa
    contratos_razao <- contratos %>% 
        mutate(razao_contrato_por_vl_recebido = vl_TotalContrato/ (vl_TotalContrato + total_ganho)) %>% 
        mutate(razao_contrato_por_vl_recebido = ifelse(is.infinite(razao_contrato_por_vl_recebido), NA, razao_contrato_por_vl_recebido)) %>% 
        select(cd_UGestora, nu_Contrato, nu_CPFCNPJ, data_inicio, razao_contrato_por_vl_recebido)
    
    cnpjs_contratos <- contratos %>% 
        distinct(nu_CPFCNPJ, data_inicio)
    
    ano_inicial_sagres <- 2003
    contratos_all <- carrega_contratos(ano_inicial_sagres, ano_final, limite_inferior)
    
    # Calcula a quantidade de contratos por CNPJ e data (tomando como limite superior a data de início dos contratos para os CNPJ's)
    contratos_merge <- cnpjs_contratos %>% 
        left_join(contratos_all, by = c("nu_CPFCNPJ")) %>% 
        filter(dt_Assinatura < data_inicio) %>% 
        
        group_by(nu_CPFCNPJ, data_inicio, dt_Ano) %>% 
        summarise(num_contratos = n_distinct(cd_UGestora, nu_Contrato)) %>% 
        ungroup()
    
    contratos_data <- contratos_merge %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(media_num_contratos = mean(num_contratos),
                  num_contratos = sum(num_contratos)) %>% 
        ungroup()
    
    contratos_features <- contratos_razao %>% 
        left_join(contratos_data, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        mutate_at(.funs = funs(replace_na(., 0)), .vars = vars(starts_with("num_contratos"), "media_num_contratos"))
    
    return(contratos_features)
}