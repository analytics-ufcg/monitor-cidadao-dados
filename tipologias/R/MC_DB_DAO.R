
#' @description Carrega a informações das features pelo id do feature_set
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return Data frame com informações das features. 
carrega_features_by_id_feature_set <- function(mc_db_con, id_feature_set) {
  
  features <- tibble::tibble()

  template <- ('SELECT * 
              FROM feature
              INNER JOIN feature_set_has_feature
              ON feature_set_has_feature.id_feature_set = \'%s\' 
              AND feature.id_feature = feature_set_has_feature.id_feature'
              )

  query <- template  %>% 
    sprintf(paste(id_feature_set, collapse = "")) %>%
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


#' @description Carrega a informações das features mais recentes
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return Data frame com informações das features mais recentes. 
carrega_features_recentes<- function(mc_db_con) {
  
  features <- tibble::tibble()

  template <- ('SELECT 
              DISTINCT ON (id_contrato, nome_feature) * 
              FROM 
              feature 
              ORDER  BY id_contrato, nome_feature, timestamp 
              DESC NULLS LAST'
              )

  query <- template  %>%
    dplyr::sql()

  tryCatch({
    features <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar features no Banco MC_DB (Postgres): ", e))
)
  return(features)
}

#' @description Busca se o feature_set está atualizado. Em outras palavras, verifica se a 
#'              o feature_set mais recente contém os hashs mais recentes do banco e do codigo.
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return TRUE caso o features sets estejam desatualizados e FALSE caso contrário.
is_features_sets_atualizados<- function(mc_db_con) {
  
  is_fs_atualizados <- tibble::tibble()
  
  template <- ('WITH ultimo_feature_set AS ( SELECT * FROM feature_set WHERE timestamp >= (SELECT MAX(timestamp) FROM feature) LIMIT 1), ultima_feature AS ( SELECT DATE(MAX(timestamp)), hash_bases_geradoras, hash_codigo_gerador_feature FROM feature GROUP BY hash_bases_geradoras, hash_codigo_gerador_feature LIMIT 1 ) SELECT CASE WHEN EXISTS ( SELECT * FROM ( SELECT *, (SELECT hash_bases_geradoras FROM ultima_feature) as hash_base_atual, (SELECT hash_codigo_gerador_feature FROM ultima_feature) as hash_codigo_atual FROM feature_set_has_feature as fshf LEFT JOIN feature as f ON fshf.id_feature = f.id_feature AND fshf.id_feature_set = (SELECT id_feature_set FROM ultimo_feature_set) ) as ultima_feature_infos_update WHERE hash_base_atual = hash_bases_geradoras AND hash_codigo_atual = hash_codigo_atual LIMIT 10 ) THEN \'TRUE\' ELSE \'FALSE\' END'
  )
  
  query <- template  %>%
    dplyr::sql()
  
  tryCatch({
    is_fs_atualizados <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar se o feature set está atualizado no Banco MC_DB (Postgres): ", e))
  )
  return(is_fs_atualizados)
}


#' @description Busca se o feature_set mais atual
#' @param mc_db_con Faz a conexão com o banco MC_DB
#' @return timestamp e o id_feature_set do último feature_set cadastrado no banco.
get_ultimo_feature_set<- function(mc_db_con) {
  
  ultimo_feature_set <- tibble::tibble()
  
  template <- ('SELECT 
               * 
               FROM
               feature_set 
               WHERE 
               timestamp >= (SELECT MAX(timestamp) FROM feature) 
               LIMIT 1'
  )
  
  query <- template  %>%
    dplyr::sql()
  
  tryCatch({
    ultimo_feature_set <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
  },
  error = function(e) print(paste0("Erro ao buscar o último feature set no Banco MC_DB (Postgres): ", e))
  )
  return(ultimo_feature_set)
}








