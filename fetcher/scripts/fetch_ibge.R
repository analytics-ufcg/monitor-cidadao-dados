source(here::here("R/setup/constants.R"))
source(here::here("R/ibge.R"))

.HELP <- "Rscript scripts/fetch_ibge.R"

codigo_localidades_ibge <- fetch_distritos_ibge(DADOS_DISTRITOS_IBGE)
readr::write_csv(codigo_localidades_ibge, path="./data/codigo_localidades_ibge.csv")
