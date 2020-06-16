source(here::here("R/cols_constants.R"))
source(here::here("R/utils.R"))

#' @title Busca licitações no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre as licitações
#' @rdname fetch_licitacoes
#' @examples
#' licitacoes <- fetch_licitacoes("2018")
fetch_licitacoes <- function(sagres_mysql_con) {
  licitacoes <- tibble::tibble()
  tryCatch({
    licitacoes <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Licitacao;") %>%
      assert_dataframe_completo(COLNAMES_LICITACOES)
  },
  error = function(e) print(paste0("Erro ao buscar licitações no Banco Sagres (MySQL): ", e))
  )

  return(licitacoes)
}

#' @title Busca codigos de funções no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname fetch_codigo_funcao
#' @examples
#' codigo_funcao <- fetch_codigo_funcao("2018")
fetch_codigo_funcao <- function(sagres_mysql_con) {
  codigo_funcao <- tibble::tibble()
  tryCatch({
    codigo_funcao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Codigo_Funcao;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_FUNCAO)
  },
  error = function(e) print(paste0("Erro ao buscar codigos de funcões no Banco Sagres (MySQL): ", e))
  )

  return(codigo_funcao)
}

#' @title Busca codigos de elementos de despesas no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname fetch_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa <- fetch_codigo_elemento_despesa("2018")
fetch_codigo_elemento_despesa <- function(sagres_mysql_con) {
  codigo_elemento_despesa <- tibble::tibble()
  tryCatch({
    codigo_elemento_despesa <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Codigo_ElementoDespesa;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_ELEMENTO_DESPESA)
  },
  error = function(e) print(paste0("Erro ao buscar codigos de elementos de despesas no Banco Sagres (MySQL): ", e))
  )

  return(codigo_elemento_despesa)
}

#' @title Busca licitações no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos dos objetos de licitação
#' @rdname fetch_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao("2018")
fetch_tipo_objeto_licitacao <- function(sagres_mysql_con) {
  tipo_objeto_licitacao <- tibble::tibble()
  tryCatch({
    tipo_objeto_licitacao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Tipo_Objeto_Licitacao;") %>% 
      assert_dataframe_completo(COLNAMES_TIPO_OBJETO_LICITACAO)
  },
  error = function(e) print(paste0("Erro ao buscar tipo_objeto_licitacao no Banco Sagres (MySQL): ", e))
  )
  
  return(tipo_objeto_licitacao)
}

#' @title Busca licitações no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos das modalidades de licitações
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao("2018")
fetch_tipo_modalidade_licitacao <- function(sagres_mysql_con) {
  tipo_modalidade_licitacao <- tibble::tibble()
  tryCatch({
    tipo_modalidade_licitacao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Tipo_Modalidade_Licitacao;") %>% 
      assert_dataframe_completo(COLNAMES_TIPO_MODALIDADE_LICITACAO)
  },
  error = function(e) print(paste0("Erro ao buscar tipo_modalidade_licitacao no Banco Sagres (MySQL): ", e))
  )
  
  return(tipo_modalidade_licitacao)
}

#' @title Busca licitações no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre o regime de execução
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' regime_execucao <- fetch_regime_execucao("2018")
fetch_regime_execucao <- function(sagres_mysql_con) {
  regime_execucao <- tibble::tibble()
  tryCatch({
    regime_execucao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM RegimeExecucao;") %>% 
      assert_dataframe_completo(COLNAMES_REGIME_EXECUCAO)
  },
  error = function(e) print(paste0("Erro ao buscar regime_execucao no Banco Sagres (MySQL): ", e))
  )
  
  return(regime_execucao)
}

#' @title Busca licitações no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos("2018")
fetch_contratos <- function(sagres_mysql_con) {
  contratos <- tibble::tibble()
  tryCatch({
    contratos <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Contratos;") %>% 
      assert_dataframe_completo(COLNAMES_CONTRATOS)
  },
  error = function(e) print(paste0("Erro ao buscar contratos no Banco Sagres (MySQL): ", e))
  )
  
  return(contratos)
}

#' @title Busca os códigos subfunção no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos subfunção
#' @rdname fetch_codigo_subfuncao
#' @examples
fetch_codigo_subfuncao <- function(sagres_mysql_con) {
  codigo_subfuncao <- tibble::tibble()
  tryCatch({
    codigo_subfuncao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Codigo_Subfuncao;") %>% 
      assert_dataframe_completo(COLNAMES_CODIGO_SUBFUNCAO)
  },
  error = function(e) print(paste0("Erro ao buscar código subfunção no Banco Sagres (MySQL): ", e))
  )
  
  return(codigo_subfuncao)
}

#' @title Busca os códigos sub-elementos no Banco do Sagres MySQL
#' @param sagres_mysql_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos sub-elementos
#' @rdname fetch_codigo_subelemento
#' @examples
fetch_codigo_subelemento <- function(sagres_mysql_con) {
  codigo_subfuncao <- tibble::tibble()
  tryCatch({
    codigo_subfuncao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Codigo_Subelemento;") %>% 
      assert_dataframe_completo(COLNAMES_CODIGO_SUBELEMENTO)
  },
  error = function(e) print(paste0("Erro ao buscar código subelemento no Banco Sagres (MySQL): ", e))
  )
  
  return(codigo_subfuncao)
}
