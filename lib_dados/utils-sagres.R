#' @title Associa o nome do município a partir do número da Unidade Gestora (3 últimos dígitos)
#' @param cd_UGestora Código da Unidade Gestora
#' @return 
#' @rdname 
#' @examples
get_municipio <- function(cd_UGestora) {
  library(plyr)
  result <- data.frame(
    cd_Municipio = stri_sub(cd_UGestora, -3)) %>%
    join(municipios)
  return(result$no_Municipio)
}

#' @title
#' @param nu_CPFCNPJ Número do CPF ou CNPJ 
#' @return 
#' @rdname 
#' @examples
get_fornecedor <- function(nu_CPFCNPJ){
  result <- data.frame(nu_CPFCNPJ) %>%
    join(fornecedores)
  return(select(result, nu_CPFCNPJ, no_Fornecedor))
}
