#' @description Carrega a informações das features
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return Data frame com informações das features. 
carrega_features <- function(mc_db_con) {
  
  features <- tibble::tibble()

  template <- ('SELECT id_feature, nome_feature
                FROM feature')

  query <- template %>%
    dplyr::sql()

  tryCatch({
    features <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar features no Banco MC_DB (Postgres): ", e))
)
  return(features)
}
