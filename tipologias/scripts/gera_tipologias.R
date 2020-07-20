library(magrittr)

source(here::here("R/setup/constants.R"))
source(here::here("R/DAO.R"))
source(here::here("R/process_contratos.R"))

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
  
#Processa dados
contratos_processados <- contratos %>% process_contratos()
contratos_by_cnpj <- contratos_processados %>% count_contratos_by_cnpj()

readr::write_csv(licitacoes, here::here("./data/licitacoes.csv"))
readr::write_csv(contratos, here::here("./data/contratos.csv"))
readr::write_csv(contratos_by_cnpj, here::here("./data/contratos_by_cnpj.csv"))





DBI::dbDisconnect(al_db_con)