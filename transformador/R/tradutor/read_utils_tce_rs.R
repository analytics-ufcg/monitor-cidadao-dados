
#' @title Lê dataframe contendo informações dos contratos do RS
#' @return Dataframe contendo informações sobre contratos
#' @rdname read_contratos_tce_rs
#' @examples
#' contratos_tce_rs_dt <- read_contratos_tce_rs(ano)
read_contratos_tce_rs <- function(ano) {
  contratos_tce_rs_df <- readr::read_csv(here::here(sprintf("../fetcher/data/rs/contratos/%s/contrato.csv", ano)),
                                 col_types = list(
                                   .default = readr::col_character(),
                                   ANO_CONTRATO = readr::col_number(),
                                   ANO_PROCESSO = readr::col_number(),
                                   NR_DIAS_PRAZO = readr::col_number(),
                                   VL_CONTRATO = readr::col_double(),
                                   DT_INICIO_VIGENCIA = readr::col_date(),
                                   DT_FINAL_VIGENCIA = readr::col_date(),
                                   DT_ASSINATURA = readr::col_date()
                                 ))
}


#' @title Lê dataframe contendo informações dos órgãos do RS
#' @return Dataframe contendo informações sobre órgãos auditados
#' @rdname read_orgaos_tce_rs
#' @examples
#' read_orgaos_tce_rs_dt <- read_orgaos_tce_rs()
read_orgaos_tce_rs <- function() {
  orgaos_tce_rs_df <- readr::read_csv(here::here("../fetcher/data/rs/orgaos/ orgaos_auditados_rs.csv"),
                                         col_types = list(
                                           .default = readr::col_character()
                                         ))
}


#' @title Lê dataframe contendo informações das licitações do RS
#' @return Dataframe contendo informações sobre as licitações
#' @rdname read_licitacoes_tce_rs
#' @examples
#' licitacoes_tce_rs_dt <- read_licitacoes_tce_rs(ano)
read_licitacoes_tce_rs <- function(ano) {
  licitacoes_tce_rs_df <- readr::read_csv(here::here(sprintf("../fetcher/data/rs/licitacoes/%s/licitacao.csv", ano)),
                                         col_types = list(
                                           .default = readr::col_character(),
                                           ANO_LICITACAO = readr::col_number(),
                                           ANO_PROCESSO = readr::col_number(),
                                           ANO_COMISSAO = readr::col_number(),
                                           VL_LICITACAO = readr::col_double(),
                                           DT_ABERTURA = readr::col_date(),
                                           DT_HOMOLOGACAO = readr::col_date(),
                                           DT_ADJUDICACAO = readr::col_date()
                                         ))
}

#' @title Cria dataframe contendo informações das modalidades das licitações do RS
#' @return Dataframe contendo informações sobre as modalidades das licitações
#' @rdname read_modalidade_licitacoes_tce_rs
#' @examples
#' modalidade_licitacoes_tce_rs_dt <- read_modalidade_licitacoes_tce_rs()
read_modalidade_licitacoes_tce_rs <- function() {
  modalidade_licitacao <- data.frame(cd_tipo_modalidade = c("CPP", "CHP", "CPC", "CNC", "CNS", "CNV", "ESE", "EST",
                                                            "LEE", "LEI", "MAI", "PRE", "PRP", "PRD", "PDE", "PRI",
                                                            "RDE", "RDC", "RPO", "RIN", "TMP"),
                                     de_tipo_licitacao = c("Chamada Pública-PNAE:  Programa Nacional de Alimentação Escolar",
                                                                   "Chamamento Público", "Chamamento Público Credenciamento", "Concorrência",
                                                                   "Concurso", "Convite", "Lei 13.303/2016 Eletrônico", "Lei 13.303/2016 Presencial",
                                                                   "Leilão Eletrônico", "Leilão Presencial", "Manifestação de Interesse",
                                                                   "Pregão Eletrônico", "Pregão Presencial", "Processo de Dispensa",
                                                                   "Processo de Dispensa Eletrônica", "Processo de Inexigibilidade",
                                                                   "Regime Diferenciado de Contratação (Lei nº 12.462) - Eletrônico",
                                                                   "Regime Diferenciado de Contratação (Lei nº 12.462) - Presencial",
                                                                   "Registro de Preço de Outro Órgão", "Regras Internacionais", "Tomada de Preços"),
                                     stringsAsFactors = FALSE)

  return(modalidade_licitacao)
}



