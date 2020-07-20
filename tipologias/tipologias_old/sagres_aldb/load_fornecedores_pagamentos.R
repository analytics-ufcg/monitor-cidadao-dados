#' @description Carrega a lista de licitações por fornecedor com informações de pagamentos em um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @return Data frame com informações da licitação, incluindo nome do credor vitorioso, total pago, total estornado e número de empenhos
carrega_licitacoes_por_fornecedor <- function(ano_inicial = 2014, ano_final = 2014) {
    library(tidyverse)
    library(here)
    source(here("lib/sagres/carrega_empenhos.R"))
    
    empenhos <- carrega_empenhos(ano_inicial, ano_final)
    
    licitacoes_por_fornecedor <- empenhos %>% 
        group_by(cd_UGestora, nu_Licitacao, tp_Licitacao, dt_Ano, cd_Credor) %>% 
        summarise(no_Credor = first(no_Credor),
                  num_empenhos = n(),
                  valor_pago = sum(total_pago),
                  valor_estornado = sum(total_estornado)) %>% 
        mutate(valor_estornado = replace_na(valor_estornado, 0),
               total_ganho = valor_pago - valor_estornado) %>% 
        ungroup()
    
    return(licitacoes_por_fornecedor)
}

#' @description Carrega contratos realizados em um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param limite Limite inferior para o valor do contrato
#' @return Data frame com informações do contrato, como o contratado e o valor do contrato.
carrega_contratos <- function(ano_inicial = 2014, ano_final = 2014, limite_inferior=140e3) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "rsagrespb", username = "shiny")
    
    template <- ('
        SELECT * 
        FROM Contratos
        WHERE dt_Ano BETWEEN %d AND %d AND vl_TotalContrato >= %d
    ')
    
    query <- template %>%
        sprintf(ano_inicial, ano_final, limite_inferior) %>%
        sql()
    
    contratos <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(contratos)
}

#' @description Carrega contratos realizados em um intervalo de tempo agrupados por licitação e por fornecedor
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @return Data frame com informações do agrupamento, como o contratado e o soma do valor dos contratos.
contratos_por_licitacao_e_fornecedor <- function(ano_inicial = 2014, ano_final = 2014) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
  
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    
    template <- ('
               SELECT cd_UGestora, nu_Licitacao, tp_Licitacao, nu_CPFCNPJ, SUM(vl_TotalContrato) as soma_vl_contratos
               FROM Contratos
               WHERE dt_Ano BETWEEN %d AND %d
               GROUP BY cd_UGestora, nu_Licitacao, tp_Licitacao, nu_CPFCNPJ
               ')
  
    query <- template %>%
        sprintf(ano_inicial, ano_final) %>%
        sql()
  
    contratos_group <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(contratos_group)
}