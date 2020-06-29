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

#' Extrai o código do município do código da unidade gestora. 
#' Essa estração é feita através da coleta dos últimos 3 digitos da unidade gestora.
#' @param df Dataframe sem o código do município
#' @param cd_u_gestora código da unidade gestora
#' @return Dataframe com o código do município
.extract_cd_municipio  <- function (df, cd_u_gestora) {
  df <- df %>%
    dplyr::mutate(cd_municipio = .substrRight(cd_u_gestora, 3))
  
  return(df)
}

#' Extrai os últimos n caracteres de uma string.
#' @param x string com todos os caracteres
#' @param n numero de caracteres que serão extraídos
#' @return os últimos n caracteres
.substrRight <- function(x, n) {
  substr(x, nchar(x)-n+1, nchar(x))
}

