#' @title Realiza o join dos contratos com o dataframe das licitações
#' @param df_contratos dataframe com os contratos
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações dos contratos com os ids das licitações
#' @rdname join_contratos_licitacao
#' @examples
#' join_contrato_licitacao_dt <- join_contratos_licitacao(df_contratos, df_licitacoes)
#'
join_contratos_licitacao <- function(df_contratos, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                     tp_licitacao, id_licitacao)

  df_contratos %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_contrato, id_licitacao, cd_municipio, dplyr::everything())
}

#' @title Realiza o join dos empenhos com o dataframe das licitações
#' @param empenhos_df dataframe com os empenhos
#' @param licitacoes_df dataframe com as licitações
#' @return Dataframe contendo informações dos empenhos com os ids das licitações
#' @rdname join_empenhos_licitacao
#' @examples
#' join_empenhos_licitacao_dt <- join_empenhos_licitacao(df_empenhos, df_licitacoes)
#'
join_empenhos_licitacao <- function(df_empenhos, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                   tp_licitacao, id_licitacao, cd_ibge)

  df_empenhos %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_empenho, id_licitacao, dplyr::everything()) %>%
    dplyr::select(-c(cd_municipio))
}

#' @title Realiza o join dos contratos com os códigos das unidades gestoras
#' @param df_contratos dataframe com os contratos
#' @param df_codigo_unidade_gestora dataframe com os códigos das unidades gestoras
#' @return Dataframe contendo informações dos contratos com nomes das unidades gestoras
#' @rdname join_contratos_codigo_unidade_gestora
#' @examples
#' join_contratos_codigo_unidade_gestora_dt <- join_contratos_codigo_unidade_gestora(
#'          df_contratos, df_codigo_unidade_gestora)
#'
join_contratos_codigo_unidade_gestora <- function(df_contratos, df_codigo_unidade_gestora) {
  df_codigo_unidade_gestora %<>% dplyr::select(cd_u_gestora, de_ugestora)

  df_contratos %<>% dplyr::left_join(df_codigo_unidade_gestora) %>%
    dplyr::select(id_contrato, id_licitacao, cd_municipio, dplyr::everything())
}


#' @title Realiza o join das licitações com os códigos das unidades gestoras
#' @param df_licitacoes dataframe com as licitações
#' @param df_codigo_unidade_gestora dataframe com os códigos das unidades gestoras
#' @return Dataframe contendo informações das licitações com nomes das unidades gestoras
#' @rdname join_licitações_codigo_unidade_gestora
#' @examples
#' join_licitacoes_codigo_unidade_gestora_dt <- join_licitacoes_codigo_unidade_gestora(
#'          df_licitacoes, df_codigo_unidade_gestora)
#'
join_licitacoes_codigo_unidade_gestora <- function(df_licitacoes, df_codigo_unidade_gestora){
  df_codigo_unidade_gestora %<>% dplyr::select(cd_u_gestora, de_ugestora)

  df_licitacoes %<>% dplyr::left_join(df_codigo_unidade_gestora) %>%
    dplyr::select(id_licitacao, cd_municipio, dplyr::everything())
}


#' @title Realiza o join dos contratos com os fornecedores
#' @param df_contratos dataframe com os contratos
#' @param df_fornecedores dataframe com os fornecedores
#' @return Dataframe contendo informações dos contratos com os nomes dos fornecedores
#' @rdname join_contratos_fornecedores
#' @examples
#' join_contratos_fornecedores_dt <- join_contratos_fornecedores(
#'          df_contratos, df_fornecedores)
#'
join_contratos_fornecedores <- function(df_contratos, df_fornecedores) {
  df_fornecedores %<>% dplyr::select(nu_cpfcnpj, no_fornecedor) %>%
    dplyr::distinct(nu_cpfcnpj, .keep_all=TRUE)

  df_contratos %<>% dplyr::left_join(df_fornecedores) %>%
    dplyr::select(id_contrato, dplyr::everything())
}


