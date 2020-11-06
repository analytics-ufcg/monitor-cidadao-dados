message("")
message(" ------------------------------------------")
message("    INICIANDO SCRIPT - FETCH DADOS RS   ")
message(" ------------------------------------------")
message("")

library(magrittr)
source(here::here("R/tce_rs_opendata.R"))
source(here::here("R/utils.R"))


#-----------------------------------------------------------------------------#
#-------------------------         FUNÇÕES          --------------------------#
#-----------------------------------------------------------------------------#
message(" CARREGANDO FUNÇÕES...")
message("")


.HELP <- "Rscript scripts/fetch_tce_rs_opendata.R --ano <2018,2019,2020 ou todos>"

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("--ano"),
                          type="character",
                          default="todos",
                          help="Opções possíveis: 2018,2019,2020 ou todos",
                          metavar="character")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}

#' @title Cria diretório
create_dir <- function(work_dir, output_dir, ano_exec="") {
  path <- file.path(work_dir, sprintf(output_dir, ano_exec))
  suppressWarnings(dir.create(path, recursive = TRUE))
  return(path)
}

#-----------------------------------------------------------------------------#
#-------------------------CONFIG E VARIÁVEIS GLOBAIS--------------------------#
#-----------------------------------------------------------------------------#
message(" REALIZANDO CONFIG. DO BD E SETANDO VARIÁVEIS GLOBAIS...")
message("")

ANOS_DISPONIVEIS <- c(2016, 2017, 2018, 2019, 2020)
OUTPUT_DIR_LICITACOES <- "data/rs/licitacoes/%s"
OUTPUT_DIR_CONTRATOS <- "data/rs/contratos/%s"
OUTPUT_DIR_EMPENHOS <- "data/rs/empenhos/%s"
OUTPUT_DIR_ORGAOS <- "data/rs/orgaos/"

message("   Variáveis setadas com sucesso!")
message("")
message("")

#-----------------------------------------------------------------------------#
#-------------------------         EXECUÇÃO         --------------------------#
#-----------------------------------------------------------------------------#
# Parâmetros/Argumentos
args <- get_args()
ano_input <- args$ano

# verifica se os parâmetros são válidos
if(!(ano_input %in% ANOS_DISPONIVEIS) && ano_input != "todos") {
  stop(sprintf("O ano \'%s\' não está disponível para download no site do TCE-RS.", ano_input))
  message("")
} 

message(" INICIANDO O FETCH DOS DADOS...")
message("")

# seta os anos que serão executados 
anos_exec <- ANOS_DISPONIVEIS
if (ano_input != "todos"){
  anos_exec <- c(ano_input)
}

work_dir <- getwd()
# realiza o fetch dos arquivos que são anuais
for(ano_exec in anos_exec){
  # fetch licitacoes
  message(sprintf("   Realizando fetch das licitações do ano %s.",ano_exec))
  message("")
  licitacoes_zip <- fetch_licitacoes(ano_exec)
  path_licitacoes <- create_dir(work_dir, OUTPUT_DIR_LICITACOES, ano_exec)
  decompress_file(path_licitacoes, licitacoes_zip)
  unlink(licitacoes_zip)
  
  # fetch contratos
  message(sprintf("   Realizando fetch dos contratos do ano %s.",ano_exec))
  message("")
  contratos_zip <- fetch_contratos(ano_exec)
  path_contratos <- create_dir(work_dir, OUTPUT_DIR_CONTRATOS, ano_exec)
  decompress_file(path_contratos, contratos_zip)
  unlink(contratos_zip)
  
  # fetch empenhos
  message(sprintf("   Realizando fetch dos empenhos do ano %s.",ano_exec))
  message("")
  empenhos_zip <- fetch_empenhos(ano_exec)
  path_empenhos <- create_dir(work_dir, OUTPUT_DIR_EMPENHOS, ano_exec)
  decompress_file(path_empenhos, empenhos_zip)
  unlink(empenhos_zip)
  
}

# realiza o fetch dos arquivos que não são anuais
# fetch órgãos
message("   Realizando fetch dos órgãos...")
message("")
orgaos_df <- fetch_orgaos()
path_orgaos <- create_dir(work_dir, OUTPUT_DIR_ORGAOS)
readr::write_csv(orgaos_df,  paste(path_orgaos, "orgaos_auditados_rs.csv", sep=" "))


