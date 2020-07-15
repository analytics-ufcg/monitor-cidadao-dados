# Features: 
# - Número de licitações disputadas pela empresa até a data de assinatura do contrato + Média por ano
# - Número de licitações que a empresa ganhou até a data de assinatura do contrato + Média por ano
# - Montante total das licitações que a empresa ganhou até a data de assinatura do contrato + Média por ano
# - Taxa de acerto nas licitações do ano - Percentual de vitórias até a data de assinatura do contrato

#' @description Carrega a informações de licitações associadas a CNPJ's participantes da licitação
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de licitação
#' @return Data frame com informações da licitação. Para cada empresa (CNPJ) informações sobre a quantidade de licitações e o montante de dinheiro envolvido.
carrega_info_licitacao <- function(ano_inicial = 2011, ano_final = 2016, cnpjs_datas_contratos) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/carrega_licitacoes.R"))
    
    ano_inicial_sagres <- 2003
    ## Carrega licitações, propostas e vencedores das licitações
    licitacoes <- carrega_licitacoes(ano_inicial_sagres, ano_final)
    
    lista_cnpjs <- cnpjs_datas_contratos %>% distinct(nu_CPFCNPJ) %>% pull(nu_CPFCNPJ)
    
    participacoes <- carrega_participantes(lista_cnpjs)
    
    licitacoes_vencedores <- carrega_licitacoes_vencedores(ano_inicial_sagres, ano_final)
    
    ## Cruza as propostas para licitações (a partir da lista de cnpjs) com todas as licitações do sagres usando a chave de licitação
    licitacoes_fornecedor <- participacoes %>% 
        select(-dt_Ano) %>% 
        inner_join(licitacoes, by = c("cd_UGestora", "nu_Licitacao", "tp_Licitacao")) %>% 
        mutate(dt_Homologacao = as.Date(dt_Homologacao, "%Y-%m-%d"))
    
    ## Filtra licitações deixando apenas aquelas com data de homologação anterior a data de início do contrato
    licitacoes_fornecedor_data <- cnpjs_datas_contratos %>% 
        left_join(licitacoes_fornecedor, by = c("nu_CPFCNPJ")) %>% 
        rowwise() %>% 
        filter(dt_Homologacao < data_inicio) %>% 
        ungroup()
    
    ## Calcula informações de vitória em licitações para os cnpjs das empresas
    licitacoes_fornecedor_vencedores <- cnpjs_datas_contratos %>% 
        left_join(licitacoes_vencedores, by = c("nu_CPFCNPJ" = "cd_Credor")) %>% 
        filter(min_dt_Empenho < data_inicio) %>% 
        left_join(licitacoes %>% select(cd_UGestora, nu_Licitacao, tp_Licitacao, vl_Licitacao), 
                  by = c("cd_UGestora", "nu_Licitacao", "tp_Licitacao")) %>% 
        filter(nu_Licitacao != "000000000") %>% 
        
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n_licitacoes_venceu = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao),
                  montante_lic_venceu = sum(vl_Licitacao)) %>% 
        ungroup()
        
    ## Cruza as features dos vencedores com todas as licitações (que serão usadas nas features)
    licitacoes_completa <- licitacoes_fornecedor_data %>% 
        left_join(licitacoes_fornecedor_vencedores, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        mutate(n_licitacoes_venceu = replace_na(n_licitacoes_venceu, 0),
               montante_lic_venceu = replace_na(montante_lic_venceu, 0))
    
    ## Calcula o número de licitações ganhas pela empresa até uma data limite
    n_licitacoes_empresa_ganhou <- licitacoes_fornecedor_vencedores %>% 
        select(nu_CPFCNPJ, data_inicio, n_licitacoes_venceu)
        
    ## Calcula o número de licitações que a empresa participou até uma data limite
    n_licitacoes_empresa_participou <- licitacoes_fornecedor_data %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n_licitacoes_part = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao))
        
    ## Calcula o número de licitações que a empresa participou e venceu parte1
    licitacoes_empresa_ganhou <- cnpjs_datas_contratos %>% 
        left_join(licitacoes_vencedores, by = c("nu_CPFCNPJ" = "cd_Credor")) %>% 
        filter(min_dt_Empenho < data_inicio) %>% 
        filter(nu_Licitacao != "000000000") 
    
    ## Calcula o número de licitações que a empresa participou e venceu parte2
    n_licitacoes_empresa_ganhou_participou <- licitacoes_fornecedor_data %>% 
        select(nu_CPFCNPJ, data_inicio, cd_UGestora, nu_Licitacao, tp_Licitacao, vl_Licitacao) %>% 
        inner_join(licitacoes_empresa_ganhou, by = c("nu_CPFCNPJ", "data_inicio", "cd_UGestora", "nu_Licitacao", "tp_Licitacao")) %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n_licitacoes_part_venceu = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao))
    
    perc_licitacoes_associadas <- cnpjs_datas_contratos %>% 
        left_join(n_licitacoes_empresa_participou, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        left_join(n_licitacoes_empresa_ganhou, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        left_join(n_licitacoes_empresa_ganhou_participou, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        mutate_at(.funs = funs(replace_na(., 0)), .vars = vars(starts_with("n_licitacoes"))) %>% 
        mutate(perc_vitoria = n_licitacoes_venceu / (n_licitacoes_venceu + (n_licitacoes_part - n_licitacoes_part_venceu))) %>% 
        mutate_at(.funs = funs(replace_na(., 0)), .vars = vars(starts_with("perc_vitoria")))
    
    licitacoes_features <- licitacoes_completa %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n_licitacoes_part = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao),
                  n_licitacoes_venceu = first(n_licitacoes_venceu),
                  montante_lic_venceu = first(montante_lic_venceu)) %>% 
        ungroup() %>% 
        select(nu_CPFCNPJ, data_inicio, n_licitacoes_part, n_licitacoes_venceu, montante_lic_venceu)
    
    ## Cálculo das médias de licitações que a empresa participou por ano e da média de licitações que a empresa tem empenhos associados
    media_licitacoes_part_empresa <- licitacoes_fornecedor_data %>% 
        group_by(nu_CPFCNPJ, data_inicio, dt_Ano) %>% 
        summarise(n_licitacoes = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao)) %>% 
        ungroup() %>% 
        
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(media_n_licitacoes_part = mean(n_licitacoes)) %>% 
        ungroup()
    
    media_licitacoes_venceu_empresa <- licitacoes_empresa_ganhou %>% 
        mutate(dt_Ano = as.numeric(substr(min_dt_Empenho, 1, 4))) %>% 
        group_by(nu_CPFCNPJ, data_inicio, dt_Ano) %>% 
        summarise(n_licitacoes = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao)) %>% 
        ungroup() %>% 
        
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(media_n_licitacoes_venceu = mean(n_licitacoes)) %>% 
        ungroup()

    # Merge das features
    licitacoes_features_merge <- licitacoes_features %>% 
        left_join(perc_licitacoes_associadas %>% select(nu_CPFCNPJ, data_inicio, perc_vitoria), by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        left_join(media_licitacoes_part_empresa, by = c("nu_CPFCNPJ", "data_inicio")) %>% 
        left_join(media_licitacoes_venceu_empresa, by = c("nu_CPFCNPJ", "data_inicio"))
    
    return(licitacoes_features_merge)
}