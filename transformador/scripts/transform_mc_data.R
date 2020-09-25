library(magrittr)

source(here::here("R/tradutor/interface.R"))
source(here::here("utils/join_utils.R"))

.HELP <- "Rscript transform_mc_data.R"

#Instala pacote mcTransformador
devtools::document()


print("Iniciando Transformador --------------------------------")
print("\n")

print("Carregamento de dados: ---------------------------------")
print("\n")

print("> ----- Carregando Aditivos")
aditivos_df <- get_aditivos()

print("> ----- Carregando Contratos")
contratos_df <- get_contratos()

print("> ----- Carregando Contratos Mutados/TRAMITA")
contratos_mutados_df <- get_contratos_mutados()

print("> ----- Carregando Código Unidade Gestora")
codigo_unidade_gestora_df <- get_codigo_unidade_gestora()

print("> ----- Carregando Código Função")
codigo_funcao_df <- get_codigo_funcao()

print("> ----- Carregando Código Subfunção")
codigo_subfuncao_df <- get_codigo_subfuncao()

print("> ----- Carregando Código Elemento Despesa")
codigo_elemento_despesa_df <- get_codigo_elemento_despesa()

print("> ----- Carregando Código Subelemento")
codigo_subelemento_df <- get_codigo_subelemento()

print("> ----- Carregando Convênios")
convenios_df <- get_convenios()

print("> ----- Carregando Estorno Pagamentos")
estorno_pagamento_df <- get_estorno_pagamento()

print("> ----- Carregando Fornecedores")
fornecedores_df <- get_fornecedores()

print("> ----- Carregando Licitações")
licitacoes_df <- get_licitacoes()

print("> ----- Carregando Código Município")
municipios_df <- get_codigo_municipio()

print("> ----- Carregando Participantes")
participantes_df <- get_participantes()

print("> ----- Carregando Propostas")
propostas_df <- get_propostas()

print("> ----- Carregando Regime Execução")
regime_execucao_df <- get_regime_execucao()

print("> ----- Carregando Tipo Objeto Licitação")
tipo_objeto_licitacao_df <- get_tipo_objeto_licitacao()

print("> ----- Carregando Tipo Modalidade Licitação")
tipo_modalidade_licitacao_df <- get_tipo_modalidade_licitacao()


print("Carregamento de dados FINALIZADO -----------------------")
print("\n")
print("Iniciando tranformação: --------------------------------")
print("\n")


print("> ----- Transformando: Licitação")
licitacoes_transformadas <- licitacoes_df %>% mcTransformador::process_licitacao() %>%
  join_licitacoes_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_licitacoes_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df)

print("> ----- Transformando: Contratos")
contratos_transformados <- contratos_df %>% mcTransformador::process_contrato() %>%
  join_contratos_licitacao(licitacoes_transformadas) %>%
  join_contratos_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_contratos_fornecedores(fornecedores_df)

print("> ----- Transformando: Contratos Mutados")
contratos_mutados_transformados <- contratos_mutados_df %>% mcTransformador::process_contrato_mutado() %>%
  join_contratos_mutados_contratos(contratos_transformados) %>%
  dplyr::filter(!is.na(id_contrato)) %>% #Remove as linhas que contém o id_contrato=NA.
  dplyr::filter(!duplicated(id_contrato,data_alteracao)) #Remove as linhas que são repetidas.

print("> ----- Transformando: Municípios")
municipios_transformados <- municipios_df %>% mcTransformador::process_municipio()

print("> ----- Transformando: Participantes")
participantes_transformados <- participantes_df %>% mcTransformador::process_participante() %>%
  join_participantes_licitacao(licitacoes_transformadas) %>%
  join_participantes_fornecedores (fornecedores_df)

print("> ----- Transformando: Propostas")
propostas_transformadas <- propostas_df %>% mcTransformador::process_proposta() %>%
  join_propostas_licitacao(licitacoes_transformadas)  %>%
  join_propostas_participantes(participantes_transformados)

print("> ----- Transformando: Estorno Pagamento")
estorno_pagamento_transformado <- estorno_pagamento_df %>% mcTransformador::process_estorno_pagamento()


print("> ----- Adicionando a chave de Contratos em Empenhos")
# Adiciona a chave de contratos a tabela de empenhos
## Agrupamento de empenhos por contrato e por licitação
### Caso I: Onde 1 credor possui apenas 1 único contrato de uma mesma licitação
contratos_por_licitacao <- contratos_transformados %>%
  dplyr::group_by(id_licitacao, nu_cpfcnpj) %>%
  dplyr::summarise(amount = dplyr::n()) %>%
  dplyr::filter(amount == 1) %>%
  na.omit() %>%
  dplyr::left_join(contratos_transformados,
                  by = c("id_licitacao", "nu_cpfcnpj")) %>%
  dplyr::select(id_licitacao, id_contrato, nu_cpfcnpj) %>%
  dplyr::ungroup()


