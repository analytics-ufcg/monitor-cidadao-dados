library(magrittr)

source(here::here("R/tradutor/interface.R"))
source(here::here("utils/join_utils.R"))

.HELP <- "Rscript transform_mc_data.R"

#Instala pacote mcTransformador
devtools::document()

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
#empenhos_df <- get_empenhos()
pagamentos_df <- get_pagamentos()
convenios_df <- get_convenios()
fornecedores_df <- get_fornecedores()
participantes_df <- get_participantes()
contratos_mutados_df <- get_contratos_mutados()

#Transforma tabelas
licitacoes_transformadas <- licitacoes_df %>% mcTransformador::process_licitacao() %>%
 join_licitacoes_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_licitacoes_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df)

contratos_transformados <- contratos_df %>% mcTransformador::process_contrato() %>%
  join_contratos_licitacao(licitacoes_transformadas) %>%
  join_contratos_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_contratos_fornecedores(fornecedores_df)

municipios_transformados <- municipios_df %>% mcTransformador::process_municipio()

participantes_transformados <- participantes_df %>% mcTransformador::process_participante() %>%
 join_participantes_licitacao(licitacoes_transformadas) %>%
  join_participantes_fornecedores (fornecedores_df)

pagamentos_transformados <- pagamentos_df %>% mcTransformador::process_pagamento()

contratos_mutados_transformados <- contratos_mutados_df %>% mcTransformador::process_contrato_mutado() %>%
  join_contratos_mutados_contratos(contratos_transformados)
  

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
#readr::write_csv(empenhos_df, here::here("data/empenhos.csv"))
#readr::write_csv(aditivos_df, here::here("data/aditivos.csv"))
readr::write_csv(pagamentos_transformados, here::here("data/pagamentos.csv"))
readr::write_csv(convenios_df, here::here("data/convenios.csv"))
readr::write_csv(municipios_transformados, here::here("data/municipios.csv"))
readr::write_csv(fornecedores_df, here::here("data/fornecedores.csv"))
readr::write_csv(participantes_transformados, here::here("data/participantes.csv"))
readr::write_csv(contratos_mutados_transformados, here::here("data/contratos_mutados1.csv"))