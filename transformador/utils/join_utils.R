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

#' @title Realiza o join dos empenhos com o dataframe das licitações do tramita
#' @param empenhos_df dataframe com os empenhos
#' @param licitacoes_df dataframe com as licitações do tramita
#' @return Dataframe contendo informações dos empenhos com os ids das licitações
#' @rdname join_empenhos_licitacao_tramita
#' @examples
#' join_empenhos_licitacao_tramita_dt <- join_empenhos_licitacao_tramita(df_empenhos, df_licitacoes_tramita)
#'
join_empenhos_licitacao_tramita <- function(df_empenhos, df_licitacoes_tramita) {
  df_licitacoes_tramita %<>% dplyr::select(cd_u_gestora, dt_ano, nu_licitacao,
                                   tp_licitacao, id_licitacao, cd_ibge)
  df_empenhos %<>% dplyr::left_join(df_licitacoes_tramita) %>%
    dplyr::select(id_empenho, id_licitacao, dplyr::everything())
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

#' @title Realiza o join dos órgãos do RS com as localidades do IBGE
#' @param df_orgaos_rs dataframe com os órgãos
#' @param df_localidades_ibge dataframe com as localidades cadastradas no IBGE
#' @return Dataframe contendo informações dos órgãos com o ids do IBGE
#' @rdname join_licitacoes_localidades_ibge
#' @examples
#' join_orgaos_rs_localidades_ibge_dt <- join_orgaos_rs_localidades_ibge(
#'          df_orgaos_rs, df_localidades_ibge)
#'
join_orgaos_rs_localidades_ibge <- function(df_orgaos_rs, df_localidades_ibge) {
  df_localidades_ibge %<>% dplyr::select(uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_orgaos_rs %<>% dplyr::left_join(df_localidades_ibge) %>%
    dplyr::select(cd_u_gestora, dplyr::everything())
}

#' @title Realiza o join das licitações do RS com os seus tipos
#' @param df_licitacoes_rs dataframe com as licitações
#' @param df_modalidade_licitacoes_rs dataframe com as modalidades das licitações
#' @return Dataframe contendo informações das licitações com os tipos
#' @rdname join_licitacoes_rs_tipos
#' @examples
#' join_licitacoes_rs_tipos_dt <- join_licitacoes_rs_tipos(
#'          df_licitacoes_rs, df_tipos_licitacoes_rs)
#'
join_licitacoes_rs_modalidade <- function(df_licitacoes_rs, df_modalidade_licitacoes_rs) {
  df_licitacoes_rs %<>% dplyr::left_join(df_modalidade_licitacoes_rs) %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Realiza o join das licitações do RS com os seus órgãos
#' @param df_licitacoes_rs dataframe com as licitações
#' @param df_orgaos_rs dataframe com os órgãos
#' @return Dataframe contendo informações das licitações com os órgãos e localidades
#' @rdname join_licitacoes_rs_tipos
#' @examples
#' join_licitacoes_rs_orgaos_dt <- join_licitacoes_rs_orgaos(
#'          df_licitacoes_rs, df_orgaos_rs)
#'
join_licitacoes_rs_orgaos <- function(df_licitacoes_rs, df_orgaos_rs) {
  df_orgaos_rs %<>% dplyr::select(cd_u_gestora, uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_licitacoes_rs %<>% dplyr::left_join(df_orgaos_rs, by="cd_u_gestora") %>%
    dplyr::select(id_licitacao, dplyr::everything())
}


#' @title Realiza o join entre as tabelas de contratos e licitações
#' @param df_licitacoes_rs dataframe com as licitações
#' @param df_contratos_rs dataframe com os contratos
#' @return Dataframe contendo informações dos contratos e das licitações
#' @rdname join_contratos_rs_licitacoes
#' @examples
#' join_contratos_rs_licitacoes_dt <- join_contratos_rs_licitacoes(
#'          df_licitacoes_rs, df_orgaos_rs)
#'
join_contratos_rs_licitacoes <- function(df_contratos_rs, df_licitacoes_rs) {
  df_licitacoes_rs %<>% dplyr::select(id_licitacao, cd_u_gestora, nu_licitacao,
                                      cd_tipo_modalidade, tp_licitacao, uf, mesorregiao_geografica,
                                      microrregiao_geografica, cd_ibge)

  df_contratos_rs %<>% dplyr::left_join(df_licitacoes_rs) %>%
    dplyr::select(id_contrato, id_licitacao, dplyr::everything())
}

#' @title Realiza o join entre as tabelas de contratos e pessoas
#' @param df_contratos_rs dataframe com as contratos
#' @param df_pessoas_rs dataframe com as pessoas
#' @return Dataframe contendo informações dos contratos e das pessoas/fornecedores
#' @rdname join_contratos_rs_pessoas
#' @examples
#' join_contratos_rs_pessoas_dt <- join_contratos_rs_pessoas(
#'          df_contratos_rs, df_orgaos_rs)
#'
join_contratos_rs_pessoas <- function(df_contratos_rs, df_pessoas_rs) {
  df_pessoas_rs %<>% dplyr::select(nu_cpfcnpj, no_fornecedor) %>%
    dplyr::distinct(nu_cpfcnpj, .keep_all = TRUE)

  df_contratos_rs %<>% dplyr::left_join(df_pessoas_rs, by="nu_cpfcnpj") %>%
    dplyr::select(id_contrato, id_licitacao, dplyr::everything())
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

#' @title Realiza o join das licitações com os tipos de modalidade de licitações
#' @param df_licitacoes_tramita dataframe com as licitações
#' @param df_tipo_modalidade_licitacao dataframe com os tipos de modalidade de licitações
#' @return Dataframe contendo informações das licitações com nome da modalidade de licitação
#' @rdname join_licitacoes_tipo_modalidade_licitacao
#' @examples
#' join_licitacoes_tramita_tipo_modalidade_licitacao_dt <- join_licitacoes_tramita_tipo_modalidade_licitacao(
#'          df_licitacoes_tramita, df_tipo_modalidade_licitacao)
#'
join_licitacoes_tramita_tipo_modalidade_licitacao <- function(df_licitacoes_tramita, df_tipo_modalidade_licitacao) {
  df_tipo_modalidade_licitacao %<>% dplyr::select(tp_licitacao, de_tipo_licitacao)

  df_licitacoes_tramita %<>% dplyr::left_join(df_tipo_modalidade_licitacao) %>%
    dplyr::select(nu_licitacao, cd_u_gestora, dplyr::everything())
}


#' @title Realiza o join das licitações obtidas nos dados do tramita e os tipos de objeto das licitações
#' @param df_licitacoes_tramita dataframe com as licitações
#' @param df_tipo_objeto_licitacao dataframe com os tipos de objeto das licitações
#' @return Dataframe contendo informações das licitações com os tipos de objetos das licitações
#' @rdname join_licitacoes_tramita_tipo_objeto_licitacao
#' @examples
#' join_licitacoes_tramita_tipo_objeto_licitacao_dt <- join_licitacoes_tramita_tipo_modalidade_licitacao(
#'          df_licitacoes_tramita, df_tipo_modalidade_licitacao)
#'
join_licitacoes_tramita_tipo_objeto_licitacao <- function(df_licitacoes_tramita, df_tipo_objeto_licitacao) {
  df_tipo_objeto_licitacao %<>% dplyr::select(tp_objeto, de_tipo_objeto)

  df_licitacoes_tramita %<>% dplyr::left_join(df_tipo_objeto_licitacao) %>%
    dplyr::select(nu_licitacao, cd_u_gestora, dplyr::everything())
}

#' @title Realiza o join dos contratos com os tipos de modalidade de licitações
#' @param df_contratos_tramita dataframe com os contratos
#' @param df_tipo_modalidade_licitacao dataframe com os tipos de modalidade de licitações
#' @return Dataframe contendo informações dos contratos com o tipo da modalidade de licitação
#' @rdname join_contratos_tramita_tipo_modalidade_licitacao
#' @examples
#' join_contratos_tramita_tipo_modalidade_licitacao_dt <- join_contratos_tramita_tipo_modalidade_licitacao(
#'          df_contratos_tramita, df_tipo_modalidade_licitacao)
#'
join_contratos_tramita_tipo_modalidade_licitacao <- function(df_contratos_tramita, df_tipo_modalidade_licitacao) {
  df_tipo_modalidade_licitacao %<>% dplyr::select(tp_licitacao, de_tipo_licitacao)

  df_contratos_tramita %<>% dplyr::left_join(df_tipo_modalidade_licitacao) %>%
    dplyr::select(nu_licitacao, cd_u_gestora, nu_contrato, dplyr::everything())
}

#' @title Realiza o join dos contratos com o dataframe das licitações
#' @param df_contratos dataframe com os contratos
#' @param df_licitacoes dataframe com as licitações
#' @return Dataframe contendo informações dos contratos com os ids das licitações
#' @rdname join_contratos_licitacao
#' @examples
#' join_contrato_licitacao_dt <- join_contratos_licitacao(df_contratos, df_licitacoes)
#'
join_contratos_tramita_licitacoes_tramita <- function(df_contratos_tramita, df_licitacoes_tramita) {
  df_licitacoes_tramita %<>% dplyr::select(cd_u_gestora, nu_licitacao,
                                     tp_licitacao, id_licitacao)

  df_contratos_tramita %<>% dplyr::left_join(df_licitacoes_tramita) %>%
    dplyr::select(id_contrato, id_licitacao, cd_municipio, dplyr::everything())
}

#' @title Realiza o join das licitações contidas no TRAMITA com os municipios do SAGRES
#' @param df_licitacoes_tramita dataframe com as licitações
#' @param df_municipios_sagres dataframe com os id dos municipios do SAGRES
#' @return Dataframe contendo informações das licitações contidas no TRAMITA com o id do IBGE
#' @rdname join_licitacoes_tramita_municipios_sagres
#' @examples
#' join_licitacoes_tramita_municipios_sagres_dt <- join_licitacoes_tramita_municipios_sagres(
#'          df_licitacoes, df_municipios_sagres)
#'
join_licitacoes_tramita_municipios_sagres <- function(df_licitacoes_tramita, df_municipios_sagres) {
  df_licitacoes_tramita %<>% dplyr::left_join(df_municipios_sagres) %>%
    dplyr::select(id_licitacao, dplyr::everything())
}

#' @title Realiza o join das licitações do tamita com as localidades do IBGE
#' @param df_licitacoes_tramita dataframe com as licitações
#' @param df_localidades_ibge dataframe com as localidades cadastradas no IBGE
#' @return Dataframe contendo informações das licitações com o ids do IBGE
#' @rdname join_licitacoes_tramita_localidades_ibge
#' @examples
#' join_licitacoes_tramita_localidades_ibge_dt <- join_licitacoes_tramita_localidades_ibge(
#'          df_licitacoes_tramita, df_localidades_ibge)
#'
join_licitacoes_tramita_localidades_ibge <- function(df_licitacoes_tramita, df_localidades_ibge) {
  df_localidades_ibge %<>% dplyr::select(uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_licitacoes_tramita %<>% dplyr::left_join(df_localidades_ibge) %>%
    dplyr::select(id_licitacao, dplyr::everything()) %>%
    dplyr::select(-c(cd_municipio))
}

#' @title Realiza o join dos contratos do tamita com as contratos do Sagres
#' @param df_contratos_tramita dataframe com os contratos do tramita
#' @param df_contratos dataframe com os contratos do SAGRES
#' @return Dataframe contendo informações do contrato do Tramita e Sagres
#' @rdname join_contratos_tramita_contratos_sagres
#' @examples
#' join_contratos_tramita_contratos_sagres_dt <- join_contratos_tramita_contratos_sagres(
#'          df_contratos_tramita, df_contratos)
#'
join_contratos_tramita_contratos_sagres <- function(df_contratos, df_contratos_tramita) {
  df_contratos %<>% dplyr::bind_rows(dplyr::anti_join(df_contratos_tramita, df_contratos, by="id_licitacao")) 
}

#' @title Realiza o join das licitações do tamita com as licitações do Sagres
#' @param df_licitacoes_tramita dataframe com as licitações do tramita
#' @param df_licitacoes dataframe com as licitações do SAGRES
#' @return Dataframe contendo informações das licitações do Tramita e Sagres
#' @rdname join_licitacoes_tramita_licitacoes_sagres
#' @examples
#' join_licitacoes_tramita_licitacoes_sagres_dt <- join_licitacoes_tramita_licitacoes_sagres(
#'          df_licitacoes_tramita, df_licitacoes)
#'
join_licitacoes_tramita_licitacoes_sagres <- function(df_licitacoes, df_licitacoes_tramita) {
  df_licitacoes %<>% dplyr::bind_rows(dplyr::anti_join(df_licitacoes_tramita, df_licitacoes, by="id_licitacao")) 
}


#' @title Realiza o join dos contratos contidos no TRAMITA com os municipios do SAGRES
#' @param df_contratos_tramita dataframe com os contratos
#' @param df_municipios_sagres dataframe com os id dos municipios do SAGRES
#' @return Dataframe contendo informações dos contratos com os ids do IBGE
#' @rdname join_contratos_tramita_municipios_sagres
#' @examples
#' join_contratos_tramita_municipios_sagres_dt <- join_contratos_tramita_municipios_sagres(
#'          df_contratos_tramita, df_municipios_sagres)
#'
join_contratos_tramita_municipios_sagres <- function(df_contratos_tramita, df_municipios_sagres) {
  df_contratos_tramita %<>% dplyr::left_join(df_municipios_sagres) %>%
    dplyr::select(id_contrato, dplyr::everything())
}

#' @title Realiza o join dos contratos do tramita com as localidades do IBGE
#' @param df_contratos_tramita dataframe com os contratos
#' @param df_localidades_ibge dataframe com as localidades cadastradas no IBGE
#' @return Dataframe contendo informações dos contratos com o ids do IBGE
#' @rdname join_contratos_localidades_ibge
#' @examples
#' join_contratos_tramita_localidades_ibge_dt <- join_contratos_tramita_localidades_ibge(
#'          df_contratos_tramita, df_localidades_ibge)
#'
join_contratos_tramita_localidades_ibge <- function(df_contratos_tramita, df_localidades_ibge) {
  df_localidades_ibge %<>% dplyr::select(uf, mesorregiao_geografica, microrregiao_geografica, cd_ibge)

  df_contratos_tramita %<>% dplyr::left_join(df_localidades_ibge) %>%
    dplyr::select(id_contrato, dplyr::everything()) %>%
    dplyr::select(-c(cd_municipio))
}

