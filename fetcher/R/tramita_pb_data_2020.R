#' @title Busca licitações de 2020 em CSVs do Tramita PB
#' @param licitacoes link de download do arquivo de licitações de 2020 da PB
#' @return Dataframe contendo informações sobre as licitações
#' @rdname fetch_licitacoes_2020
#' @examples
#' licitacoes <- fetch_licitacoes_2020(licitacoes)
fetch_licitacoes_2020 <- function(licitacoes) {
  tryCatch({
    
    temp <- tempfile()
    download.file(licitacoes, temp)    
    unzip (temp, exdir = "./data/licitacoes_tramita_pb_2020")
    unlink(temp)
    
    licitacoes_tramita_pb_2020 <- readr::read_csv2("./data/licitacoes_tramita_pb_2020/TCE-PB-Licitacoes_2020.csv")
    unlink("./data/licitacoes_tramita_pb_2020", recursive = TRUE)
  
  },
  error = function(e) print(paste0("Erro ao buscar dados das Licitações de 2020 da PB (SQLServer): ", e))
  )
  
  return(licitacoes_tramita_pb_2020)
}

#' @title Busca contratos de 2020 em CSVs do Tramita PB
#' @param contratos link de download do arquivo de contratos de 2020 da PB
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos_2020
#' @examples
#' contratos <- fetch_contratos_2020(licitacoes)
fetch_contratos_2020 <- function(contratos) {
  tryCatch({
    temp <- tempfile()
    download.file(contratos, temp)    
    unzip (temp, exdir = "./data/contratos_tramita_pb_2020")
    unlink(temp)
    
    contratos_tramita_pb_2020 <- readr::read_csv2("./data/contratos_tramita_pb_2020/TCE-PB-Contratos_2020.csv")
    unlink("./data/contratos_tramita_pb_2020", recursive = TRUE)
  
  },
  error = function(e) print(paste0("Erro ao buscar dados dos Contratos de 2020 da PB (SQLServer): ", e))
  )
  
  return(contratos_tramita_pb_2020)
}
