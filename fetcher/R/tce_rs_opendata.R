source(here::here("R/setup/constants.R"))

#' @title Busca licitações no site do TCE-RS
#' @param ano ano dos arquivos
#' @return Dataframe contendo informações sobre as licitações
#' @rdname fetch_licitacoes
#' @examples
#' licitacoes <- fetch_licitacoes(ano)
fetch_licitacoes <- function(ano) {
  file_licitacoes_temp <- tempfile()
  tryCatch({
    download.file(sprintf(TCE_RS_OPENDATA_LICITACOES, ano), file_licitacoes_temp)
  },
  error = function(e) stop(paste0("Erro ao buscar licitações no site do TCE-RS: ", e))
  )
  return(file_licitacoes_temp)
}

#' @title Busca contratos no site do TCE-RS
#' @param ano ano dos arquivos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos(ano)
fetch_contratos <- function(ano) {
  file_contratos_temp <- tempfile()
  tryCatch({
    download.file(sprintf(TCE_RS_OPENDATA_CONTRATOS, ano), file_contratos_temp)
  },
  error = function(e) stop(paste0("Erro ao buscar contratos no site do TCE-RS: ", e))
  )
  return(file_contratos_temp)
}

#' @title Busca empenhos no site do TCE-RS
#' @param ano dos arquivos
#' @return Dataframe contendo informações sobre os empenhos
#' @rdname fetch_empenhos
#' @examples
#' empenhos <- fetch_empenhos(ano)
fetch_empenhos <- function(ano) {
  file_empenhos_temp <- tempfile()
  tryCatch({
    download.file(sprintf(TCE_RS_OPENDATA_EMPENHOS, ano), file_empenhos_temp)
  },
  error = function(e) stop(paste0("Erro ao buscar empenhos no site do TCE-RS: ", e))
  )
  return(file_empenhos_temp)
}

#' @title Busca órgãos no site do TCE-RS
#' @return Dataframe contendo informações sobre os órgãos
#' @rdname fetch_orgaos
#' @examples
#' orgaos <- fetch_orgaos()
fetch_orgaos <- function() {
  file_orgaos_temp <- tempfile()
  tryCatch({
    download.file(TCE_RS_OPENDATA_ORGAOS, file_orgaos_temp)
  },
  error = function(e) stop(paste0("Erro ao buscar órgãos no site do TCE-RS: ", e))
  )
  return(read.csv(file_orgaos_temp))
}




