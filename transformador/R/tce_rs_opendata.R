library(magrittr)

source(here::here("R/utils.R"))

#' @title Gera um identificador único para cada contrato do RS
#' @param contratos_df Dataframe contendo informações sobre os contratos
#' @return Dataframe contendo informações sobre os contratos e seus ids
#' @rdname generate_contrato_id
#' @examples
#' contratos_tce_rs_dt <- generate_contrato_tce_rs_id(contrato_df)
generate_contrato_tce_rs_id <- function(contratos_tce_rs_dt) {
  contratos_tce_rs_dt %<>% .generate_hash_id(c("cd_u_gestora", "nu_cpfcnpj", "ano_licitacao","nu_licitacao",
                                        "cd_tipo_modalidade", "nu_contrato", "dt_ano",
                                        "tp_instrumento"),
                                       "id_contrato") %>%
    dplyr::select(id_contrato, dplyr::everything())
}

#' @title Gera um identificador único para cada licitação do RS
#' @param licitacoes_df Dataframe contendo informações sobre as licitações
#' @return Dataframe contendo informações sobre as licitações e seus ids
#' @rdname generate_licitacao_tce_rs_id
#' @examples
#' licitacoes_tce_rs_dt <- generate_licitacao_tce_rs_id(licitacoes_tce_rs_dt)
generate_licitacao_tce_rs_id <- function(licitacoes_tce_rs_dt) {
  licitacoes_tce_rs_dt %<>% .generate_hash_id(c("cd_u_gestora", "nu_licitacao", "dt_ano", "cd_tipo_modalidade"),
                                      "id_licitacao") %>%
    dplyr::select(id_licitacao, dplyr::everything())
}


#' @title Processa dataframe de contratos
#' @description Manipula a tabela pra forma que será utilizada no banco
#' @param contratos_df Dataframe contendo informações dos contratos
#' @return Dataframe contendo informações dos contratos processados
process_contrato_tce_rs <- function(contratos_df) {
    contratos_df %<>% generate_contrato_tce_rs_id() %>%
    dplyr::mutate(language = 'portuguese')
}

#' @title Processa dataframe de licitações
#' @description Manipula a tabela pra forma que será utilizada no banco
#' @param licitacoes_df Dataframe contendo informações das licitações
#' @return Dataframe contendo informações das licitações processados
process_licitacao_tce_rs <- function(licitacoes_df) {
  licitacoes_df %<>% generate_licitacao_tce_rs_id()
}

#' @title Processa dataframe de licitações
#' @description Manipula a tabela para se adequar aos outros estados
#' @param licitacoes_df Dataframe contendo informações das licitações
#' @return Dataframe contendo informações das licitações processados
format_licitacao_tce_rs <- function(licitacoes_transformadas_rs_df) {
  colunas_licitacoes <- c("id_licitacao", "cd_u_gestora", "dt_ano", "nu_licitacao", "tp_licitacao", "dt_homologacao",
                         "nu_propostas", "vl_licitacao", "tp_objeto", "de_obs", "dt_mes_ano", "registro_cge", "tp_regime_execucao",
                         "de_ugestora", "de_tipo_licitacao", "cd_ibge", "uf", "mesorregiao_geografica", "microrregiao_geografica")

  licitacoes_rs_formatadas <- fncols(licitacoes_transformadas_rs_df, colunas_licitacoes) %>%
    dplyr::select(colunas_licitacoes)
}

#' @title Processa dataframe dos contratos
#' @description Manipula a tabela para se adequar aos outros estados
#' @param contratos_df Dataframe contendo informações dos contratos
#' @return Dataframe contendo informações dos contratos processados
format_contrato_tce_rs <- function(contratos_transformados_rs_df) {
  colunas_contratos <- c("id_contrato", "id_licitacao", "cd_u_gestora", "dt_ano", "nu_contrato",
                         "dt_assinatura", "pr_vigencia", "nu_cpfcnpj", "nu_licitacao", "tp_licitacao",
                         "vl_total_contrato", "de_obs", "dt_mes_ano", "registro_cge", "cd_siafi", "dt_recebimento",
                         "foto",	"planilha", "ordem_servico", "language", "de_ugestora", "no_fornecedor", "cd_ibge", "uf",
                         "mesorregiao_geografica", "microrregiao_geografica")

  contratos_rs_formatados <-fncols(contratos_transformados_rs_df, colunas_contratos) %>%
    dplyr::select(colunas_contratos)
}