# Caso II: Onde 1 credor possui mais de um contrato de uma mesma licitação
contratos_lici_corner_cases <- contratos_transformados %>%
  dplyr::group_by(id_licitacao, nu_cpfcnpj) %>%
  dplyr::summarise(amount = dplyr::n()) %>%
  dplyr::filter(amount > 1)


print("> ----- Transformando: Empenhos e Pagamentos")
#Recupera dados de empenhos e pagamentos pelo codigo da unidade gestora
for (cd_u_gestora in codigo_unidade_gestora_df$cd_u_gestora) {
  print(sprintf('[%s] empenhos da unidade gestora = %s', Sys.time(), cd_u_gestora))

  # Verificar se o arquivo existe
  input_dir_emp = sprintf("../fetcher/data/empenhos/empenhos_%s.csv", cd_u_gestora)
  if (!file.exists(input_dir_emp) || file.size(input_dir_emp) == 0){next}

  empenhos_df <- get_empenhos_by_unidade_gestora(cd_u_gestora)

  empenhos_transformados <- empenhos_df %>% mcTransformador::process_empenho() %>%
    join_empenhos_licitacao(licitacoes_transformadas) %>%
    dplyr::left_join(contratos_por_licitacao,
                     by = c("id_licitacao" = "id_licitacao", "cd_credor" = "nu_cpfcnpj")) %>% # Adiciona o número do contrato no Empenho
    dplyr::select(id_empenho, id_licitacao, id_contrato, dplyr::everything())


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


#Salva tabelas localmente
print("> ----- Escrevendo em arquivo: Licitações")
readr::write_csv(licitacoes_transformadas, here::here("data/licitacoes.csv"))

print("> ----- Escrevendo em arquivo: Tipo Objeto Licitação")
readr::write_csv(tipo_objeto_licitacao_df, here::here("data/tipo_objeto_licitacao.csv"))

print("> ----- Escrevendo em arquivo: Tipo Modalidade Licitação")
readr::write_csv(tipo_modalidade_licitacao_df, here::here("data/tipo_modalidade_licitacao.csv"))

print("> ----- Escrevendo em arquivo: Regime Execução")
readr::write_csv(regime_execucao_df, here::here("data/regime_execucao.csv"))

print("> ----- Escrevendo em arquivo: Código Unidade Gestora")
readr::write_csv(codigo_unidade_gestora_df, here::here("data/codigo_unidade_gestora.csv"))

print("> ----- Escrevendo em arquivo: Código Função")
readr::write_csv(codigo_funcao_df, here::here("data/codigo_funcao.csv"))

print("> ----- Escrevendo em arquivo: Contratos")
readr::write_csv(contratos_transformados, here::here("data/contratos.csv"))

print("> ----- Escrevendo em arquivo: Contratos Mutados")
readr::write_csv(contratos_mutados_transformados, here::here("data/contratos_mutados.csv"))

print("> ----- Escrevendo em arquivo: Código Subfunção")
readr::write_csv(codigo_subfuncao_df, here::here("data/codigo_subfuncao.csv"))

print("> ----- Escrevendo em arquivo: Código Elemento Despesa")
readr::write_csv(codigo_elemento_despesa_df, here::here("data/codigo_elemento_despesa.csv"))

print("> ----- Escrevendo em arquivo: Código Subelemento")
readr::write_csv(codigo_subelemento_df, here::here("data/codigo_subelemento.csv"))

print("> ----- Escrevendo em arquivo: Aditivos")
readr::write_csv(aditivos_df, here::here("data/aditivos.csv"))

print("> ----- Escrevendo em arquivo: Estorno Pagamento")
readr::write_csv(estorno_pagamento_transformado, here::here("data/estorno_pagamento.csv"))

print("> ----- Escrevendo em arquivo: Convênios")
readr::write_csv(convenios_df, here::here("data/convenios.csv"))

print("> ----- Escrevendo em arquivo: Municípios")
readr::write_csv(municipios_transformados, here::here("data/municipios.csv"))

print("> ----- Escrevendo em arquivo: Fornecedores")
readr::write_csv(fornecedores_df, here::here("data/fornecedores.csv"))

print("> ----- Escrevendo em arquivo: Participantes")
readr::write_csv(participantes_transformados, here::here("data/participantes.csv"))

print("> ----- Escrevendo em arquivo: Propostas")
readr::write_csv(propostas_transformadas, here::here("data/propostas.csv"))

print("\n")
print("Transformador FINALIZADO -------------------------------")
