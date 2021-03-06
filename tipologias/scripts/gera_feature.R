library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/AL_DB_DAO.R"))
source(here::here("R/process_contratos.R"))
source(here::here("R/tipologias.R"))
source(here::here("R/utils.R"))
source(here::here("R/process_gabarito_contratos.R"))

.HELP <- "Rscript gera_feature.R --vigencia <encerrados, vigentes e todos> --data_range_inicio <2012-01-01> --data_range_fim <2012_01_01>"

#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("--vigencia"), 
                          type="character",
                          default="todos",
                          help="Situações disponíveis: 'encerrados', 'vigentes' e 'todos'",
                          metavar="character"),
    optparse::make_option(c("--data_range_inicio"), 
                         type="character",
                         default="2012-01-01",
                         help="Data inicial da seleção (utiliza a data da assinatura do contrato).",
                         metavar="character"),
    optparse::make_option(c("--data_range_fim"),
                          type="character",
                          default="2019-01-01",
                          help="Data final da seleção (utiliza a data da assinatura do contrato).",
                          metavar="character")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt)
}

#' @title Escreve dataframes das tipologias
write_features <- function(tipologias_final_contratos_gerais, features, VIGENCIA, data_range_inicio, data_range_fim) {
  readr::write_csv(tipologias_final_contratos_gerais, 
                   paste("data/features/features_wide_",
                         VIGENCIA,
                         "_",
                         data_range_inicio,
                         "-",
                         data_range_fim,
                         "_",
                         gsub(":", "", gsub("[[:space:]]", "_", Sys.time())), ".csv", sep = ""))
  readr::write_csv(features, 
                   paste("data/features/features_gather_",
                         VIGENCIA,
                         "_",
                         data_range_inicio,
                         "-",
                         data_range_fim,
                         "_",
                         gsub(":", "", gsub("[[:space:]]", "_", Sys.time())), ".csv", sep = ""))
  
}

#' @title Gera hashcode do código fonte
generate_hash_source_code <- function() {
  source_code_string <- paste(readr::read_file(here::here("scripts/gera_feature.R")),
                              readr::read_file(here::here("R/process_gabarito_contratos.R")),
                              readr::read_file(here::here("R/AL_DB_DAO.R")),
                              readr::read_file(here::here("R/process_contratos.R")),
                              readr::read_file(here::here("R/process_licitacoes.R")),
                              readr::read_file(here::here("R/process_propostas.R")),
                              readr::read_file(here::here("R/tipologias.R")),
                              readr::read_file(here::here("R/utils.R")))
  
  hash_source_code <- digest::digest(source_code_string, algo="md5", serialize=F)
}

#-----------------------------------------------------------------------------#

#-----------------------------------CONFIG-----------------------------------#

ENCERRADOS <- "encerrados"
VIGENTES <- "vigentes"
GERAIS <- "todos"

args <- get_args()

vigentes <- args$vigencia
data_range_inicio <- args$data_range_inicio
data_range_fim <- args$data_range_fim

al_db_con <- NULL

