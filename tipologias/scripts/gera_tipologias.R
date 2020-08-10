library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/DAO.R"))
source(here::here("R/process_contratos.R"))
source(here::here("R/tipologias.R"))
source(here::here("R/utils.R"))
source(here::here("R/carrega_gabarito_contratos.R"))

.HELP <- "Rscript gera_tipologias.R -v <vigentes>"


#-----------------------------------FUNÇÕES-----------------------------------#

#' @title Obtém argumentos passados por linha de comando
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("-v", "--vigentes"),
                          type="logical",
                          default="TRUE",
                          help="Boleano que decide se gera tipologias apenas para contratos vigentes ou não",
                          metavar="logical")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list, usage = .HELP)
  
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}
#-----------------------------------------------------------------------------#

args <- get_args()

vigentes <- args$vigentes

al_db_con <- NULL

tryCatch({al_db_con <- DBI::dbConnect(RPostgres::Postgres(),
                                         dbname = POSTGRES_DB, 
                                         host = POSTGRES_HOST, 
                                         port = POSTGRES_PORT,
                                         user = POSTGRES_USER,
                                         password = POSTGRES_PASSWORD)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco ALDB (Postgres): ", e)))

#Carrega dados
print("Carregando licitações...")
licitacoes <- carrega_licitacoes(al_db_con)
print("Carregando contratos...")
contratos <- carrega_contratos(al_db_con, vigentes) 
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
tipologias_merge <- merge_tipologias(contratos_processados, tipologias_licitacao, tipologias_proposta) %>% 
  carrega_gabarito_tramita() %>% 
  replace_nas()

#Gera tipologias contratos
print("Gerando tipologias de contratos...")
tipologias_contrato <- gera_tipologia_contrato(tipologias_merge, contratos_processados, contratos)

#Gera tipologias finais
print("Gerando tipologias gerais...")
tipologias_final_contratos_gerais <- tipologias_merge %>% 
  dplyr::left_join(tipologias_contrato, by = c("cd_u_gestora", "nu_contrato", "nu_cpfcnpj", "data_inicio")) %>% 
  dplyr::select(id_contrato, dplyr::everything())

source_code_string <- paste(readr::read_file(here::here("scripts/gera_tipologias.R")),
                            readr::read_file(here::here("R/carrega_gabarito_contratos.R")),
                            readr::read_file(here::here("R/DAO.R")),
                            readr::read_file(here::here("R/process_contratos.R")),
                            readr::read_file(here::here("R/process_licitacoes.R")),
                            readr::read_file(here::here("R/process_propostas.R")),
                            readr::read_file(here::here("R/tipologias.R")),
                            readr::read_file(here::here("R/utils.R")))

hash_source_code <- digest::digest(source_code_string, algo="md5", serialize=F)

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

readr::write_csv(tipologias_final_contratos_gerais, 
                 dplyr::if_else(vigentes,
                                paste("data/features/tipologias_contratos_vigentes_", 
                                      gsub("[[:space:]]", "_", Sys.time()), ".csv", sep = ""),
                                paste("data/features/tipologias_contratos_gerais_", 
                                      gsub("[[:space:]]", "_", Sys.time()), ".csv", sep = "")))

readr::write_csv(features, 
                 dplyr::if_else(vigentes,
                                paste("data/features/features_vigentes_", 
                                      gsub("[[:space:]]", "_", Sys.time()), ".csv", sep = ""),
                                paste("data/features/features_gerais_", 
                                      gsub("[[:space:]]", "_", Sys.time()), ".csv", sep = "")))

#Compactando código gerador 
zip(paste("data/source_code/",hash_source_code, ".zip", sep = ""), c("R", "scripts"))

DBI::dbDisconnect(al_db_con)