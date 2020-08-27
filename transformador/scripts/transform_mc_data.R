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
aditivos_df <- get_aditivos()
convenios_df <- get_convenios()
fornecedores_df <- get_fornecedores()
participantes_df <- get_participantes()
estorno_pagamento_df <- get_estorno_pagamento()
propostas_df <- get_propostas()
contratos_mutados_df <- get_contratos_mutados()

#Transforma tabelas
licitacoes_transformadas <- licitacoes_df %>% mcTransformador::process_licitacao() %>%
  join_licitacoes_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_licitacoes_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df)

#contratos_transformados <- contratos_df %>% mcTransformador::process_contrato() %>%
  join_contratos_licitacao(licitacoes_transformadas) %>%
  join_contratos_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_contratos_fornecedores(fornecedores_df)

#municipios_transformados <- municipios_df %>% mcTransformador::process_municipio()

participantes_transformados <- participantes_df %>% mcTransformador::process_participante() %>%
  join_participantes_licitacao(licitacoes_transformadas) %>%
  join_participantes_fornecedores (fornecedores_df)

propostas_transformadas <- propostas_df %>% mcTransformador::process_proposta() %>%
  join_propostas_licitacao(licitacoes_transformadas)  %>%
  join_propostas_participantes(participantes_transformados)

estorno_pagamento_transformado <- estorno_pagamento_df %>% mcTransformador::process_estorno_pagamento()


#Recupera dados de empenhos e pagamentos pelo codigo da unidade gestora
for (cd_u_gestora in codigo_unidade_gestora_df$cd_u_gestora) {
  print(sprintf('[%s] empenhos da unidade gestora = %s', Sys.time(), cd_u_gestora))

  # Verificar se o arquivo existe
  input_dir_emp = sprintf("../fetcher/data/empenhos/empenhos_%s.csv", cd_u_gestora)
  if (!file.exists(input_dir_emp) || file.size(input_dir_emp) == 0){next}

  empenhos_df <- get_empenhos_by_unidade_gestora(cd_u_gestora)

  empenhos_transformados <- empenhos_df %>% mcTransformador::process_empenho() %>%
    join_empenhos_licitacao(licitacoes_transformadas)

  # Cria a pasta de saída caso ela não exista
  output_dir_emp = 'data/empenhos/'
  if (!dir.exists(output_dir_emp)){
    dir.create(output_dir_emp)
  }

  readr::write_csv(empenhos_transformados, here::here(sprintf("./data/empenhos/empenhos_%s.csv", cd_u_gestora)))

  print(sprintf('[%s] pagamentos da unidade gestora = %s', Sys.time(), cd_u_gestora))

  # Verificar se o arquivo existe
  input_dir_pag = sprintf("../fetcher/data/pagamentos/pagamentos_%s.csv", cd_u_gestora)
  if (!file.exists(input_dir_pag) || file.size(input_dir_pag) == 0){next}

  pagamentos_df <- get_pagamentos_by_unidade_gestora(cd_u_gestora)
  pagamentos_transformados <- pagamentos_df %>% mcTransformador::process_pagamento() %>%
    join_pagamentos_empenhos(empenhos_transformados)

  # Cria a pasta de saída caso ela não exista
  output_dir_pag = 'data/pagamentos/'
  if (!dir.exists(output_dir_pag)){
    dir.create(output_dir_pag)
  }

  readr::write_csv(pagamentos_transformados, here::here(sprintf("./data/pagamentos/pagamentos_%s.csv", cd_u_gestora)))

  rm(empenhos_df) # remove o dataframe 'empenhos'
  rm(empenhos_transformados)
  rm(pagamentos_df) # remove o dataframe 'pagamentos'
  rm(pagamentos_transformados)
  gc() # permite que o R retorne memória pro sistema operacional
}


#contratos_mutados_transformados <- contratos_mutados_df %>% mcTransformador::process_contrato_mutado() %>%
  join_contratos_mutados_contratos(contratos_transformados) %>%
  dplyr::filter(!is.na(id_contrato)) %>% #Remove as linhas que contém o id_contrato=NA.
  dplyr::filter(!duplicated(id_contrato,data_alteracao)) #Remove as linhas que são repetidas.

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
readr::write_csv(aditivos_df, here::here("data/aditivos.csv"))
readr::write_csv(estorno_pagamento_transformado, here::here("data/estorno_pagamento.csv"))
readr::write_csv(convenios_df, here::here("data/convenios.csv"))
readr::write_csv(municipios_transformados, here::here("data/municipios.csv"))
readr::write_csv(fornecedores_df, here::here("data/fornecedores.csv"))
readr::write_csv(participantes_transformados, here::here("data/participantes.csv"))
readr::write_csv(contratos_mutados_transformados, here::here("data/contratos_mutados.csv"))
readr::write_csv(propostas_transformadas, here::here("data/propostas.csv"))
