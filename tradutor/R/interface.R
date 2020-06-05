library(magrittr)

source(here::here("R/sagres.R"))
source(here::here("R/read_utils.R"))

#' @title Obtem dados das licitações 
#' @return Dataframe contendo informações sobre as licitações
#' @rdname get_licitacoes
#' @examples
#' licitacoes_dt <- get_licitacoes()
get_licitacoes <- function() {
  licitacoes_dt <- read_licitacoes() %>% 
    translate_licitacoes()
}