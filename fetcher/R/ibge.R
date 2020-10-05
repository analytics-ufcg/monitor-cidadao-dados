fetch_distritos_ibge <- function(IBGE) {
  tryCatch({
    
    temp <- tempfile()
    download.file(IBGE, temp)    
    unzip (temp, exdir = "./data/ibge")
    unlink(temp)
    
    codigos_localidades_ibge <- readxl::read_excel("./data/ibge/RELATORIO_DTB_BRASIL_MUNICIPIO.xls")
    unlink("./data/ibge/", recursive = TRUE)
  
  },
  error = function(e) print(paste0("Erro ao buscar dados do IBGE (SQLServer): ", e))
  )
  
  return(codigos_localidades_ibge)
}
