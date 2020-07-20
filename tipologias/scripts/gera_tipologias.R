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
licitacoes <- carrega_licitacoes(al_db_con)
contratos <- carrega_contratos(al_db_con) 
propostas <- carrega_propostas_licitacao(al_db_con)

#Processa dados
contratos_processados <- contratos %>% process_contratos()
contratos_by_cnpj <- contratos_processados %>% count_contratos_by_cnpj() %>% 
  dplyr::mutate(nu_cpfcnpj = gsub ("\\D", "", nu_cpfcnpj))
licitacoes_vencedoras <- contratos_processados %>% get_vencedores_by_contratos()
propostas_licitacoes <- propostas %>% dplyr::inner_join(licitacoes)

#Carrega dados dependentes
participantes <- carrega_participantes(al_db_con, contratos_by_cnpj$nu_cpfcnpj)


#Gera tipologias
tipologias_licitacao <- gera_tipologia_licitacao(licitacoes, contratos_processados, contratos_by_cnpj, licitacoes_vencedoras, participantes)
tipologias_proposta <- gera_tipologia_proposta(propostas_licitacoes, contratos_by_cnpj)

#Merge tipologias e adiciona gabarito
tipologias_merge <- merge_tipologias(contratos_processados, tipologias_licitacao, tipologias_proposta) %>% 
  carrega_gabarito_tramita() %>% 
  replace_nas()

#Gera tipologias contratos
tipologias_contrato <- gera_tipologia_contrato(tipologias_merge, contratos_processados, contratos)

#Gera tipologias finais
tipologias_final_contratos_gerais <- tipologias_merge %>% 
  dplyr::left_join(tipologias_contrato, by = c("cd_u_gestora", "nu_contrato", "nu_cpfcnpj", "data_inicio"))

readr::write_csv(tipologias_final_contratos_gerais, "data/tipologias_final_contratos_gerais.csv")


DBI::dbDisconnect(al_db_con)