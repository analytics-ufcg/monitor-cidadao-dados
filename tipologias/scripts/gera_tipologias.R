library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/DAO.R"))
source(here::here("R/process_contratos.R"))
source(here::here("R/tipologias.R"))
source(here::here("R/utils.R"))
source(here::here("R/carrega_gabarito_contratos.R"))



.HELP <- "Rscript gera_tipologias.R"

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
contratos <- carrega_contratos(al_db_con) 
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

readr::write_csv(tipologias_final_contratos_gerais, paste("data/tipologias_contratos_gerais_", Sys.Date(), ".csv"))


DBI::dbDisconnect(al_db_con)