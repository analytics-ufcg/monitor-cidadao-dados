#' Garante que o dataframe x tem todas as colunas passadas em y
#' @param x dataframe
#' @param y vetor contendo os nomes das colunas
#' @param warning booleano que exibe mensagem 
assert_dataframe_completo <- function(x, y, warning = FALSE){
  if(nrow(x) != 0){
    colnames_x <- colnames(x)
    colnames_y <- names(y)
    types_y <- unname(y)
    indexes <- !(colnames_y %in% colnames_x)
    
    if (any(indexes) & warning) {
      cat(crayon::red("\n", "Colunas não encontradas:", "\n  ", paste(colnames_y[indexes], collapse="\n   "),"\n"))
    }
    nao_esperadas = colnames_x[!(colnames_x %in% colnames_y)]
    if (length(nao_esperadas) & warning) {
      cat(crayon::red("\n", "Colunas não esperadas:", "\n  ", paste(nao_esperadas, collapse="\n   "),"\n"))
      
    }
    
    if (any(indexes)) {
      df_y <- y %>%
        t() %>%
        as.data.frame()
      
      diff_df <- df_y[colnames_y[indexes]]
      
      diff_df <- diff_df %>%
        dplyr::mutate_all(.funs = ~ .replace_na(.))
      
      x <- x %>% 
        cbind(diff_df)
    }
    
    x
  } else tibble::tibble()
}
