# No caso dos dados vindos do Sagres (2017 e 2019), estes já estão em formato tabular,
# portanto, apenas uniformizamos o nome de suas colunas.

#' @title Traduz dado recebido para dataset
#' @param licitacoes_raw Dados brutos das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname translate_licitacoes
#' @examples
#' licitacoes_dt <- translate_licitacoes(licitacoes_raw)
translate_licitacoes <- function(licitacoes_raw) {
  licitacoes_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(de_obs = stringr::str_replace(de_obs, "\uFFFD", ""))
}

#' @title Traduz dado recebido para dataset
#' @param tipo_objeto_licitacao_raw Dados brutos do tipo dos objetos das licitações
#' @return Dataframe contendo informações sobre o tipo dos objetos das licitações
#' @rdname translate_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao_dt <- translate_tipo_objeto_licitacao(tipo_objeto_licitacao_raw)
translate_tipo_objeto_licitacao <- function(tipo_objeto_licitacao_raw) {
  tipo_objeto_licitacao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param tipo_modalidade_licitacao_raw Dados brutos do tipo das modalidades das licitações
#' @return Dataframe contendo informações sobre o tipo das modalidades das licitações
#' @rdname translate_tipo_modalidade_licitacao
#' @examples
#' tipo_modalidade_licitacao_dt <- translate_tipo_modalidade_licitacao(tipo_modalidade_licitacao_raw)
translate_tipo_modalidade_licitacao <- function(tipo_modalidade_licitacao_raw) {
  tipo_modalidade_licitacao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param regime_execucao_raw Dados brutos do regime de execução
#' @return Dataframe contendo informações sobre o regime de execução
#' @rdname translate_regime_execucao
#' @examples
#' regime_execucao_dt <- translate_regime_execucao(regime_execucao_raw)
translate_regime_execucao <- function(regime_execucao_raw) {
  regime_execucao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_unidade_gestora_raw Dados brutos do codigo da unidade gestora
#' @return Dataframe contendo informações sobre o codigo da unidade gestora
#' @rdname translate_codigo_unidade_gestora
#' @examples
#' codigo_unidade_gestora_dt <- translate_codigo_unidade_gestora(codigo_unidade_gestora_raw)
translate_codigo_unidade_gestora <- function(codigo_unidade_gestora_raw) {
  codigo_unidade_gestora_raw %<>% janitor::clean_names() %>%
  dplyr::rename(cd_u_gestora = cd_ugestora)
}

#' @title Traduz dado recebido para dataset
#' @param codigo_funcao_raw Dados brutos dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname translate_codigo_funcao
#' @examples
#' codigo_funcao_dt <- translate_codigo_funcao(codigo_funcao_raw)
translate_codigo_funcao <- function(codigo_funcao_raw) {
  codigo_funcao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param contratos_raw Dados brutos dos contratos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname translate_contratos
#' @examples
#' contratos_dt <- translate_contratos(contratos_raw)
translate_contratos <- function(contratos_raw) {
  contratos_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(de_obs = stringr::str_replace(de_obs, "\uFFFD", "")) %>%
    dplyr::mutate(nu_contrato = stringr::str_replace(nu_contrato, "\uFFFD", ""))
}

#' @title Traduz dado recebido para dataset
#' @param codigo_subfuncao_raw Dados brutos dos códigos de subfunções
#' @return Dataframe contendo informações sobre os códigos de subfunções
#' @rdname translate_codigo_subfuncao
#' @examples
#' codigo_subfuncao_dt <- translate_codigo_subfuncao(codigo_subfuncao_raw)
translate_codigo_subfuncao <- function(codigo_subfuncao_raw) {
  codigo_subfuncao_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_elemento_despesa_raw Dados brutos dos códigos de elementos de despesas
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname translate_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa_dt <- translate_codigo_elemento_despesa(codigo_elemento_despesa_raw)
translate_codigo_elemento_despesa <- function(codigo_elemento_despesa_raw) {
  codigo_elemento_despesa_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_subelemento_raw Dados brutos dos códigos de subelementos
#' @return Dataframe contendo informações sobre os códigos de subelementos
#' @rdname translate_codigo_subelemento
#' @examples
#' codigo_subelemento_dt <- translate_codigo_subelemento(codigo_subelemento_raw)
translate_codigo_subelemento <- function(codigo_subelemento_raw) {
  codigo_subelemento_raw %<>% janitor::clean_names()
}

#' @param empenhos_raw Dados brutos dos empenhos
#' @return Dataframe contendo informações sobre empenhos
#' @rdname translate_empenhos
#' @examples
#' empenhos_dt <- translate_empenhos(translate_empenhos_raw)
translate_empenhos <- function(empenhos_raw) {
  empenhos_raw %<>% janitor::clean_names()
}

#' @param aditivos_raw Dados brutos dos aditivos
#' @return Dataframe contendo informações sobre aditivos
#' @rdname translate_aditivos
#' @examples
#' aditivos_dt <- translate_aditivos(translate_aditivos_raw)
translate_aditivos <- function(aditivos_raw) {
  aditivos_raw %<>% janitor::clean_names()
}

#' @param pagamentos_raw Dados brutos dos pagamentos
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname translate_pagamentos
#' @examples
#' pagamentos_dt <- translate_pagamentos(translate_pagamentos_raw)
translate_pagamentos <- function(pagamentos_raw) {
  pagamentos_raw %<>% janitor::clean_names() %>%
    dplyr::mutate_at(dplyr::vars(cd_unid_orcamentaria, nu_empenho,
                                nu_parcela, nu_parcela, tp_lancamento,
                                dt_pagamento, cd_conta, nu_cheque_pag,
                                nu_deb_aut, cd_banco_rec, nu_conta_rec,
                                tp_fonte_recursos, dt_mes_ano, cd_banco,
                                cd_agencia, tp_conta_bancaria),
                                function(x){gsub("[^[:alnum:][:blank:]?&/\\-]", "", x)})
}

#' @param convenios_raw Dados brutos dos Convênios
#' @return Dataframe contendo informações sobre Convênios
#' @rdname translate_convenios
#' @examples
#' convenios_dt <- translate_convenios(translate_convenios_raw)
translate_convenios <- function(convenios_raw) {
  convenios_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param codigo_municipio_raw Dados brutos dos municípios
#' @return Dataframe contendo informações sobre os municípios
#' @rdname translate_codigo_municipio
#' @examples
#' codigo_municipio_dt <- translate_codigo_municipio(codigo_municipio_raw)
translate_codigo_municipio <- function(codigo_municipio_raw) {
  codigo_municipio_raw %<>% janitor::clean_names()
}

#' @param participantes_raw Dados brutos dos participantes
#' @return Dataframe contendo informações sobre os participantes
#' @rdname translate_participantes
#' @examples
#' participantes_dt <- translate_participantes(participantes_raw)
translate_participantes <- function(participantes_raw) {
  participantes_raw %<>% janitor::clean_names()
}

#' @param fornecedores_raw Dados brutos dos fornecedores
#' @return Dataframe contendo informações sobre os fornecedores
#' @rdname translate_fornecedores
#' @examples
#' fornecedores_dt <- translate_fornecedores(translate_fornecedores_raw)
translate_fornecedores <- function(fornecedores_raw) {
  fornecedores_raw %<>% janitor::clean_names()
}

#' @param contratos_mutados_raw Dados brutos dos contratos mutados
#' @return Dataframe contendo informações sobre os fornecedores
#' @rdname translate_contratos_mutados
#' @examples
#' contratos_mutados_dt <- translate_contratos_mutados(contratos_mutados_raw)
translate_contratos_mutados <- function(contratos_mutados_raw){
  contratos_mutados_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(data_atualização = "24-07-2020") %>%
    dplyr::rename(cd_u_gestora = cd_ugestora) %>%
    dplyr::rename(de_u_gestora = de_ugestora) %>%
    dplyr::rename(nu_licitacao = numero_licitacao) %>%
    dplyr::rename(nu_cpfcnpj = cpf_cnpj) %>%
    dplyr::rename(nu_contrato = numero_contrato) %>%
    dplyr::select(-id_contrato) %>%
    dplyr::mutate(nu_licitacao = gsub("/", "", nu_licitacao))
}

#' @param propostas_raw Dados brutos das propostas
#' @return Dataframe contendo informações sobre as propostas
#' @rdname translate_propostas
#' @examples
#' propostas_dt <- translate_propostas(propostas_raw)
translate_propostas <- function(propostas_raw) {
  propostas_raw %<>% janitor::clean_names()
}

#' @title Traduz dado recebido para dataset
#' @param estorno_pagamento_raw Dados brutos dos estornos de pagamentos
#' @return Dataframe contendo informações sobre os estornos de pagamentos
#' @rdname translate_estorno_pagamento
#' @examples
#' estorno_pagamento_dt <- translate_estorno_pagamento(estorno_pagamento_raw)
translate_estorno_pagamento <- function(estorno_pagamento_raw) {
  estorno_pagamento_raw %<>% janitor::clean_names() %>%
    dplyr::mutate(de_motivo_estorno = gsub("[^[:alnum:][:blank:]?&/\\-]", "", de_motivo_estorno))
}


#' @param localidades_ibge_raw Dados brutos dos distritos do IBGE
#' @return Dataframe contendo informações sobre os distritos
#' @rdname translate_distritos_ibge
#' @examples
#' distritos_ibge_dt <- translate_distritos_ibge(distrito_ibge_raw)
translate_codigo_localidades_ibge <- function(localidades_ibge_raw){
    localidades_ibge_raw %<>% janitor::clean_names() %>%
    dplyr::mutate_at(dplyr::vars(uf,	nome_uf, mesorregiao_geografica,
                                nome_mesorregiao,	microrregiao_geografica, nome_microrregiao,
                                municipio, codigo_municipio_completo,	nome_municipio),
                               function(x){gsub("[^[:alnum:][:blank:]?&/\\-]", "", x)})
}

#' @param licitacoes_tramita_raw Dados brutos das licitações contidas no Tramita
#' @return Dataframe contendo informações sobre as licitações contidas no Tramita
#' @rdname translate_licitacoes_tramita
#' @examples
#' licitacoes_tramita_df <- translate_licitacoes_tramita(licitacoes_tramita_raw)
translate_licitacoes_tramita <- function(licitacoes_tramita_raw){
    licitacoes_tramita_raw %<>% janitor::clean_names() %>%
     dplyr::rename(cd_u_gestora = cod_unidade_gestora) %>%
     dplyr::rename(nu_licitacao = numero_licitacao) %>%
     dplyr::rename(vl_licitacao = valor_estimado) %>%
     dplyr::rename(dt_homologacao = data_homologacao) %>%
     dplyr::mutate(nu_licitacao = gsub("/", "", nu_licitacao)) %>%
     dplyr::rename(de_tipo_licitacao = modalidade_licitacao) %>%
     dplyr::rename(de_tipo_objeto = tipo_objeto)
     
}





