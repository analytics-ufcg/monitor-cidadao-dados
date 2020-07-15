# Features: 
# - Número de propostas dadas pela empresa considerando todas as licitações daquele ano (ano inicial até o ano final) + Média

#' @description Carrega a informações do número de propostas de CNPJS associadas a licitações dentro de um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações das propostas.
#' @return Data frame com informações de quantas propostas foram feitas por uma determinada empresa até uma data limite.
carrega_info_proposta <- function(ano_inicial = 2011, ano_final = 2016, cnpjs_datas_contratos) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/carrega_licitacoes.R"))
    
    ano_inicial_sagres <- 2003
    propostas <- carrega_propostas_licitacao(ano_inicial_sagres, ano_final)
    
    propostas_filtradas_fornecedores <- cnpjs_datas_contratos %>% 
        left_join(propostas, by = "nu_CPFCNPJ") %>% 
        mutate(dt_Homologacao = as.Date(dt_Homologacao, "%Y-%m-%d")) %>% 
        filter(dt_Homologacao < data_inicio)
    
    propostas_group <- propostas_filtradas_fornecedores %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n_propostas = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao, cd_Item, cd_SubGrupoItem, nu_CPFCNPJ)) %>% 
        ungroup()
    
    media_propostas_group <- propostas_filtradas_fornecedores %>% 
        group_by(nu_CPFCNPJ, data_inicio, dt_Ano) %>% 
        summarise(n_propostas = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao, cd_Item, cd_SubGrupoItem, nu_CPFCNPJ)) %>% 
        ungroup() %>% 
        
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(media_n_propostas = mean(n_propostas)) %>% 
        ungroup()
        
    propostas_features <- cnpjs_datas_contratos %>%
        left_join(propostas_group, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        left_join(media_propostas_group, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        mutate_at(.funs = funs(replace_na(., 0)), .vars = vars(starts_with("n_propostas"), starts_with("media_n_propostas")))
    
    return(propostas_features)
}