#' @title Realiza o join das licitações com os tipos de modalidade de licitações
#' @param df_licitacoes dataframe com as licitações
#' @param df_tipo_modalidade_licitacao dataframe com os tipos de modalidade de licitações
#' @return Dataframe contendo informações das licitações com nome da modalidade de licitação
#' @rdname join_licitacoes_tipo_modalidade_licitacao
#' @examples
#' join_licitacoes_tipo_modalidade_licitacao_dt <- join_licitacoes_tipo_modalidade_licitacao(
#'          df_licitacoes, df_tipo_modalidade_licitacao)
#'
join_licitacoes_tipo_modalidade_licitacao <- function(df_licitacoes, df_tipo_modalidade_licitacao) {
  df_tipo_modalidade_licitacao %<>% dplyr::select(tp_licitacao, de_tipo_licitacao)

  df_licitacoes %<>% dplyr::left_join(df_tipo_modalidade_licitacao) %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Realiza o join das licitações com os municipios do SAGRES
#' @param df_licitacoes dataframe com as licitações
#' @param df_municipios_sagres dataframe com os id dos municipios do SAGRES
#' @return Dataframe contendo informações das licitações com o id do IBGE
#' @rdname join_licitacoes_municipios_sagres
#' @examples
#' join_licitacoes_municipios_sagres_dt <- join_licitacoes_municipios_sagres(
#'          df_licitacoes, df_municipios_sagres)
#'
join_licitacoes_municipios_sagres <- function(df_licitacoes, df_municipios_sagres) {
  df_licitacoes %<>% dplyr::left_join(df_municipios_sagres) %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Realiza o join das licitações com as localidades do IBGE
#' @param df_licitacoes dataframe com as licitações
#' @param df_localidades_ibge dataframe com as localidades cadastradas no IBGE
#' @return Dataframe contendo informações das licitações com o ids do IBGE
#' @rdname join_licitacoes_localidades_ibge
#' @examples
#' join_licitacoes_localidades_ibge_dt <- join_licitacoes_localidades_ibge(
#'          df_licitacoes, df_localidades_ibge)
#'
join_licitacoes_localidades_ibge <- function(df_licitacoes, df_localidades_ibge) {
  df_localidades_ibge %<>% dplyr::select(uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_licitacoes %<>% dplyr::left_join(df_localidades_ibge) %>%
    dplyr::select(id_licitacao, dplyr::everything()) %>%
    dplyr::select(-c(cd_municipio))
}

#' @title Realiza o join dos contratos com os municipios do SAGRES
#' @param df_contratos dataframe com os contratos
#' @param df_municipios_sagres dataframe com os id dos municipios do SAGRES
#' @return Dataframe contendo informações dos contratos com os ids do IBGE
#' @rdname join_contratos_municipios_sagres
#' @examples
#' join_contratos_municipios_sagres_dt <- join_contratos_municipios_sagres(
#'          df_contratos, df_municipios_sagres)
#'
join_contratos_municipios_sagres <- function(df_contratos, df_municipios_sagres) {
  df_contratos %<>% dplyr::left_join(df_municipios_sagres) %>%
    dplyr::select(id_contrato, dplyr::everything())
}

#' @title Realiza o join dos contratos com as localidades do IBGE
#' @param df_contratos dataframe com os contratos
#' @param df_localidades_ibge dataframe com as localidades cadastradas no IBGE
#' @return Dataframe contendo informações dos contratos com o ids do IBGE
#' @rdname join_contratos_localidades_ibge
#' @examples
#' join_contratos_localidades_ibge_dt <- join_contratos_localidades_ibge(
#'          df_contratos, df_localidades_ibge)
#'
join_contratos_localidades_ibge <- function(df_contratos, df_localidades_ibge) {
  df_localidades_ibge %<>% dplyr::select(uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_contratos %<>% dplyr::left_join(df_localidades_ibge) %>%
    dplyr::select(id_contrato, dplyr::everything()) %>%
    dplyr::select(-c(cd_municipio))
}

#' @title Realiza o join dos participantes com o dataframe das licitações
#' @param df_participantes dataframe com os participantes
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações dos participantes com os ids das licitações
#' @rdname join_participantes_licitacao
#' @examples
#' join_participantes_licitacao_dt <- join_participante_licitacao(df_participantes, df_licitacoes)
#'
join_participantes_licitacao <- function(df_participantes, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                   tp_licitacao, id_licitacao)

  df_participantes %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_participante, id_licitacao, dplyr::everything())
}


#' @title Realiza o join dos participantes com os fornecedores
#' @param df_participantes dataframe com os participantes
#' @param df_fornecedores dataframe com os fornecedores
#' @return Dataframe contendo informações dos participantes com os nomes dos fornecedores
#' @rdname join_participantes_fornecedores
#' @examples
#' join_participantes_fornecedores_dt <- join_participantes_fornecedores(
#'          df_participantes, df_fornecedores)
#'
join_participantes_fornecedores <- function(df_participantes, df_fornecedores) {
  df_fornecedores %<>% dplyr::select(nu_cpfcnpj, no_fornecedor) %>%
    dplyr::distinct(nu_cpfcnpj, .keep_all=TRUE)

  df_participantes %<>% dplyr::left_join(df_fornecedores) %>%
    dplyr::select(id_participante, dplyr::everything())
}

#' @title Realiza o join das propostas com o dataframe das licitações
#' @param df_propostas dataframe com as propostas
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações das propostas com os ids das licitações
#' @rdname join_propostas_licitacao
#' @examples
#' join_propostas_licitacao_dt <- join_propostas_licitacao(df_propostas, df_licitacoes)
#'
join_propostas_licitacao <- function(df_propostas, df_licitacoes) {
  df_licitacoes %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                     tp_licitacao, id_licitacao)

  df_propostas %<>% dplyr::left_join(df_licitacoes) %>%
    dplyr::select(id_proposta, id_licitacao, dplyr::everything())
}

#' @title Realiza o join dos contratos mutados com os contratos
#' @param df_contratos dataframe com os contratos
#' @param df_contratos_mutados dataframe com os contratos mutados
#' @return Dataframe contendo informações dos contratos mutados com o id do contrato
#' @rdname join_contratos_mutados_contratos
#' @examples
#' join_contratos_mutados_contratos_dt <- join_contratos_mutados_contratos(
#'          df_contratos, df_contratos_mutados)
#'
join_contratos_mutados_contratos <- function(df_contratos_mutados, df_contratos) {
 df_contratos %<>% dplyr::select(id_contrato, nu_contrato, cd_u_gestora, nu_licitacao, nu_cpfcnpj)

  df_contratos_mutados %<>% dplyr::left_join(df_contratos) %>%
    dplyr::select(id_contrato, dplyr::everything())
}

#' @title Realiza o join das propostas com o dataframe dos participantes
#' @param df_propostas dataframe com as propostas
#' @param df_licitacoes dataframe com os participantes
#' @return Dataframe contendo informações das propostas com os ids dos participantes
#' @rdname join_propostas_participantes
#' @examples
#' join_propostas_participantes_dt <- join_propostas_licitacao(df_propostas, df_licitacoes)
#'
join_propostas_participantes <- function(df_propostas, df_participantes) {
  df_participantes %<>% dplyr::select(nu_licitacao, dt_ano,
                                      cd_u_gestora, tp_licitacao, nu_cpfcnpj,
                                      id_participante)

  df_propostas %<>% dplyr::left_join(df_participantes) %>%
    dplyr::select(id_proposta, id_licitacao, id_participante, dplyr::everything())
}

#' @title Realiza o join dos pagamentos com os dataframes dos empenhos
#' @param pagamentos_df dataframe com os pagamentos
#' @param empenhos_df dataframe com os empenhos
#' @return Dataframe contendo informações dos pagamentos com os ids dos empenhos
#' @rdname join_pagamentos_empenhos
#' @examples
#' join_pagamentos_empenhos_dt <- join_pagamentos_empenhos(df_pagamentos, df_empenhos)
#'
join_pagamentos_empenhos <- function(df_pagamentos, df_empenhos) {
  df_empenhos %<>% dplyr::select(nu_empenho, cd_unid_orcamentaria,
                                 dt_ano, cd_u_gestora, id_empenho,
                                 id_licitacao, id_contrato)

  df_pagamentos %<>% dplyr::left_join(df_empenhos) %>%
    dplyr::select(id_pagamento, id_empenho, id_licitacao, id_contrato, dplyr::everything())
}


