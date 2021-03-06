source(here::here("R/cols_constants.R"))
source(here::here("R/utils.R"))

#' @title Busca licitações no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre as licitações
#' @rdname fetch_licitacoes
#' @examples
#' licitacoes <- fetch_licitacoes(sagres_con)
fetch_licitacoes <- function(sagres_con) {
  licitacoes <- tibble::tibble()
  tryCatch({
    licitacoes <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Licitacao;") %>%
      assert_dataframe_completo(COLNAMES_LICITACOES)
  },
  error = function(e) print(paste0("Erro ao buscar licitações no Banco Sagres (SQLServer): ", e))
  )

  return(licitacoes)
}

#' @title Busca codigos de funções no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname fetch_codigo_funcao
#' @examples
#' codigo_funcao <- fetch_codigo_funcao(sagres_con)
fetch_codigo_funcao <- function(sagres_con) {
  codigo_funcao <- tibble::tibble()
  tryCatch({
    codigo_funcao <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_Funcao;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_FUNCAO)
  },
  error = function(e) print(paste0("Erro ao buscar codigos de funcões no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_funcao)
}

#' @title Busca codigos de elementos de despesas no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname fetch_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres_con)
fetch_codigo_elemento_despesa <- function(sagres_con) {
  codigo_elemento_despesa <- tibble::tibble()
  tryCatch({
    codigo_elemento_despesa <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_ElementoDespesa;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_ELEMENTO_DESPESA)
  },
  error = function(e) print(paste0("Erro ao buscar codigos de elementos de despesas no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_elemento_despesa)
}

#' @title Busca tipos de objetos de licitações no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos dos objetos de licitação
#' @rdname fetch_tipo_objeto_licitacao
#' @examples
#' tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres_con)
fetch_tipo_objeto_licitacao <- function(sagres_con) {
  tipo_objeto_licitacao <- tibble::tibble()
  tryCatch({
    tipo_objeto_licitacao <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Tipo_Objeto_Licitacao;") %>%
      assert_dataframe_completo(COLNAMES_TIPO_OBJETO_LICITACAO)
  },
  error = function(e) print(paste0("Erro ao buscar tipo_objeto_licitacao no Banco Sagres (SQLServer): ", e))
  )

  return(tipo_objeto_licitacao)
}

#' @title Busca tipos de modalidade de licitações no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os tipos das modalidades de licitações
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' tipo_modalidade_licitacao <- fetch_tipo_modalidade_licitacao(sagres_con)
fetch_tipo_modalidade_licitacao <- function(sagres_con) {
  tipo_modalidade_licitacao <- tibble::tibble()
  tryCatch({
    tipo_modalidade_licitacao <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Tipo_Modalidade_Licitacao;") %>%
      assert_dataframe_completo(COLNAMES_TIPO_MODALIDADE_LICITACAO)
  },
  error = function(e) print(paste0("Erro ao buscar tipo_modalidade_licitacao no Banco Sagres (SQLServer): ", e))
  )

  return(tipo_modalidade_licitacao)
}

#' @title Busca regimes de execução no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre o regime de execução
#' @rdname fetch_modalidade_objeto_licitacao
#' @examples
#' regime_execucao <- fetch_regime_execucao(sagres_con)
fetch_regime_execucao <- function(sagres_con) {
  regime_execucao <- tibble::tibble()
  tryCatch({
    regime_execucao <- DBI::dbGetQuery(sagres_con, "SELECT * FROM RegimeExecucao;") %>%
      assert_dataframe_completo(COLNAMES_REGIME_EXECUCAO)
  },
  error = function(e) print(paste0("Erro ao buscar regime_execucao no Banco Sagres (SQLServer): ", e))
  )

  return(regime_execucao)
}

#' @title Busca contratos no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os contratos
#' @rdname fetch_contratos
#' @examples
#' contratos <- fetch_contratos(sagres_con)
fetch_contratos <- function(sagres_con) {
  contratos <- tibble::tibble()
  tryCatch({
    contratos <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Contratos;") %>%
      assert_dataframe_completo(COLNAMES_CONTRATOS)
  },
  error = function(e) print(paste0("Erro ao buscar contratos no Banco Sagres (SQLServer): ", e))
  )

  return(contratos)
}

#' @title Busca os códigos subfunção no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos subfunção
#' @rdname fetch_codigo_subfuncao
#' @examples
fetch_codigo_subfuncao <- function(sagres_con) {
  codigo_subfuncao <- tibble::tibble()
  tryCatch({
    codigo_subfuncao <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_Subfuncao;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_SUBFUNCAO)
  },
  error = function(e) print(paste0("Erro ao buscar código subfunção no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_subfuncao)
}

#' @title Busca os códigos sub-elementos no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos sub-elementos
#' @rdname fetch_codigo_subelemento
#' @examples
fetch_codigo_subelemento <- function(sagres_con) {
  codigo_subelemento <- tibble::tibble()
  tryCatch({
    codigo_subelemento <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_Subelemento;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_SUBELEMENTO)
  },
  error = function(e) print(paste0("Erro ao buscar código subelemento no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_subelemento)
}

#' @title Busca os códigos das unidades gestoras no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos das unidades gestoras
#' @rdname fetch_codigo_unidade_gestora
#' @examples
fetch_codigo_unidade_gestora <- function(sagres_con) {
  codigo_unidade_gestora <- tibble::tibble()
  tryCatch({
    codigo_unidade_gestora <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_Unidade_Gestora;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_UNIDADE_GESTORA)
  },
  error = function(e) print(paste0("Erro ao buscar código da unidade gestora no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_unidade_gestora)
}

#' @title Busca os empenhos realizados no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os empenhos
#' @rdname fetch_empenhos
#' @examples
fetch_empenhos <- function(sagres_con, cd_Ugestora) {
  empenhos <- tibble::tibble()
  tryCatch({
    empenhos <- DBI::dbGetQuery(sagres_con, sprintf("SELECT * FROM Empenhos WHERE cd_UGestora = %s;", cd_Ugestora)) %>%
      assert_dataframe_completo(COLNAMES_EMPENHOS)
  },
  error = function(e) print(paste0("Erro ao buscar empenhos no Banco Sagres (SQLServer): ", e))
  )

  return(empenhos)
}

#' @title Busca os Aditivos realizados no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os aditivos de licitação/contrato
#' @rdname fetch_aditivos
#' @examples
fetch_aditivos <- function(sagres_con) {
  aditivos <- tibble::tibble()
  tryCatch({
    aditivos <- DBI::dbGetQuery(sagres_con, "SELECT TOP 10 * FROM Aditivos;") %>%
      assert_dataframe_completo(COLNAMES_ADITIVOS)
  },
  error = function(e) print(paste0("Erro ao buscar aditivos no Banco Sagres (SQLServer): ", e))
  )

  return(aditivos)
}

#' @title Busca os Pagamentos realizados no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname fetch_pagamentos
#' @examples
fetch_pagamentos <- function(sagres_con, cd_Ugestora) {
  pagamentos <- tibble::tibble()
  tryCatch({
    pagamentos <- DBI::dbGetQuery(sagres_con, sprintf("SELECT * FROM Pagamentos WHERE cd_UGestora = %s;", cd_Ugestora)) %>%
      assert_dataframe_completo(COLNAMES_PAGAMENTOS)
  },
  error = function(e) print(paste0("Erro ao buscar pagamentos no Banco Sagres (SQLServer): ", e))
  )

  return(pagamentos)
}

#' @title Busca os Convenios realizados no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre convênios
#' @rdname fetch_convenios
#' @examples
fetch_convenios <- function(sagres_con) {
  convenios <- tibble::tibble()
  tryCatch({
    convenios <- DBI::dbGetQuery(sagres_con, "SELECT TOP 10 * FROM Convenios;") %>%
      assert_dataframe_completo(COLNAMES_CONVENIOS)
  },
  error = function(e) print(paste0("Erro ao buscar convênios no Banco Sagres (SQLServer): ", e))
  )

  return(convenios)
}

#' @title Busca os códigos códigos dos municípios no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os códigos dos municípios
#' @rdname fetch_codigo_municipio
#' @examples
fetch_codigo_municipio <- function(sagres_con) {
  codigo_munipio <- tibble::tibble()
  tryCatch({
    codigo_munipio <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Codigo_Municipios;") %>%
      assert_dataframe_completo(COLNAMES_CODIGO_MUNICIPIO)
  },
  error = function(e) print(paste0("Erro ao buscar código do município no Banco Sagres (SQLServer): ", e))
  )

  return(codigo_munipio)
}

#' @title Busca participantes de licitações no banco SAGRES 2019
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre participantes
#' @rdname fetch_participantes
#' @examples
fetch_participantes <- function(sagres_con) {
  participantes <- tibble::tibble()
  tryCatch({
    participantes <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Participantes;") %>%
      assert_dataframe_completo(COLNAMES_PARTICIPANTES)
  },
  error = function(e) print(paste0("Erro ao buscar Participantes no Banco Sagres (SQLServer): ", e))
  )

  return(participantes)
}

#' @title Busca fornecedores cadastrados no banco SAGRES 2019
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre fornecedores
#' @rdname fetch_fornecedores
#' @examples
fetch_fornecedores <- function(sagres_con) {
  fornecedores <- tibble::tibble()
  tryCatch({
    fornecedores <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Fornecedores;") %>%
      assert_dataframe_completo(COLNAMES_FORNECEDORES)
  },
  error = function(e) print(paste0("Erro ao buscar Fornecedores no Banco Sagres (SQLServer): ", e))
  )

  return(fornecedores)
}

#' @title Busca propostas cadastradas no banco SAGRES 2019
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre as propostas
#' @rdname fetch_propostas
#' @examples
fetch_propostas <- function(sagres_con) {
  propostas <- tibble::tibble()
  tryCatch({
    propostas <- DBI::dbGetQuery(sagres_con, "SELECT * FROM Propostas;") %>%
      assert_dataframe_completo(COLNAMES_PROPOSTAS)
  },
  error = function(e) print(paste0("Erro ao buscar Propostas no Banco Sagres (SQLServer): ", e))
  )

  return(propostas)

}

#' @title Busca os Estornos de Pagamentos realizados no Banco do Sagres SQLServer
#' @param sagres_con Conexão com o Banco de Dados
#' @return Dataframe contendo informações sobre os estornos de pagamentos
#' @rdname fetch_estorno_pagamento
#' @examples
fetch_estorno_pagamento <- function(sagres_con) {
  estorno_pagamento <- tibble::tibble()
  tryCatch({
    estorno_pagamento <- DBI::dbGetQuery(sagres_con, "SELECT * FROM EstornoPagamento;") %>%
       assert_dataframe_completo(COLNAMES_ESTORNO_PAGAMENTO)
  },
  error = function(e) print(paste0("Erro ao buscar estorno de pagamento no Banco Sagres (SQLServer): ", e))
  )

  return(estorno_pagamento)
}