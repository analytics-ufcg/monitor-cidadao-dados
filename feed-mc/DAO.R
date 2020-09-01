.HELP <- "
Rscript DAO.R -f <funct>
"

.FUNCT_HELP <- "
\t   funct = create -> Cria as tabelas do Banco de dados
\t   funct = import -> Importa dados para as tabelas do Banco de dados
\t   funct = shell -> Acessa terminal do banco de dados
"

#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("-f", "--funct"),
                          type="character",
                          default="shell",
                          help=.FUNCT_HELP,
                          metavar="character")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}

#' @title Cria as tabelas do Banco de dados
create <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_feature.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_feature_set.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_indice_part.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_metrica.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_experimento.sql"))
  # system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/create/create_previsao_prod.sql"))
}

#' @title Importa dados das features para o MCDB
import_feature <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/import/import_data_feature.sql"))
}

#' @title Importa dados do feature set para o MCDB
import_feature_set <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/import/import_data_feature_set.sql"))
}

#' @title Importa dados do experimento para o MCDB
import_experimento <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/import/import_data_experimento.sql"))
}

#' @title "Dropa as tabelas do Banco de Dados"
clean <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-mc/scripts/drop/drop_tables.sql"))
}

#' @title Acessa terminal do banco de dados
shell <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db))
}


#-----------------------------------EXECUÇÃO-----------------------------------#

args <- get_args()

funct <- args$funct

host <- Sys.getenv("POSTGRES_MCDB_HOST")
user <- Sys.getenv("POSTGRES_MCDB_USER")
db <- Sys.getenv("POSTGRES_MCDB_DB")
password <- Sys.getenv("POSTGRES_MCDB_PASSWORD")
Sys.setenv(PGPASSWORD = password)

if (funct == "create") {
  create()
} else if (funct == "import_feature") {
  import_feature()
} else if (funct == "import_feature_set") {
  import_feature_set()
} else if (funct == "import_experimento") {
  import_experimento()
} else if ( funct == "shell") {
  shell()
} else if ( funct == "clean"){
  clean()
} else {
  shell()
}