tryCatch({al_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                      dbname = POSTGRES_DB, 
                                      host = POSTGRES_HOST, 
                                      port = POSTGRES_PORT,
                                      user = POSTGRES_USER,
                                      password = POSTGRES_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco ALDB (Postgres): ", e)))

hash_source_code <- generate_hash_source_code()

#-----------------------------------------------------------------------------#

#-----------------------------------EXECUÇÃO-----------------------------------#
#Carrega dados
print("Carregando licitações...")
licitacoes <- carrega_licitacoes(al_db_con)

print("Carregando contratos...")

contratos <- tibble::tibble()

if (vigentes == "vigentes") {
  contratos = carrega_contratos(al_db_con, vigentes = TRUE, data_range_inicio, data_range_fim) %>% dplyr::mutate(vigente = TRUE)
} else if (vigentes == "encerrados") {
  contratos = carrega_contratos(al_db_con, vigentes = FALSE, data_range_inicio, data_range_fim) %>% dplyr::mutate(vigente = FALSE)
} else {
  contratos = dplyr::bind_rows(carrega_contratos(al_db_con, vigentes = TRUE, data_range_inicio, data_range_fim) %>% dplyr::mutate(vigente = TRUE),
                               carrega_contratos(al_db_con, vigentes = FALSE, data_range_inicio, data_range_fim) %>% dplyr::mutate(vigente = FALSE))
}

print("Carregando propostas de licitações...")
propostas <- carrega_propostas_licitacao(al_db_con)

#Processa dados
print("Processando contratos...")
contratos_processados <- contratos %>% process_contratos()
print("Calculando contratos por cnpj...")
contratos_by_cnpj <- contratos_processados %>% count_contratos_by_cnpj() %>% 
  dplyr::mutate(nu_cpfcnpj = gsub ("\\D", "", nu_cpfcnpj))
print("Buscando vencedores a partir dos contratos...")
licitacoes_vencedoras <- contratos_processados %>% get_vencedores_by_contratos()
print("Cruzando propostas com licitações...")
propostas_licitacoes <- propostas %>% dplyr::inner_join(licitacoes)

#Carrega dados dependentes
print("Carregando participantes...")
participantes <- carrega_participantes(al_db_con, contratos_by_cnpj$nu_cpfcnpj)

#Gera tipologias
print("Gerando tipologias de licitações...")
tipologias_licitacao <- gera_tipologia_licitacao(licitacoes, contratos_processados, contratos_by_cnpj, licitacoes_vencedoras, participantes)
print("Gerando tipologias de propostas...")
tipologias_proposta <- gera_tipologia_proposta(propostas_licitacoes, contratos_by_cnpj)

#Merge tipologias e adiciona gabarito
print("Cruzando tipologias...")
contratos_tramita <- carrega_contratos_mutados(al_db_con)

tipologias_merge <- merge_tipologias(contratos_processados, tipologias_licitacao, tipologias_proposta) %>% 
  processa_gabarito_tramita(contratos_tramita) %>% 
  replace_nas()

#Gera tipologias contratos
print("Gerando tipologias de contratos...")
tipologias_contrato <- gera_tipologia_contrato(tipologias_merge, contratos_processados, contratos)

#Gera tipologias finais
print("Gerando tipologias gerais...")
tipologias_final_contratos_gerais <- tipologias_merge %>% 
  dplyr::left_join(tipologias_contrato, by = c("cd_u_gestora", "nu_contrato", "nu_cpfcnpj", "data_inicio")) %>% 
  dplyr::select(id_contrato, dplyr::everything())

#Criando dataframe de features
features <- tipologias_final_contratos_gerais %>% tidyr::gather(key = "nome_feature", 
                                                                value = "valor_feature", 
                                                                -id_contrato) %>% 
  dplyr::mutate(timestamp = Sys.time(),
                hash_bases_geradoras = generate_hash_al_db(al_db_con),
                hash_codigo_gerador_feature = hash_source_code) %>%
  dplyr::rowwise() %>% 
  dplyr::mutate(id_feature = digest::digest(paste(id_contrato,
                                                  nome_feature,
                                                  hash_bases_geradoras, 
                                                  hash_codigo_gerador_feature), algo="md5", serialize=F)) %>% 
  dplyr::select(id_feature, dplyr::everything())

#Escrevendo arquivos
if (vigentes == "vigentes") {
  write_features(tipologias_final_contratos_gerais, features, VIGENTES, data_range_inicio, data_range_fim)
} else if (vigentes == "encerrados") {
  write_features(tipologias_final_contratos_gerais, features, ENCERRADOS, data_range_inicio, data_range_fim)
} else {
  write_features(tipologias_final_contratos_gerais, features, GERAIS, data_range_inicio, data_range_fim)
}

#Compactando código gerador 
#zip(paste("data/source_code/",hash_source_code, ".zip", sep = ""), c("R", "scripts"))

DBI::dbDisconnect(al_db_con)