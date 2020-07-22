# Features:
# - Número de Municípios para os quais a empresa forneceu serviço
# - Montante total de dinheiro recebido público recebido pela empresa
# - Tipo de licitação mais comum para a empresa (considerando empenhos associados a empresa)

#' @description Calcula informações sobre o fornecimento de uma lista de CNPj's tendo como limite uma data (que geralmente é a data de início do contrato). 
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações sobre as empresas com uma data de limite superior como número de municípios com fornecimento por ano, total de dinheiro recebido por ano.
carrega_info_fornecimento_contratos <- function(ano_inicial, ano_final, cnpjs_datas_contratos) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/carrega_empenhos.R"))
    
    datas_lista <- cnpjs_datas_contratos %>% 
        distinct(data_inicio) %>% 
        mutate(data_inicio = as.character(data_inicio)) %>% 
        pull(data_inicio)
    
    ## Carrega empenhos relacionados a lista de CNPJs e uma data Limite
    ano_inicial_sagres <- 2003
    empenhos_data <- carrega_empenhos_data_limite(ano_inicial_sagres, ano_final, cnpjs_datas_contratos)
    
    Mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
    }
    
    licitacoes <- empenhos_data %>% 
        group_by(cd_Credor, data, cd_UGestora, nu_Licitacao, tp_Licitacao) %>% 
        summarise(n = n()) %>% 
        ungroup() %>%
        
        group_by(cd_Credor, data) %>% 
        summarise(top_tp_Licitacao = Mode(tp_Licitacao)) %>% 
        ungroup()
    
    empenhos_group <- empenhos_data %>%
        group_by(cd_Credor, data, cd_UGestora) %>% 
        summarise(no_Credor = first(no_Credor),
                  total_ganho = sum(total_pago - replace_na(total_estornado, 0))) %>% 
        ungroup()
    
    empenhos_features <- empenhos_group %>% 
        mutate(cd_UGestora_copy = cd_UGestora) %>% 
        separate(cd_UGestora_copy, c('cd_UGestora', 'cd_Municipio'), -3) %>%
        group_by(cd_Credor, data) %>% 
        summarise(no_Credor = first(no_Credor),
                  n_municipios = n_distinct(cd_Municipio),
                  total_ganho = sum(total_ganho)) %>% 
        ungroup() %>% 
        left_join(licitacoes, by = c("cd_Credor", "data"))
    
    return(empenhos_features)
}