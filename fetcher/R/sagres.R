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

fetch_codigo_funcao <- function(sagres_mysql_con) {
  codigo_funcao <- tibble::tibble()
  tryCatch({
    codigo_funcao <- DBI::dbGetQuery(sagres_mysql_con, "SELECT * FROM Codigo_Funcao;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_FUNCAO)
  },
  error = function(e) print(paste0("Erro ao buscar codigo de funcao no Banco Sagres (MySQL): ", e))
  )

  return(codigo_funcao)
}
