
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
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_localidade_ibge.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_municipio.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_licitacao.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_contrato.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_empenho.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_participante.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_pagamento.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_proposta.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_estorno_pagamento.sql"))
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/create/create_contrato_mutado.sql"))
}

#' @title Importa dados para as tabelas do Banco de dados
import <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/import/import_data.sql"))
}

#' @title Importa dados do TCE-RS para as tabelas do banco de dados
import_tce_rs <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/import/import_data_tce_rs.sql"))
}


#' @title "Dropa as tabelas do Banco de Dados"
clean <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db, " -f ", " /feed-al/scripts/drop/drop_tables.sql"))
}

#' @title Acessa terminal do banco de dados
shell <- function() {
  system(paste0("psql -h ", host, " -U ", user, " -d ", db))
}


#-----------------------------------EXECUÇÃO-----------------------------------#

args <- get_args()

funct <- args$funct

host <- Sys.getenv("POSTGRES_HOST")
user <- Sys.getenv("POSTGRES_USER")
db <- Sys.getenv("POSTGRES_DB")
password <- Sys.getenv("POSTGRES_PASSWORD")
Sys.setenv(PGPASSWORD = password)

if (funct == "create") {
  create()
} else if (funct == "import") {
  import()
}  else if (funct == "import-tce-rs") {
  import_tce_rs()
}else if ( funct == "shell") {
  shell()
} else if ( funct == "clean"){
  clean()
} else {
  shell()
}
