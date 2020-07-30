#' @description Carrega a informações de licitações associadas a CNPJ's participantes da licitação
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2019
#' @return Data frame com informações da licitação. Para cada empresa (CNPJ) informações sobre a quantidade de licitações e o montante de dinheiro envolvido por ano 
carrega_licitacoes <- function(al_db_con, ano_inicial = 2010, ano_final = 2019) {
  licitacoes <- tibble::tibble()
  
  template <- ('SELECT id_licitacao, cd_u_gestora, nu_licitacao, tp_licitacao, dt_ano, dt_homologacao, vl_licitacao
                FROM licitacao
                WHERE dt_ano BETWEEN %d and %d')
  
  query <- template %>% 
    sprintf(ano_inicial, ano_final) %>% 
    dplyr::sql()

  tryCatch({
    # licitacoes <- DBI::dbGetQuery(al_db_con, "SELECT * FROM licitacao;") 
    licitacoes <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar licitações no Banco AL_BD (Postgres): ", e))
  )
  
  return(licitacoes)
}

#' @description Carrega a informações das propostas associadas a licitações que ocorreram dentro de um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @return Data frame com informações das propostas para licitações em um intervalo de tempo
carrega_propostas_licitacao <- function(al_db_con, ano_inicial = 2011, ano_final = 2019) {
  propostas_licitacao <- tibble::tibble()
  
  template <- ('SELECT *
                FROM proposta
                WHERE dt_Ano BETWEEN %d and %d')
  
  query <- template %>%
    sprintf(ano_inicial, ano_final) %>%
    dplyr::sql()
  
  tryCatch({
    propostas_licitacao <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar propostas de licitações no Banco AL_BD (Postgres): ", e))
  )
  
  return(propostas_licitacao)
  

}

#' @title Busca contratos no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos(al_db_con)
carrega_contratos <- function(al_db_con, vigentes = TRUE, ano_inicial = 2014, ano_final = 2020, limite_inferior=140e3) {
  contratos <- tibble::tibble()
  template <- (paste0('SELECT *
                FROM contrato
                WHERE dt_ano BETWEEN %d and %d AND
                pr_vigencia ', dplyr::if_else(vigentes, '>=', '<'), ' \'%s\''))
  
  query <- template %>% 
    sprintf(ano_inicial, ano_final, as.character(Sys.Date()), limite_inferior) %>% 
    dplyr::sql()
  
  tryCatch({
    contratos <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar contrato no Banco AL_BD (Postgres): ", e))
  )

  return(contratos)
}

carrega_participantes <- function(al_db_con, list_cnpjs) {
  participacoes <- tibble::tibble()
  
  template <- ('
                SELECT * 
                FROM participante
                WHERE nu_cpfcnpj = ANY (\'{%s}\')')
  
  query <- template %>% 
    sprintf(paste(list_cnpjs, collapse = ", ")) %>% 
    dplyr::sql()

  tryCatch({
    participacoes <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar participantes no Banco AL_BD (Postgres): ", e))
  )
  
  return(participacoes)
}




