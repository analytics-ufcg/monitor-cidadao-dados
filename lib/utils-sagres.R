
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
  return(result$de_Municipio)
}