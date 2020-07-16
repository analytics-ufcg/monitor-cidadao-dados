# Experimento envolvendo dados gerais.
#' @description Calcula as tipologias gerais para os contratos realizados entre o intevalo de tempo passado como parâmetro.
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @return Data frame com informações sobre as empresas (total recebido, número de municípios fornecidos, dentre outras)
tipologias_contratos_gerais <- function(ano_inicial = 2014, ano_final = 2019) {
    library(tidyverse)
    library(here)
    source(here::here("lib/gabaritos/carrega_gabarito_contratos.R"))
    source(here::here("lib/sagres/carrega_empenhos.R"))
    source(here::here("lib/sagres/load_fornecedores_pagamentos.R"))
    source(here::here("lib/sagres/carrega_info_fornecimento.R"))
    source(here::here("lib/sagres/carrega_info_licitacao.R"))
    source(here::here("lib/sagres/carrega_info_proposta.R"))
    source(here::here("lib/receita_federal/gera_tipologias_cadastrais.R"))
    source(here::here("lib/sagres/carrega_info_contrato.R"))
    
    contratos_all <- carrega_contratos(ano_inicial, ano_final, limite_inferior = 140e3) %>% 
        mutate(data_inicio = as.Date(dt_Assinatura, "%Y-%m-%d")) %>% 
        select(cd_UGestora, nu_Contrato, dt_Ano, data_inicio, nu_CPFCNPJ, tp_Licitacao, vl_TotalContrato)
    
    cnpjs_datas_contratos <- contratos_all %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n = n()) %>% 
        ungroup() %>% 
        select(nu_CPFCNPJ, data_inicio) %>% 
        filter(nu_CPFCNPJ != "")
    
    
    tipologias_fornecimento <- carrega_info_fornecimento(ano_inicial, ano_final, cnpjs_datas_contratos) #Depende de empenhos
    
    tipologias_licitacao <- carrega_info_licitacao(ano_inicial, ano_final, cnpjs_datas_contratos) #Focar refatoramento aqui
    
    tipologias_proposta <- carrega_info_proposta(ano_inicial, ano_final, cnpjs_datas_contratos)
    #REFATORAMENTO CHEGOU AQUI
    
    tipologias_cadastrais_empresas <- gera_tipologias_empresa(cnpjs_datas_contratos,
                                                              rfb_info_empresas_contratos_path = here::here("data/rfb_info_empresas_geral.csv"),
                                                              rfb_socios_empresas_contratos_path = here::here("data/rfb_socios_empresas_geral.csv"))
    
    tipologias_merge <- contratos_all %>% 
        left_join(tipologias_fornecimento, by = c("nu_CPFCNPJ" = "cd_Credor", "data_inicio" = "data")) %>% 
        left_join(tipologias_licitacao, by = c("nu_CPFCNPJ" = "nu_CPFCNPJ", "data_inicio" = "data_inicio")) %>% 
        left_join(tipologias_proposta, by = c("nu_CPFCNPJ" = "nu_CPFCNPJ", "data_inicio" = "data_inicio")) %>% 
        left_join(tipologias_cadastrais_empresas, by = "nu_CPFCNPJ") %>% 
        
        select(-no_Credor) %>% 
        carrega_gabarito_tramita() %>% 
        rename(status = status_tramita) %>% 
        
        mutate_at(.funs = funs(replace_na(., 0)), .vars = vars(starts_with("n_municipios"), starts_with("n_ugestora"),
                                                               starts_with("total_ganho"), starts_with("media"),
                                                               starts_with("montante_lic_venceu"), starts_with("n_licitacoes_part"),
                                                               starts_with("n_licitacoes_venceu"), starts_with("n_propostas"),
                                                               starts_with("n_contratos"), starts_with("perc_vitoria")))## substitui NA das colunas numéricas por 0
    
    tipologias_contrato <- tipologias_merge %>% 
        carrega_info_contrato(ano_inicial = ano_inicial, ano_final = ano_final, limite_inferior = 140e3)
    
    tipologias_final_contratos_gerais <- tipologias_merge %>% 
        left_join(tipologias_contrato, by = c("cd_UGestora", "nu_Contrato", "nu_CPFCNPJ", "data_inicio"))
    
    return(tipologias_final_contratos_gerais)
}

