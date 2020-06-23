library(magrittr)

source(here::here("R/tradutor/interface.R"))
source(here::here("utils/join_utils.R"))

.HELP <- "Rscript transform_mc_data.R"

#Instala pacote mcTransformador
devtools::install()

#Busca tabelas traduzidas
licitacoes_df <- get_licitacoes()
tipo_objeto_licitacao_df <- get_tipo_objeto_licitacao()
tipo_modalidade_licitacao_df <- get_tipo_modalidade_licitacao()
regime_execucao_df <- get_regime_execucao()
codigo_unidade_gestora_df <- get_codigo_unidade_gestora()
codigo_funcao_df <- get_codigo_funcao()
contratos_df <- get_contratos()
codigo_subfuncao_df <- get_codigo_subfuncao()
codigo_elemento_despesa_df <- get_codigo_elemento_despesa()
codigo_subelemento_df <- get_codigo_subelemento()
municipios_df <- get_codigo_municipio()

#Transforma tabelas
licitacoes_transformadas <- licitacoes_df %>% mcTransformador::process_licitacao()
contratos_transformados <- contratos_df %>% mcTransformador::process_contrato() %>%
  join_contratos_licitacao(licitacoes_transformadas)
municipios_transformados <- municipios_df %>% mcTransformador::process_municipio()

#Salva tabelas localmente
readr::write_csv(licitacoes_transformadas, here::here("data/licitacoes.csv"))
readr::write_csv(tipo_objeto_licitacao_df, here::here("data/tipo_objeto_licitacao.csv"))
readr::write_csv(tipo_modalidade_licitacao_df, here::here("data/tipo_modalidade_licitacao.csv"))
readr::write_csv(regime_execucao_df, here::here("data/regime_execucao.csv"))
readr::write_csv(codigo_unidade_gestora_df, here::here("data/codigo_unidade_gestora.csv"))
readr::write_csv(codigo_funcao_df, here::here("data/codigo_funcao.csv"))
readr::write_csv(contratos_transformados, here::here("data/contratos.csv"))
readr::write_csv(codigo_subfuncao_df, here::here("data/codigo_subfuncao.csv"))
readr::write_csv(codigo_elemento_despesa_df, here::here("data/codigo_elemento_despesa.csv"))
readr::write_csv(codigo_subelemento_df, here::here("data/codigo_subelemento.csv"))
readr::write_csv(municipios_transformados, here::here("data/municipios.csv"))
