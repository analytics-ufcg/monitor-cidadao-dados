library(magrittr)

source(here::here("R/tradutor/interface.R"))
source(here::here("utils/join_utils.R"))

.HELP <- "Rscript transform_mc_data.R"

#Instala pacote mcTransformador
devtools::document()

#--------------------------------
# RECUPERA AS TABELAS DO SAGRES-PB (ORDEM ALFABÉTICA)
#--------------------------------
aditivos_df <- get_aditivos()
codigo_unidade_gestora_df <- get_codigo_unidade_gestora()
codigo_funcao_df <- get_codigo_funcao()
contratos_df <- get_contratos()
contratos_tramita_df <- get_contratos_tramita()
codigo_subfuncao_df <- get_codigo_subfuncao()
codigo_elemento_despesa_df <- get_codigo_elemento_despesa()
codigo_subelemento_df <- get_codigo_subelemento()
convenios_df <- get_convenios()
contratos_mutados_df <- get_contratos_mutados()
codigo_localidades_ibge_df <- get_codigo_localidades_ibge()
estorno_pagamento_df <- get_estorno_pagamento()
fornecedores_df <- get_fornecedores()
licitacoes_df <- get_licitacoes()
licitacoes_tramita_df <- get_licitacoes_tramita()
municipios_df <- get_codigo_municipio()
participantes_df <- get_participantes()
propostas_df <- get_propostas()
regime_execucao_df <- get_regime_execucao()
tipo_objeto_licitacao_df <- get_tipo_objeto_licitacao()
tipo_modalidade_licitacao_df <- get_tipo_modalidade_licitacao()

#--------------------------------
# RECUPERA AS TABELA DO IBGE
#--------------------------------
codigo_localidades_ibge_df <- get_codigo_localidades_ibge()

#--------------------------------
# TRANSFORMA TABELAS
#--------------------------------

codigo_localidades_ibge_transformados <- codigo_localidades_ibge_df  %>%
   mcTransformador::process_codigo_localidades_ibge()

municipios_sagres_df <- municipios_df %>% mcTransformador::process_municipio()

licitacoes_transformadas <- licitacoes_df %>% mcTransformador::process_licitacao() %>%
  join_licitacoes_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_licitacoes_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df) %>%
  join_licitacoes_municipios_sagres(municipios_sagres_df) %>%
  join_licitacoes_localidades_ibge(codigo_localidades_ibge_transformados)

contratos_transformados <- contratos_df %>% mcTransformador::process_contrato() %>%
  join_contratos_licitacao(licitacoes_transformadas) %>%
  join_contratos_codigo_unidade_gestora(codigo_unidade_gestora_df) %>%
  join_contratos_fornecedores(fornecedores_df) %>%
  join_contratos_municipios_sagres(municipios_sagres_df) %>%
  join_contratos_localidades_ibge(codigo_localidades_ibge_transformados)

participantes_transformados <- participantes_df %>% mcTransformador::process_participante() %>%
  join_participantes_licitacao(licitacoes_transformadas) %>%
  join_participantes_fornecedores (fornecedores_df)

propostas_transformadas <- propostas_df %>% mcTransformador::process_proposta() %>%
  join_propostas_licitacao(licitacoes_transformadas)  %>%
  join_propostas_participantes(participantes_transformados)

estorno_pagamento_transformado <- estorno_pagamento_df %>% mcTransformador::process_estorno_pagamento()

licitacoes_tramita_transformadas <- licitacoes_tramita_df %>% 
   join_licitacoes_tramita_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df) %>%
   join_licitacoes_tramita_tipo_objeto_licitacao(tipo_objeto_licitacao_df) %>%
   dplyr::group_by(cd_u_gestora, nu_licitacao, dt_homologacao, vl_licitacao, de_obs, de_ugestora, de_tipo_licitacao, tp_licitacao, tp_objeto, dt_mes_ano, registro_cge, dt_ano, tp_regime_execucao) %>% 
   dplyr::summarise(nu_propostas = dplyr::n()) %>%
   mcTransformador::process_licitacao_tramita() %>%
   join_licitacoes_tramita_municipios_sagres(municipios_sagres_df) %>%
   join_licitacoes_tramita_localidades_ibge(codigo_localidades_ibge_transformados) %>%
   dplyr::select(id_licitacao, cd_u_gestora, dt_ano, nu_licitacao, tp_licitacao, dt_homologacao, nu_propostas, vl_licitacao, tp_objeto, de_obs, dt_mes_ano, registro_cge, tp_regime_execucao, de_ugestora, de_tipo_licitacao,	cd_ibge, uf, mesorregiao_geografica, microrregiao_geografica) %>%
   dplyr::distinct(id_licitacao, .keep_all=TRUE)