# Experimento envolvendo dados de obras
#' @description Calcula as tipologias considerando os contratos com Obras associadas
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @return Data frame com informações sobre os contratos com Obras associadas no Banco de Obras. Também retorna uma coluna com o label (status do contrato) associado a um contrato.
tipologias_contratos_obras <- function(ano_inicial = 2014, ano_final = 2017, manter_obras_em_andamento = FALSE) {
    library(tidyverse)
    library(here)
    library(rsagrespb)
    source(here::here("lib/sagres/carrega_info_status_contrato.R"))
    source(here::here("lib/obras/merge_obras_contratos.R"))
    source(here::here("lib/gabaritos/carrega_gabarito_obras.R"))
    source(here::here("lib/receita_federal/gera_tipologias_cadastrais.R"))
    
    ## Carrega dados de obras com informações sobre seus contratos
    contratos_obras <- merge_obras_contratos(ano_inicial, ano_final, "prod")

    contratos_all <- carrega_contratos(ano_inicial, ano_final, limite_inferior = 0)
    
    contratos_merge <- contratos_obras %>% 
        left_join(contratos_all %>% select(cd_UGestora, nu_Contrato, tp_Licitacao, dt_Assinatura), by = c("cd_UGestora", "nu_Contrato")) %>% 
        carrega_gabarito_obras(col_andamento = "andamento") %>% # Adiciona status das obras (cancelado ou não)
        filter(andamento != 1 | (andamento == 1 & status != 0) | manter_obras_em_andamento) %>% ## andamento 1 significa status da obra em execução. 
                                                                    ## O contrato pode ser considerado da classe positiva se pelo tramita há registro de rescisão
        group_by(cd_UGestora, nu_Contrato) %>% 
        summarise(nu_CPFCNPJ = first(nu_CPFCNPJ),
                vl_TotalContrato = first(vl_TotalContrato),
                tp_Licitacao = first(tp_Licitacao),
                data_inicio = first(dt_Assinatura),
                status_contrato = max(status)) %>% 
        ungroup() %>% 
        mutate(data_inicio = as.Date(data_inicio, "%Y-%m-%d"))
        
    cnpjs_datas_contratos <- contratos_merge %>% 
        group_by(nu_CPFCNPJ, data_inicio) %>% 
        summarise(n = n()) %>% 
        ungroup() %>% 
        select(nu_CPFCNPJ, data_inicio)
    
    tipologias_fornecimento <- carrega_info_fornecimento(ano_inicial, ano_final, cnpjs_datas_contratos)
    
    tipologias_licitacao <- carrega_info_licitacao(ano_inicial, ano_final, cnpjs_datas_contratos)
    
    tipologias_proposta <- carrega_info_proposta(ano_inicial, ano_final, cnpjs_datas_contratos)
    
    tipologias_status_contrato <- carrega_info_status_contrato(ano_inicial, ano_final, manter_obras_em_andamento, cnpjs_datas_contratos)
    
    tipologias_cadastrais_empresas <- gera_tipologias_empresa(cnpjs_datas_contratos = cnpjs_datas_contratos,
                                                              rfb_info_empresas_contratos_path = here::here("data/rfb_info_empresas_obras_pb.csv"),
                                                              rfb_socios_empresas_contratos_path = here::here("data/rfb_socios_empresas_obras_pb.csv"))
    
    ## Cruza tipologias de fornecimento, licitação e proposta
    tipologias_merge <- contratos_merge %>% 
        mutate(data_inicio = as.character(data_inicio)) %>% 
        left_join(tipologias_fornecimento %>% mutate(data_inicio = as.character(data_inicio)), by = c("nu_CPFCNPJ" = "cd_Credor", "data_inicio")) %>% 
        left_join(tipologias_licitacao %>% mutate(data_inicio = as.character(data_inicio)), by = c("nu_CPFCNPJ", "data_inicio")) %>%
        left_join(tipologias_proposta %>% mutate(data_inicio = as.character(data_inicio)), by = c("nu_CPFCNPJ", "data_inicio")) %>%  
        left_join(tipologias_status_contrato %>% mutate(data_inicio = as.character(data_inicio)), by = c("nu_CPFCNPJ", "data_inicio")) %>%
        left_join(tipologias_cadastrais_empresas, by = "nu_CPFCNPJ") %>% 
      
        mutate_at(
            .funs = funs(replace_na(., 0)), 
            .vars = vars(starts_with("vl"), starts_with("md"), 
                         starts_with("qt"), starts_with("pr"),
                         starts_with("n_contratos"))) %>% ## substitui NA das colunas numéricas por 0
        mutate(status = status_contrato) %>% ## Desloca o status do contrato como a última coluna do data frame
        select(-c(no_Credor, status_contrato))
    
    tipologias_contrato <- tipologias_merge %>% 
        carrega_info_contrato(ano_inicial = ano_inicial, ano_final = ano_final, limite_inferior = 0)
    
    tipologias_final_contratos_obras <- tipologias_merge %>% 
        left_join(tipologias_contrato, by = c("cd_UGestora", "nu_Contrato", "nu_CPFCNPJ", "data_inicio"))
    
    return(tipologias_final_contratos_obras)
}
