# Features:
# - Número de Municípios para os quais a empresa forneceu serviço até a data de assinatura do contrato + Média por ano
# - Montante total de dinheiro recebido público recebido pela empresa até a data de assinatura do contrato + Média por ano
# - Número de Unidades Gestoras para as quais a empresa forneceu serviço até a data de assinatura do contrato + Média por ano

## Ano inicial considerado para o cálculo das informações de empenhos eé o ano inicial do SAGRES.
#' @description Calcula informações sobre o fornecimento de uma lista de CNPj's. 
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações sobre as empresas com uma data de limite superior como número de municípios com fornecimento, total de dinheiro recebido.
carrega_info_fornecimento <- function(ano_inicial, ano_final, cnpjs_datas_contratos) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/carrega_empenhos.R"))
    
    datas_lista <- cnpjs_datas_contratos %>%
        distinct(data_inicio) %>% 
        mutate(data_inicio = as.character(data_inicio)) %>% 
        pull(data_inicio)
    
    ## Ano inicial considerado para o cálculo das informações de empenhos eé o ano inicial do SAGRES.
    ano_inicial_sagres <- 2003
    empenhos_data <- carrega_empenhos_data_limite(ano_inicial_sagres, ano_final, cnpjs_datas_contratos)
    
    ## Separa nome dos Credores
    cnpjs_nome <- empenhos_data %>% 
        group_by(cd_Credor) %>% 
        summarise(no_Credor = first(no_Credor))
    
    ## Calcula o total ganho por Credor, Data, Unidade Gestora e Ano
    empenhos_group <- empenhos_data %>% 
        group_by(cd_Credor, data, cd_UGestora, dt_Ano) %>% 
        summarise(total_ganho = sum(total_pago - replace_na(total_estornado, 0))) %>% 
        ungroup()
    
    ## Calcula a Feature do número de municípios agrupando por Credor e Ano
    empenhos_por_fornecedor_ano <- empenhos_group %>% 
        mutate(cd_UGestora_copy = cd_UGestora) %>% 
        separate(cd_UGestora_copy, c('cd_UGestora_prefix', 'cd_Municipio'), -3) %>%
        
        group_by(cd_Credor, data, dt_Ano) %>% 
        summarise(n_municipios = n_distinct(cd_Municipio),
                  n_ugestora = n_distinct(cd_UGestora),
                  total_ganho = sum(total_ganho)) %>% 
        ungroup() %>% 
        select(cd_Credor, data, dt_Ano, n_municipios, n_ugestora, total_ganho)
    
    empenhos_features <- empenhos_por_fornecedor_ano %>% 
        group_by(cd_Credor, data) %>% 
        summarise(media_municipio = mean(n_municipios), # ordem das operações importa. Média calculada apenas para o anos com observações (fornecimento da empresa).
                  n_municipios = sum(n_municipios),
                  media_ugestora = mean(n_ugestora),
                  n_ugestora = sum(n_ugestora),
                  media_ganho = mean(total_ganho),
                  total_ganho = sum(total_ganho)) %>% 
        ungroup()
    
    empenhos_features_nome <- empenhos_features %>% 
        left_join(cnpjs_nome, by = "cd_Credor") %>% 
        select(cd_Credor, no_Credor, dplyr::everything())
    
    return(empenhos_features_nome)
}