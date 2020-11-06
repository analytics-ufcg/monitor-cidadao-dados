message("")
message(" ------------------------------------------")
message("    INICIANDO SCRIPT - FETCH DADOS CONTRATOS/LICITACOES 2020   ")
message(" ------------------------------------------")
message("")

source(here::here("R/setup/constants.R"))
source(here::here("R/tramita_pb_data_2020.R"))

.HELP <- "Rscript scripts/fetch_tramita_pb_2020_data.R"

contratos_pb_2020 <- fetch_contratos_2020(TRAMITA_PB_DATA_CONTRATOS_2020)
readr::write_csv(contratos_pb_2020, path="./data/contratos_pb_2020.csv")

licitacoes_pb_2020 <- fetch_licitacoes_2020(TRAMITA_PB_DATA_LICITACOES_2020)
readr::write_csv(licitacoes_pb_2020, path="./data/licitacoes_pb_2020.csv")
