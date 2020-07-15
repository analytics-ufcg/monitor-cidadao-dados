#' #' @title Busca licitações no Banco AL_DB do Postgres
#' #' @param al_db_con Conexão com o Banco de Dados
#' #' @return Dataframe contendo informações sobre as licitações
#' #' @rdname fetch_licitacoes
#' #' @examples
#' #' licitacoes <- fetch_licitacoes(al_db_con)
#' fetch_licitacoes <- function(al_db_con) {
#'   licitacoes <- tibble::tibble()
#'   tryCatch({
#'     licitacoes <- DBI::dbGetQuery(al_db_con, "SELECT * FROM licitacao;") 
#'   },
#'   error = function(e) print(paste0("Erro ao buscar licitações no Banco AL_BD (Postgres): ", e))
#'   )
#' 
#'   return(licitacoes)
#' }


#' @description Carrega a informações de licitações associadas a CNPJ's participantes da licitação
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2019
#' @return Data frame com informações da licitação. Para cada empresa (CNPJ) informações sobre a quantidade de licitações e o montante de dinheiro envolvido por ano 
carrega_licitacoes <- function(al_db_con, ano_inicial = 2010, ano_final = 2019) {
  licitacoes <- tibble::tibble()
  
  template <- ('SELECT cd_u_gestora, nu_licitacao, tp_licitacao, dt_ano, dt_homologacao, vl_licitacao
                FROM licitacao
                WHERE dt_ano BETWEEN %d and %d')
  
  query <- template %>% 
    sprintf(ano_inicial, ano_final) %>% 
    dplyr::sql()
  print("oi")
  tryCatch({
    # licitacoes <- DBI::dbGetQuery(al_db_con, "SELECT * FROM licitacao;") 
    licitacoes <- dplyr::tbl(al_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar licitações no Banco AL_BD (Postgres): ", e))
  )
  
  return(licitacoes)
}







#' @title Busca codigos de funções no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname fetch_codigo_funcao
#' @examples
#' codigo_funcao <- fetch_codigo_funcao(al_db_con)
fetch_codigo_funcao <- function(al_db_con) {
  codigo_funcao <- tibble::tibble()
  tryCatch({
    codigo_funcao <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_Funcao;")
  },
  error = function(e) print(paste0("Erro ao buscar codigos de funcões no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_funcao)
}

#' @title Busca codigos de elementos de despesas no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname fetch_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa <- fetch_codigo_elemento_despesa(al_db_con)
fetch_codigo_elemento_despesa <- function(al_db_con) {
  codigo_elemento_despesa <- tibble::tibble()
  tryCatch({
    codigo_elemento_despesa <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_ElementoDespesa;")
  },
  error = function(e) print(paste0("Erro ao buscar codigos de elementos de despesas no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_elemento_despesa)
}

#' @title Busca tipos de objetos de licitações no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos dos objetos de licitação
#' @rdname fetch_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(al_db_con)
fetch_tipo_objeto_licitacao <- function(al_db_con) {
  tipo_objeto_licitacao <- tibble::tibble()
  tryCatch({
    tipo_objeto_licitacao <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Tipo_Objeto_Licitacao;")
  },
  error = function(e) print(paste0("Erro ao buscar tipo_objeto_licitacao no Banco AL_BD (Postgres): ", e))
  )

  return(tipo_objeto_licitacao)
}

#' @title Busca tipos de modalidade de licitações no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos das modalidades de licitações
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(al_db_con)
fetch_tipo_modalidade_licitacao <- function(al_db_con) {
  tipo_modalidade_licitacao <- tibble::tibble()
  tryCatch({
    tipo_modalidade_licitacao <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Tipo_Modalidade_Licitacao;")
  },
  error = function(e) print(paste0("Erro ao buscar tipo_modalidade_licitacao no Banco AL_BD (Postgres): ", e))
  )

  return(tipo_modalidade_licitacao)
}

#' @title Busca regimes de execução no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre o regime de execução
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' regime_execucao <- fetch_regime_execucao(al_db_con)
fetch_regime_execucao <- function(al_db_con) {
  regime_execucao <- tibble::tibble()
  tryCatch({
    regime_execucao <- DBI::dbGetQuery(al_db_con, "SELECT * FROM RegimeExecucao;")
  },
  error = function(e) print(paste0("Erro ao buscar regime_execucao no Banco AL_BD (Postgres): ", e))
  )

  return(regime_execucao)
}

#' @title Busca contratos no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos(al_db_con)
fetch_contratos <- function(al_db_con) {
  contratos <- tibble::tibble()
  tryCatch({
    contratos <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Contratos;")
  },
  error = function(e) print(paste0("Erro ao buscar contratos no Banco AL_BD (Postgres): ", e))
  )

  return(contratos)
}

#' @title Busca os códigos subfunção no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos subfunção
#' @rdname fetch_codigo_subfuncao
#' @examples
fetch_codigo_subfuncao <- function(al_db_con) {
  codigo_subfuncao <- tibble::tibble()
  tryCatch({
    codigo_subfuncao <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_Subfuncao;")
  },
  error = function(e) print(paste0("Erro ao buscar código subfunção no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_subfuncao)
}

#' @title Busca os códigos sub-elementos no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos sub-elementos
#' @rdname fetch_codigo_subelemento
#' @examples
fetch_codigo_subelemento <- function(al_db_con) {
  codigo_subelemento <- tibble::tibble()
  tryCatch({
    codigo_subelemento <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_Subelemento;")
  },
  error = function(e) print(paste0("Erro ao buscar código subelemento no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_subelemento)
}

#' @title Busca os códigos das unidades gestoras no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos das unidades gestoras
#' @rdname fetch_codigo_unidade_gestora
#' @examples
fetch_codigo_unidade_gestora <- function(al_db_con) {
  codigo_unidade_gestora <- tibble::tibble()
  tryCatch({
    codigo_unidade_gestora <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_Unidade_Gestora;")
  },
  error = function(e) print(paste0("Erro ao buscar código da unidade gestora no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_unidade_gestora)
}

#' @title Busca os empenhos realizados no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os empenhos
#' @rdname fetch_empenhos
#' @examples
fetch_empenhos <- function(al_db_con) {
  empenhos <- tibble::tibble()
  tryCatch({
    empenhos <- DBI::dbGetQuery(al_db_con, "SELECT TOP 10 * FROM Empenhos;")
  },
  error = function(e) print(paste0("Erro ao buscar empenhos no Banco AL_BD (Postgres): ", e))
  )

  return(empenhos)
}

#' @title Busca os Aditivos realizados no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os aditivos de licitação/contrato
#' @rdname fetch_aditivos
#' @examples
fetch_aditivos <- function(al_db_con) {
  aditivos <- tibble::tibble()
  tryCatch({
    aditivos <- DBI::dbGetQuery(al_db_con, "SELECT TOP 10 * FROM Aditivos;")
  },
  error = function(e) print(paste0("Erro ao buscar aditivos no Banco AL_BD (Postgres): ", e))
  )

  return(aditivos)
}

#' @title Busca os Pagamentos realizados no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname fetch_pagamentos
#' @examples
fetch_pagamentos <- function(al_db_con) {
  pagamentos <- tibble::tibble()
  tryCatch({
    pagamentos <- DBI::dbGetQuery(al_db_con, "SELECT TOP 1000 * FROM Pagamentos;")
  },
  error = function(e) print(paste0("Erro ao buscar pagamentos no Banco AL_BD (Postgres): ", e))
  )

  return(pagamentos)
}

#' @title Busca os Convenios realizados no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre convênios
#' @rdname fetch_convenios
#' @examples
fetch_convenios <- function(al_db_con) {
  convenios <- tibble::tibble()
  tryCatch({
    convenios <- DBI::dbGetQuery(al_db_con, "SELECT TOP 10 * FROM Convenios;")
  },
  error = function(e) print(paste0("Erro ao buscar convênios no Banco AL_BD (Postgres): ", e))
  )

  return(convenios)
}

#' @title Busca os códigos códigos dos municípios no Banco AL_DB do Postgres
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos dos municípios
#' @rdname fetch_codigo_municipio
#' @examples
fetch_codigo_municipio <- function(al_db_con) {
  codigo_munipio <- tibble::tibble()
  tryCatch({
    codigo_munipio <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Codigo_Municipios;")
  },
  error = function(e) print(paste0("Erro ao buscar código do município no Banco AL_BD (Postgres): ", e))
  )

  return(codigo_munipio)
}

#' @title Busca participantes de licitações no banco SAGRES 2019
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre participantes
#' @rdname fetch_participantes
#' @examples
fetch_participantes <- function(al_db_con) {
  participantes <- tibble::tibble()
  tryCatch({
    participantes <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Participantes;")
  },
  error = function(e) print(paste0("Erro ao buscar Participantes no Banco AL_BD (Postgres): ", e))
  )

  return(participantes)
}

#' @title Busca fornecedores cadastrados no banco SAGRES 2019
#' @param al_db_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre fornecedores
#' @rdname fetch_fornecedores
#' @examples
fetch_fornecedores <- function(al_db_con) {
  fornecedores <- tibble::tibble()
  tryCatch({
    fornecedores <- DBI::dbGetQuery(al_db_con, "SELECT * FROM Fornecedores;")
  },
  error = function(e) print(paste0("Erro ao buscar Fornecedores no Banco AL_BD (Postgres): ", e))
  )

  return(fornecedores)
}