contratos_tramita_transformados <- contratos_tramita_df %>%
   join_contratos_tramita_tipo_modalidade_licitacao(tipo_modalidade_licitacao_df) %>% 
   mcTransformador::process_contrato_tramita() %>%
   join_contratos_tramita_licitacoes_tramita(licitacoes_tramita_transformadas) %>%
   join_contratos_tramita_municipios_sagres(municipios_sagres_df) %>%
   join_contratos_tramita_localidades_ibge(codigo_localidades_ibge_transformados) %>%
   dplyr::select(id_contrato, id_licitacao, cd_u_gestora, dt_ano, nu_contrato, dt_assinatura, pr_vigencia, nu_cpfcnpj, nu_licitacao, tp_licitacao, vl_total_contrato, de_obs, dt_mes_ano, registro_cge, cd_siafi, dt_recebimento, foto, planilha, ordem_servico, language, de_ugestora, no_fornecedor, cd_ibge,	uf,	mesorregiao_geografica,	microrregiao_geografica) %>%
   dplyr::distinct(id_contrato, .keep_all=TRUE)

#   # Verificar se o arquivo existe
#   input_dir_pag = sprintf("../fetcher/data/pagamentos/pagamentos_%s.csv", cd_u_gestora)
#   if (!file.exists(input_dir_pag) || file.size(input_dir_pag) == 0){next}

#   pagamentos_df <- get_pagamentos_by_unidade_gestora(cd_u_gestora)
#   pagamentos_transformados <- pagamentos_df %>% mcTransformador::process_pagamento() %>%
#     join_pagamentos_empenhos(empenhos_transformados)

#   # Cria a pasta de saída caso ela não exista
#   output_dir_pag = 'data/pagamentos/'
#   if (!dir.exists(output_dir_pag)){
#     dir.create(output_dir_pag)
#   }

#   readr::write_csv(pagamentos_transformados, here::here(sprintf("./data/pagamentos/pagamentos_%s.csv", cd_u_gestora)))

#   rm(empenhos_df) # remove o dataframe 'empenhos'
#   rm(empenhos_transformados)
#   rm(pagamentos_df) # remove o dataframe 'pagamentos'
#   rm(pagamentos_transformados)
#   gc() # permite que o R retorne memória pro sistema operacional
# }


contratos_mutados_transformados <- contratos_mutados_df %>% mcTransformador::process_contrato_mutado() %>%
  join_contratos_mutados_contratos(contratos_transformados) %>%
  dplyr::filter(!is.na(id_contrato)) %>% #Remove as linhas que contém o id_contrato=NA.
  dplyr::filter(!duplicated(id_contrato,data_alteracao)) #Remove as linhas que são repetidas.


# Cria a pasta de saída para armazenamento das licitações, caso ela não exista
output_dir_pag = 'data/licitacoes/'
if (!dir.exists(output_dir_pag)){
   dir.create(output_dir_pag)
}


# Cria a pasta de saída para armazenamento dos contratos, caso ela não exista
output_dir_pag = 'data/contratos/'
if (!dir.exists(output_dir_pag)){
   dir.create(output_dir_pag)
}

#Salva tabelas localmente
readr::write_csv(licitacoes_transformadas, here::here("data/licitacoes/licitacoes.csv"))
readr::write_csv(tipo_objeto_licitacao_df, here::here("data/tipo_objeto_licitacao.csv"))
readr::write_csv(tipo_modalidade_licitacao_df, here::here("data/tipo_modalidade_licitacao.csv"))
readr::write_csv(regime_execucao_df, here::here("data/regime_execucao.csv"))
readr::write_csv(codigo_unidade_gestora_df, here::here("data/codigo_unidade_gestora.csv"))
readr::write_csv(codigo_funcao_df, here::here("data/codigo_funcao.csv"))
readr::write_csv(contratos_transformados, here::here("data/contratos/contratos.csv"))
readr::write_csv(codigo_subfuncao_df, here::here("data/codigo_subfuncao.csv"))
readr::write_csv(codigo_elemento_despesa_df, here::here("data/codigo_elemento_despesa.csv"))
readr::write_csv(codigo_subelemento_df, here::here("data/codigo_subelemento.csv"))
readr::write_csv(aditivos_df, here::here("data/aditivos.csv"))
readr::write_csv(estorno_pagamento_transformado, here::here("data/estorno_pagamento.csv"))
readr::write_csv(convenios_df, here::here("data/convenios.csv"))
readr::write_csv(municipios_sagres_df, here::here("data/municipios_sagres.csv"))
readr::write_csv(codigo_localidades_ibge_transformados, here::here("data/localidades_ibge.csv"))
readr::write_csv(fornecedores_df, here::here("data/fornecedores.csv"))
readr::write_csv(participantes_transformados, here::here("data/participantes.csv"))
readr::write_csv(contratos_mutados_transformados, here::here("data/contratos_mutados.csv"))
readr::write_csv(propostas_transformadas, here::here("data/propostas.csv"))
readr::write_csv(licitacoes_tramita_transformadas, here::here("data/licitacoes/licitacoes_tramita.csv"))
readr::write_csv(contratos_tramita_transformados, here::here("data/contratos/contratos_tramita.csv"))