#' @title Processa dataframe dos empenhos
#' @description Manipula a tabela para se adequar aos outros estados
#' @param empenhos_pagamentos_transformados_rs_df Dataframe contendo informações de empenhos e pagamentos do RS
#' @return Dataframe contendo informações dos empenhos
format_empenhos_tce_rs <- function(empenhos_pagamentos_transformados_rs_df) {
  colunas_empenhos <- c( "id_empenho", "id_licitacao", "id_contrato","cd_u_gestora","dt_ano","cd_unid_orcamentaria","cd_funcao","cd_subfuncao",
                         "cd_programa","cd_acao","cd_classificacao", "cd_cat_economica", "cd_nat_despesa", "cd_modalidade","cd_elemento",
                         "cd_sub_elemento","tp_licitacao","nu_licitacao", "nu_empenho", "tp_empenho","dt_empenho","vl_empenho","cd_credor",
                         "no_credor","tp_credor","de_historico1","de_historico2","de_historico","tp_meta","nu_obra", "dt_mes_ano",
                         "dt_mes_ano_referencia","tp_fonte_recursos","nu_cpf", "cd_sub_elemento_2","cd_ibge")

  empenhos_rs_formatados <-fncols(empenhos_pagamentos_transformados_rs_df, colunas_empenhos) %>%
    dplyr::select(colunas_empenhos)  %>%
    dplyr::distinct(id_empenho, .keep_all = TRUE)
}

#' @title Processa dataframe de pagamentos
#' @description Manipula a tabela para se adequar aos outros estados
#' @param empenhos_pagamentos_transformados_rs_df Dataframe contendo informações de empenhos e pagamentos do RS
#' @return Dataframe contendo informações dos pagamentos
format_pagamentos_tce_rs <- function(empenhos_pagamentos_transformados_rs_df) {
  colunas_pagamentos <- c("id_pagamento","id_empenho","id_licitacao","id_contrato",
                          "cd_u_gestora","dt_ano","cd_unid_orcamentaria","nu_empenho",
                          "nu_parcela","tp_lancamento","vl_pagamento","dt_pagamento",
                          "cd_conta","nu_cheque_pag","nu_deb_aut","cd_banco_rec",
                          "cd_agencia_rec","nu_conta_rec","tp_fonte_recursos","dt_mes_ano",
                          "cd_banco","cd_agencia","tp_conta_bancaria")

  pagamentos_rs_formatados <-fncols(empenhos_pagamentos_transformados_rs_df, colunas_pagamentos) %>%
    dplyr::select(colunas_pagamentos) %>%
    dplyr::filter(!is.na(vl_pagamento))

}

#' @title Processa dataframe de empenhos e pagamentos do RS
#' @description Manipula a tabela para a adição de identificadores e para adequação
#'              de colunas.
#' @param empenhos_pagamento_ce_rs Dataframe contendo informações de empenhos e pagamentos do RS
#' @return Dataframe contendo informações dos empenhos e pagamentos
process_empenhos_pagamento_tce_rs <- function(empenhos_pagamento_tce_rs, file_empenho) {
  empenhos_pagamento_tce_rs %<>% generate_empenhos_pagamento_tce_rs_id(file_empenho)
}

#' @title Gera um identificador único para empenhos e licitações do RS
#' @param empenhos_pagamento_tce_rs Dataframe contendo informações sobre empenhos e licitações
#' @return Dataframe contendo informações sobre empenhos e licitações do RS e seus ids
#' @rdname generate_empenhos_pagamento_tce_rs_id
#' @examples
#' empenhos_pagamento_tce_rs <- generate_empenhos_pagamento_tce_rs_id(empenhos_pagamento_tce_rs)
generate_empenhos_pagamento_tce_rs_id <- function(empenhos_pagamento_tce_rs, file_empenho) {
  empenhos_pagamento_tce_rs$index <- seq.int(nrow(empenhos_pagamento_tce_rs))
  empenhos_pagamento_tce_rs$file <- file_empenho

  chave_empenhos <- c("ano_recebimento", "mes_recebimento", "cd_u_gestora", "cd_orgao_orcamentario", "nome_orgao_orcamentario",
                      "cd_unidade_orcamentaria", "nome_unidade_orcamentaria", "tp_unidade",
                      "dt_empenho", "ano_empenho", "ano_operacao", "nu_empenho", "cd_credor", "nu_cpfcnpj",
                      "ano_licitacao", "nu_licitacao", "cd_tipo_modalidade", "file")

  empenhos_pagamento_tce_rs %<>% .generate_hash_id(chave_empenhos, "id_empenho")
  empenhos_pagamento_tce_rs %<>% .generate_hash_id(c("index", "file"), "id_pagamento")
}



