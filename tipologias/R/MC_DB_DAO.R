
#' @description Carrega a informações das features
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return Data frame com informações das features. 
carrega_features <- function(mc_db_con, id_feature) {
  
  features <- tibble::tibble()

  template <- ('SELECT * 
              FROM feature
              INNER JOIN feature_set_has_feature
              ON feature_set_has_feature.id_feature_set = \'%s\' 
              AND feature.id_feature = feature_set_has_feature.id_feature'
              )

  query <- template  %>% 
    sprintf(paste(id_feature, collapse = "")) %>%
    dplyr::sql()

  tryCatch({
    features <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar features no Banco MC_DB (Postgres): ", e))
)
  return(features)
}

#' @description Carrega a informações do feature_set
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return Data frame com informações das features. 
carrega_feature_set <- function(mc_db_con) {
  
  features_set <- tibble::tibble()
  
  template <- ('SELECT * FROM feature_set')
  
  query <- template %>%
    dplyr::sql()
  
  tryCatch({
    features_set <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar features_set no Banco MC_DB (Postgres): ", e))
  )
  return(features_set)
}
