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

#' @description Carrega os contratos mutados provindos do tramita
#' @return Data frame com as informações das mutações do contrato (contém infos. sobre a rescisão contratual). 
carrega_contratos_mutados <- function(al_db_con) {
  contratos_mutados <- tibble::tibble()
  
  template <- ('SELECT * FROM contrato_mutado')
  
  query <- template %>% 
    dplyr::sql()
  
  tryCatch({
    contratos_mutados <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar os contratos_mutados no Banco AL_BD (Postgres): ", e))
  )
  
  return(contratos_mutados)
}

#' @title Busca contratos no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos(al_db_con)
carrega_contratos <- function(al_db_con, vigentes = TRUE, data_range_inicio = "2014-01-01", data_range_fim = "2020-01-01", limite_inferior=140e3) {
  print (data_range_inicio)
  print (data_range_fim)
  contratos <- tibble::tibble()
  template <- (paste0('SELECT *
                FROM contrato
                WHERE dt_Assinatura BETWEEN \'%s\' and \'%s\' AND
                pr_vigencia', dplyr::if_else(vigentes, '>=', '<'), ' \'%s\'', 'AND vl_total_contrato >= %d'))
  
  query <- template %>% 
    sprintf(data_range_inicio, data_range_fim, as.character(Sys.Date()), limite_inferior) %>% 
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

carrega_empenhos_by_contrato <- function(al_db_con, ids_contratos) {
  empenhos <- tibble::tibble()
  
  template <- paste0('
                SELECT * 
                FROM empenho')
  
  query <- template %>% 
    dplyr::sql()
  
  tryCatch({
    empenhos <- ids_contratos %>% purrr::map_df(~DBI::dbGetQuery(al_db_con, paste0("SELECT * FROM empenho WHERE id_contrato=\'", .x, "\'")))
      
    # empenhos <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar empenhos no Banco AL_BD (Postgres): ", e))
  )
  
  return(empenhos)
}

carrega_empenhos <- function(al_db_con) {
  empenhos <- tibble::tibble()
  
  tryCatch({
    empenhos <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar empenhos no Banco AL_BD (Postgres): ", e))
  )
  
  return(empenhos)
}

carrega_pagamentos_by_empenho <- function(al_db_con, ids_empenhos) {
  pagamentos <- tibble::tibble()
  
  tryCatch({
    pagamentos <- ids_empenhos %>% purrr::map_df(~DBI::dbGetQuery(al_db_con, paste0("SELECT * FROM pagamento WHERE id_empenho=\'", .x, "\'")))
    
  },
    error = function(e) print(paste0("Erro ao buscar pagamentos no Banco AL_BD (Postgres): ", e))
  )
  
  return(pagamentos)
}

arrega_pagamentos <- function(al_db_con) {
  pagamentos <- tibble::tibble()
  
  template <- paste0('
                SELECT * 
                FROM pagamento')
  
  query <- template %>% 
    dplyr::sql()
  
  tryCatch({
    pagamentos <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar pagamentos no Banco AL_BD (Postgres): ", e))
  )
  
  return(pagamentos)
}

carrega_estorno_pagamentos <- function(al_db_con) {
  estorno_pagamentos <- tibble::tibble()
  
  template <- paste0('
                SELECT * 
                FROM estorno_pagamento')
  
  query <- template %>% 
    dplyr::sql()
  
  tryCatch({
    estorno_pagamentos <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar estorno de pagamentos no Banco AL_BD (Postgres): ", e))
  )
  
  return(estorno_pagamentos)
}

#' @title Gera hashcode com estado atual das tabelas
#' @param al_db_con Conexão com o Banco de Dados
#' @return Hashcode referente ao estado atual das tabelas utilizadas para criação das tipologias
#' @rdname generate_hash_al_db
#' @examples
#' hash <- generate_hash_al_db(al_db_con)
generate_hash_al_db <- function(al_db_con) {
  hash <- ""
  
  template_licitacao <- ('SELECT        
                     md5(CAST((array_agg(f.* order by id_licitacao))AS text))
                     FROM
                     licitacao f')
  
  template_proposta <- ('SELECT        
                     md5(CAST((array_agg(f.* order by id_proposta))AS text))
                     FROM
                     proposta f')
  
  template_contrato <- ('SELECT        
                     md5(CAST((array_agg(f.* order by id_contrato))AS text))
                     FROM
                     contrato f')
  
  template_participante <- ('SELECT        
                     md5(CAST((array_agg(f.* order by id_participante))AS text))
                     FROM
                     participante f')
  
  query_licitacao <- template_licitacao %>% 
    dplyr::sql()
    
  query_proposta <- template_proposta %>% 
    dplyr::sql()
    
  query_contrato <- template_contrato %>% 
    dplyr::sql()   
    
  query_participante <- template_participante %>% 
    dplyr::sql()
  
  tryCatch({
    hash_licitacao <- dplyr::tbl(al_db_con, query_licitacao) %>% dplyr::collect(n = Inf)
    hash_proposta <- dplyr::tbl(al_db_con, query_proposta) %>% dplyr::collect(n = Inf)
    hash_contrato <- dplyr::tbl(al_db_con, query_contrato) %>% dplyr::collect(n = Inf)
    hash_participante <- dplyr::tbl(al_db_con, query_participante) %>% dplyr::collect(n = Inf)
    
    hash <- digest::digest(paste(hash_licitacao, hash_proposta, hash_contrato, hash_participante), algo="md5", serialize=F)
    
  },
  error = function(e) print(paste0("Erro ao gerar hash das tabelas no Banco AL_BD (Postgres): ", e))
  )
  
  return(hash)
}



