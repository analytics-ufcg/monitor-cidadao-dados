library(magrittr)

source(here::here("../lib_modelos/modelagem_medidas_avaliacao.R"))
source(here::here("R/MC_DB_DAO.R"))


.HELP <- "
\t   Rscript gera_experimento.R
\t   Modelos treinados: Floresta Aleatória e Regressão Logística.
\t   Outputs desejados:
\t   indice_exp_<data_geracao>.csv
\t   metricas_<data_geracao>.csv
\t   experimento_<data_geracao>.csv
"

#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("-v", "--vigentes"),
                          type="logical",
                          default="TRUE",
                          help=.HELP,
                          metavar="logical")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}

mygc <- function() invisible(gc())

#' @title Gera hashcode do código fonte do treinamento
generate_hash_sourcecode <- function() {
  source_code_string <- paste(readr::read_file(here::here("scripts/gera_experimento.R")))
  
  hash_source_code <- digest::digest(source_code_string, algo="md5", serialize=F)
}


#' @title Gera identificador do experimento
generate_id_experimento <- function(momentum) {
  return(digest::digest(paste(momentum), algo="md5", serialize=F))
}


#-----------------------------------------------------------------------------#


#-------------------------CONFIG E VARIÁVEIS GLOBAIS--------------------------#

mc_db_con <- NULL

tryCatch({mc_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_MCDB_DB, 
                                      host = POSTGRES_MCDB_HOST, 
                                      port = POSTGRES_MCDB_PORT,
                                      user = POSTGRES_MCDB_USER,
                                      password = POSTGRES_MCDB_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco MCDB (Postgres): ", e)))

set.seed(123)
options(scipen = 999)
invisible(Sys.setlocale(category = "LC_ALL", locale = "pt_PT.UTF-8"))

args <- get_args()

data_hora <- gsub(":", "", gsub("[[:space:]]", "_", Sys.time()))
id_experimento <- generate_id_experimento(data_hora)

algoritmo <- c("Regressão Logístia",
               "Floresta Aleatória")

#-----------------------------------------------------------------------------#

#-----------------------------------EXECUÇÃO-----------------------------------#

feature_set <- tibble::tibble()

template <- ('SELECT * FROM feature_set')

query <- template %>%
  dplyr::sql()

tryCatch({
  feature_set <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar feature_set no Banco MC_DB (Postgres): ", e)))

feature_set %<>% dplyr::mutate(match = all(entrada %>% purrr::map(~.x%in% jsonlite::fromJSON(features_descricao)))
                                       & length(entrada) == length(features_desejadas))

matched_set <- (feature_set %>% dplyr::filter(match == TRUE) %>% tail(1))$id_feature_set

features <- tibble::tibble()



template <- ('SELECT * 
              FROM feature
              INNER JOIN feature_set_has_feature
              ON feature_set_has_feature.id_feature_set = \'f8eac683daeabd41217776cd5cc0f6b9\' 
              AND feature.id_feature = feature_set_has_feature.id_feature
             ')

query <- template %>%
  dplyr::sql()

tryCatch({
  features <- dplyr::tbl(mc_db_con, query) %>% dplyr::collect(n = Inf)
},
error = function(e) print(paste0("Erro ao buscar featuresno Banco MC_DB (Postgres): ", e)))
