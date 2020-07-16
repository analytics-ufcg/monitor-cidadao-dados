#' @description Carrega a informações de licitações associadas a CNPJ's participantes da licitação
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @return Data frame com informações da licitação. Para cada empresa (CNPJ) informações sobre a quantidade de licitações e o montante de dinheiro envolvido por ano 
carrega_licitacoes <- function(ano_inicial = 2011, ano_final = 2016){
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    
    template <- ('
                SELECT cd_UGestora, nu_Licitacao, tp_Licitacao, dt_Ano, dt_Homologacao, vl_Licitacao
                FROM Licitacao
                WHERE dt_Ano BETWEEN %d and %d
                 ')
    
    query <- template %>% 
        sprintf(ano_inicial, ano_final) %>% 
        sql()
    
    licitacoes <- tbl(sagres, query) %>% 
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(licitacoes)

}

#' @description Carrega informações de participação em licitações a partir de uma lista de CNPJ's
#' @param lista_cnpjs Lista de CNPJ's que se quer pesquisar
#' @return Data frame com informações de participações em licitação para cada CNPJ da lista de CNPJ's.
carrega_participantes <- function(lista_cnpjs) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    
    template <- ('
                SELECT * 
                FROM Participantes
                WHERE nu_CPFCNPJ IN (%s)
                 ')
    
    query <- template %>% 
        sprintf(paste(lista_cnpjs, collapse = ", ")) %>% 
        sql()
    
    participacoes <- tbl(sagres, query) %>% 
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(participacoes)
}

#' @description Carrega lista de licitações realizadas em um determinado período de tempo
#' @param ano_inicial Ano inicial do período de tempo
#' @param ano_final Ano final do período de tempo
#' @return Data frame com informações da licitação e de seus vencedores
carrega_licitacoes_vencedores <- function(ano_inicial = 2011, ano_final = 2016) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    
    template <- ('
                SELECT cd_UGestora, nu_Licitacao, tp_Licitacao, dt_Ano, dt_Homologacao, vl_Licitacao
                FROM Licitacao
                WHERE dt_Ano BETWEEN %d and %d
                 ')
    
    query <- template %>% 
        sprintf(ano_inicial, ano_final) %>% 
        sql()
    
    licitacoes <- tbl(sagres, query) %>% 
        compute(name = "lic") %>% 
        collect(n = Inf)
    
    query <- sql('
                SELECT e.cd_UGestora, e.dt_Ano, e.cd_UnidOrcamentaria, e.nu_Empenho, e.tp_Licitacao, e.nu_Licitacao, e.cd_Credor, e.dt_Empenho
                FROM Empenhos e
                USE INDEX (FK_Empenhos_Licitacao)
                INNER JOIN lic
                USING (cd_UGestora, nu_Licitacao, tp_Licitacao)
    ')
    
    empenhos <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    
    licitacoes_vencedores <- empenhos %>% 
        group_by(cd_UGestora, nu_Licitacao, tp_Licitacao, cd_Credor) %>% 
        summarise(min_dt_Empenho = min(dt_Empenho)) %>% 
        ungroup() %>% 
        mutate(venceu = 1)
    
        # distinct(cd_UGestora, nu_Licitacao, tp_Licitacao, cd_Credor) %>% 
        # mutate(venceu = 1)
 
    return(licitacoes_vencedores)   
}

#' @description Carrega a informações das propostas associadas a licitações que ocorreram dentro de um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @return Data frame com informações das propostas para licitações em um intervalo de tempo
carrega_propostas_licitacao <- function(ano_inicial = 2011, ano_final = 2019) {
    library(tidyverse)
    
    # sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    # 
    # template <- ('
    #             SELECT cd_UGestora, nu_Licitacao, tp_Licitacao, dt_Ano, dt_Homologacao, vl_Licitacao
    #             FROM Licitacao
    #             WHERE dt_Ano BETWEEN %d and %d
    #              ')
    # 
    # query <- template %>% 
    #     sprintf(ano_inicial, ano_final) %>% 
    #     sql()
    # 
    # licitacoes <- tbl(sagres, query) %>% 
    #     compute(name = "lic") %>% 
    #     collect(n = Inf)
    
    
    # query <- sql('
    #             SELECT p.cd_UGestora, p.nu_Licitacao, p.tp_Licitacao, lic.dt_Homologacao, lic.dt_Ano, p.cd_Item, p.cd_SubGrupoItem, p.nu_CPFCNPJ, p.vl_Ofertado
    #             FROM Propostas p
    #             INNER JOIN lic
    #             USING (cd_UGestora, nu_Licitacao, tp_Licitacao)
    #             ')
    # 
    # propostas <- tbl(sagres, query) %>% 
    #     collect(n = Inf)
    # 
    # DBI::dbDisconnect(sagres)
    
    
    licitacoes <- read_csv(here::here("data/licitacoes.csv"))
    propostas <- read_csv(here::here("data/propostas.csv"))
    
    
    
    return(propostas)
}

