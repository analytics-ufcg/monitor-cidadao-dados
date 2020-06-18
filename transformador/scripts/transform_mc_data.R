library(magrittr)

source(here::here("R/tradutor/interface.R"))

.HELP <- "Rscript transform_mc_data.R"

devtools::install()

licitacoes_df <- get_licitacoes()
licitacoes_transformadas <- licitacoes_df %>% mcTransformador::generate_licitacao_id()
readr::write_csv(licitacoes_transformadas, here::here("data/licitacoes.csv"))


tipo_objeto_licitacao_df <- get_tipo_objeto_licitacao()
readr::write_csv(tipo_objeto_licitacao_df, here::here("data/tipo_objeto_licitacao.csv"))

codigo_funcao_df <- get_codigo_funcao()
readr::write_csv(codigo_funcao_df, here::here("data/codigo_funcao.csv"))

codigo_subfuncao_df <- get_codigo_subfuncao()
readr::write_csv(codigo_subfuncao_df, here::here("data/codigo_subfuncao.csv"))

codigo_elemento_despesa_df <- get_codigo_elemento_despesa()
readr::write_csv(codigo_elemento_despesa_df, here::here("data/codigo_elemento_despesa.csv"))

codigo_subelemento_df <- get_codigo_subelemento()
readr::write_csv(codigo_subelemento_df, here::here("data/codigo_subelemento.csv"))
