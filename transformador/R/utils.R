#' Gera um identificador único para cada registro do dataframe.
#' Usa o algoritmo md5 para gerar um hash a partir da concatenação das colunas
#' que devem ser chave primária do dataframe passado como parâmetro.
#' @param df Dataframe sem identificador único
#' @param colunas array com o nome das colunas que são chave primária do dataframe
#' @param id_coluna Nome da coluna do identificador
#' @return Dataframe com identificador único
.generate_hash_id <- function(df, colunas, id_coluna) {
  df <- df %>%
    dplyr::mutate(concat_chave_primaria = do.call(paste, lapply(colunas, function(x) get(x)))) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(!!id_coluna := digest::digest(concat_chave_primaria, algo="md5", serialize=F)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-concat_chave_primaria)

  return(df)
}
