#' @title Lê dataframe contendo informações das licitações
#' @return Dataframe contendo informações sobre as licitações
#' @rdname read_licitacoes
#' @examples
#' licitacoes_dt <- read_licitacoes()
read_licitacoes <- function() {
  licitacoes_dt <- readr::read_csv(here::here("../fetcher/data/licitacoes.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     nu_Licitacao = readr::col_character(),
                                     dt_Homologacao = readr::col_datetime(format = ""),
                                     nu_Licitacao = readr::col_double(),
                                     de_Obs = readr::col_character(),
                                     dt_MesAno = readr::col_character(),
                                     registroCGE= readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações do tipo do objeto das licitações
#' @return Dataframe contendo informações sobre o tipo do objeto das licitações
#' @rdname read_licitacoes
#' @examples
#' tipo_objeto_licitacao_dt <- read_tipo_objeto_licitacao()
read_tipo_objeto_licitacao <- function() {
  tipo_objeto_licitacao_dt <- readr::read_csv(here::here("../fetcher/data/tipo_objeto_licitacao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_TipoObjeto = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações do tipo da modalidade das licitações
#' @return Dataframe contendo informações sobre o tipo da modalidade das licitações
#' @rdname read_tipo_modalidade_licitacao
#' @examples
#' tipo_modalidade_licitacao_dt <- read_tipo_modalidade_licitacao()
read_tipo_modalidade_licitacao <- function() {
  tipo_modalidade_licitacao_dt <- readr::read_csv(here::here("../fetcher/data/tipo_modalidade_licitacao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_TipoLicitacao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações do tipo do regime de execução
#' @return Dataframe contendo informações sobre o tipo do regime de execução
#' @rdname read_regime_execucao
#' @examples
#' regime_execucao_dt <- read_regime_execucao()
read_regime_execucao <- function() {
  regime_execucao_dt <- readr::read_csv(here::here("../fetcher/data/regime_execucao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     de_regimeExecucao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos das unidades gestoras
#' @return Dataframe contendo informações sobre os códigos das unidades gestoras
#' @rdname read_codigo_unidade_gestora
#' @examples
#' codigo_unidade_gestora_dt <- read_codigo_unidade_gestora()
read_codigo_unidade_gestora <- function() {
  codigo_unidade_gestora_dt <- readr::read_csv(here::here("../fetcher/data/codigo_unidade_gestora.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_Ibge = readr::col_number(),
                                     cd_Ugestora = readr::col_number()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de funções
#' @return Dataframe contendo informações sobre os códigos de funções
#' @rdname read_codigo_funcao
#' @examples
#' codigo_funcao_dt <- read_codigo_funcao()
read_codigo_funcao <- function() {
  codigo_funcao_df <- readr::read_csv(here::here("../fetcher/data/codigo_funcao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Funcao = readr::col_integer(),
                                     de_Funcao = readr::col_character(),
                                     st_Ativo = readr::col_character()
                                   ))
}


#' @title Lê dataframe contendo informações do objeto dos contratos
#' @return Dataframe contendo informações sobre os contratos
#' @rdname read_contratos
#' @examples
#' contratos_dt <- read_contratos()
read_contratos <- function() {
  contratos_df <- readr::read_csv(here::here("../fetcher/data/contratos.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_UGestora = readr::col_integer(),
                                     dt_Ano = readr::col_integer(),
                                     tp_Licitacao = readr::col_integer(),
                                     vl_TotalContrato = readr::col_double(),
                                     dt_Assinatura = readr::col_datetime(format = ""),
                                     dt_Recebimento = readr::col_datetime(format = "")
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de subfunções
#' @return Dataframe contendo informações sobre os códigos de subfunções
#' @rdname read_codigo_subfuncao
#' @examples
#' codigo_subfuncao_dt <- read_codigo_subfuncao()
read_codigo_subfuncao <- function() {
  codigo_subfuncao_df <- readr::read_csv(here::here("../fetcher/data/codigo_subfuncao.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_SubFuncao = readr::col_integer(),
                                     de_SubFuncao = readr::col_character(),
                                     st_Ativo = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de elementos de despesas
#' @return Dataframe contendo informações sobre os códigos de elementos de despesas
#' @rdname read_codigo_elemento_despesa
#' @examples
#' codigo_elemento_despesa_dt <- read_codigo_elemento_despesa()
read_codigo_elemento_despesa <- function() {
  codigo_elemento_despesa_df <- readr::read_csv(here::here("../fetcher/data/codigo_elemento_despesa.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Elemento = readr::col_character(),
                                     de_Elemento = readr::col_character(),
                                     de_Abreviacao = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações dos códigos de subelementos
#' @return Dataframe contendo informações sobre os códigos de subelementos
#' @rdname read_codigo_subelemento
#' @examples
#' codigo_subelemento_dt <- read_codigo_subelemento()
read_codigo_subelemento <- function() {
  codigo_subelemento_df <- readr::read_csv(here::here("../fetcher/data/codigo_subelemento.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_Subelemento = readr::col_character(),
                                     de_Subelemento = readr::col_character(),
                                     de_Conteudo = readr::col_character()
                                   ))
}


#' @title Lê dataframe contendo informações dos empenhos
#' @return Dataframe contendo informações sobre empenhos
#' @rdname read_empenhos_by_unidade_gestora
#' @examples
#' empenhos_dt <- read_empenhos_by_unidade_gestora()
read_empenhos_by_unidade_gestora <- function(cd_Ugestora) {
  empenhos_df <- readr::read_csv(here::here(sprintf("../fetcher/data/empenhos/empenhos_%s.csv", cd_Ugestora)),
                                 col_types = list(
                                   .default = readr::col_number(),
                                   cd_UGestora = readr::col_number(),
                                   dt_Ano = readr::col_number(),
                                   cd_UnidOrcamentaria = readr::col_character(),
                                   cd_Funcao = readr::col_character(),
                                   cd_Subfuncao = readr::col_character(),
                                   cd_Programa = readr::col_character(),
                                   cd_Acao = readr::col_character(),
                                   cd_classificacao = readr::col_character(),
                                   cd_CatEconomica = readr::col_character(),
                                   cd_NatDespesa = readr::col_character(),
                                   cd_Modalidade = readr::col_character(),
                                   cd_Elemento = readr::col_character(),
                                   cd_SubElemento = readr::col_character(),
                                   tp_Licitacao = readr::col_number(),
                                   nu_Licitacao = readr::col_character(),
                                   nu_Empenho = readr::col_character(),
                                   tp_Empenho = readr::col_character(),
                                   dt_Empenho = readr::col_character(),
                                   cd_Credor = readr::col_character(),
                                   no_Credor = readr::col_character(),
                                   tp_Credor = readr::col_character(),
                                   de_Historico1 = readr::col_character(),
                                   de_Historico2 = readr::col_character(),
                                   de_Historico = readr::col_character(),
                                   tp_Meta = readr::col_character(),
                                   nu_Obra = readr::col_character(),
                                   dt_MesAno = readr::col_character(),
                                   dt_MesAnoReferencia = readr::col_character(),
                                   tp_FonteRecursos = readr::col_character(),
                                   nu_CPF = readr::col_character()
                                 ))
}


#' @title Lê dataframe contendo informações dos aditivos de licitações/contratos
#' @return Dataframe contendo informações sobre os aditivos
#' @rdname read_aditivos
#' @examples
#' aditivos_dt <- read_aditivos()
read_aditivos <- function() {
  aditivos_df <- readr::read_csv(here::here("../fetcher/data/aditivos.csv"),
                                           col_types = list(
                                             .default = readr::col_number(),
                                             cd_UGestora = readr::col_character(),
                                             dt_Ano = readr::col_character(),
                                             nu_Contrato = readr::col_character(),
                                             nu_Aditivo = readr::col_character(),
                                             dt_Assinatura = readr::col_character(),
                                             de_Motivo = readr::col_character(),
                                             dt_MesAno = readr::col_character(),
                                             dt_Aditado = readr::col_character()
                                           ))
}


#' @title Lê dataframe contendo informações dos pagamentos
#' @return Dataframe contendo informações sobre pagamentos
#' @rdname read_pagamentos_by_unidade_gestora
#' @examples
#' pagamentos_dt <- read_pagamentos_by_unidade_gestora()
read_pagamentos_by_unidade_gestora <- function(cd_Ugestora) {
  pagamentos_df <- readr::read_csv(here::here(sprintf("../fetcher/data/pagamentos/pagamentos_%s.csv", cd_Ugestora)),
                                           col_types = list(
                                             .default = readr::col_number(),
                                             cd_UGestora = readr::col_number(),
                                             dt_Ano = readr::col_number(),
                                             cd_UnidOrcamentaria = readr::col_character(),
                                             nu_Empenho = readr::col_character(),
                                             nu_Parcela = readr::col_character(),
                                             tp_Lancamento = readr::col_character(),
                                             dt_Pagamento = readr::col_character(),
                                             cd_Conta = readr::col_character(),
                                             nu_ChequePag = readr::col_character(),
                                             nu_DebAut = readr::col_character(),
                                             cd_BancoRec = readr::col_character(),
                                             cd_AgenciaRec = readr::col_character(),
                                             nu_ContaRec = readr::col_character(),
                                             tp_FonteRecursos = readr::col_character(),
                                             dt_MesAno = readr::col_character(),
                                             cd_Banco = readr::col_character(),
                                             cd_Agencia = readr::col_character(),
                                             tp_ContaBancaria = readr::col_character()
                                           ))
}


#' @title Lê dataframe contendo informações de convênios
#' @return Dataframe contendo informações sobre convênios
#' @rdname read_convenios
#' @examples
#' convenios_dt <- read_convenios()
read_convenios <- function() {
  convenios_df <- readr::read_csv(here::here("../fetcher/data/convenios.csv"),
                                   col_types = list(
                                     .default = readr::col_number(),
                                     cd_UGestora = readr::col_character(),
                                     dt_Ano = readr::col_character(),
                                     nu_Convenio = readr::col_character(),
                                     dt_AnoCelebracao = readr::col_character(),
                                     no_Convenio = readr::col_character(),
                                     cd_Concedente = readr::col_character(),
                                     no_Concedente = readr::col_character(),
                                     de_Objeto = readr::col_character(),
                                     tp_OrigemRecursoConvenio = readr::col_character(),
                                     dt_MesAno = readr::col_character()
                                   ))
}


#' @title Lê dataframe contendo informações dos municípios
#' @return Dataframe contendo informações sobre os municípios
#' @rdname read_codigo_municipio
#' @examples
#' codigo_municipio_dt <- read_codigo_municipio()
read_codigo_municipio <- function() {
  codigo_municipio_dt <- readr::read_csv(here::here("../fetcher/data/codigo_municipio.csv"),
                                           col_types = list(
                                             .default = readr::col_character(),
                                             cd_Ibge = readr::col_number()
                                           ))
}


#' @title Lê dataframe contendo informações dos participantes de licitações
#' @return Dataframe contendo informações sobre os participantes
#' @rdname read_participantes
#' @examples
#' participantes_dt <- read_participantes()
read_participantes <- function() {
  pagamentos_df <- readr::read_csv(here::here("../fetcher/data/participantes.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_UGestora = readr::col_integer(),
                                     dt_Ano = readr::col_integer(),
                                     tp_Licitacao = readr::col_integer()
                                   ))
}


#' @title Lê dataframe contendo informações dos fornecedores
#' @return Dataframe contendo informações sobre os fornecedores
#' @rdname read_fornecedores
#' @examples
#' fornecedores_dt <- read_fornecedores()
read_fornecedores <- function() {
   fornecedores_dt <- readr::read_csv(here::here("../fetcher/data/fornecedores.csv"),
                                           col_types = list(
                                             .default = readr::col_number(),
                                             nu_CPFCNPJ = readr::col_character(),
                                             no_Fornecedor = readr::col_character(),
                                             nu_IncEstadual = readr::col_character(),
                                             de_Endereco = readr::col_character(),
                                             de_Bairro = readr::col_character(),
                                             de_Complemento = readr::col_character(),
                                             nu_CEP = readr::col_character(),
                                             de_Municipio = readr::col_character(),
                                             cd_UF = readr::col_character(),
                                             nu_ddd = readr::col_character(),
                                             nu_Fone = readr::col_character(),
                                             dt_MesAno = readr::col_character(),
                                             dt_MesAnoReferencia = readr::col_character()
                                           ))
}

#' @title Lê dataframe contendo informações dos contrados mutados
#' @return Dataframe contendo informações sobre os contrados mutados
#' @rdname read_contratos_mutados
#' @examples
#' contrados_mutados_df <- read_contrados_mutados()
read_contratos_mutados <- function(){
  contrados_mutados_df <-readr::read_csv(here::here("../fetcher/data/contratos_mutados.csv"),
                                           col_types = list(
                                             .default = readr::col_character(),
                                              jurisdicionado = readr::col_character(),
                                              cod_jurisdicionado = readr::col_number(),
                                              cd_Ugestora = readr::col_number(),
                                              numero_contrato = readr::col_character(),
                                              id_contrato = readr::col_number(),
                                              modalidade_licitacao = readr::col_character(),
                                              numero_licitacao = readr::col_character(),
                                              cpf_cnpj = readr::col_character(),
                                              tipo_alteracao = readr::col_character(),
                                              data_alteracao = readr::col_character(),
                                              cd_Municipio = readr::col_character(),
                                              no_Municipio = readr::col_character(),
                                              de_Ugestora = readr::col_character()
                                              ))
}

#' @title Lê dataframe contendo informações das propostas das licitações
#' @return Dataframe contendo informações sobre as propostas
#' @rdname read_propostas
#' @examples
#' propostas_dt <- read_propostas()
read_propostas <- function() {
  propostas_df <- readr::read_csv(here::here("../fetcher/data/propostas.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     cd_UGestora = readr::col_integer(),
                                     dt_Ano = readr::col_integer(),
                                     tp_Licitacao = readr::col_integer(),
                                     cd_UGestoraItem = readr::col_integer(),
                                     qt_Ofertada = readr::col_number(),
                                     vl_Ofertado = readr::col_number(),
                                     st_Proposta = readr::col_integer()
                                   ))
}

#' @title Lê dataframe contendo informações dos estornos de pagamentos
#' @return Dataframe contendo informações sobre estornos de pagamentos
#' @rdname read_estorno_pagamento
#' @examples
#' estorno_pagamento_dt <- read_estorno_pagamento()
read_estorno_pagamento <- function() {
  estorno_pagamento_df <- readr::read_csv(here::here("../fetcher/data/estorno_pagamento.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                     dt_Ano = readr::col_integer(),
                                     tp_Lancamento = readr::col_integer(),
                                     vl_Estorno = readr::col_number()
                                   ))
}

#' @title Lê dataframe contendo informações das localidades de acordo com o IBGE
#' @return Dataframe contendo informações das localidades de acordo com o IBGE
#' @rdname read_codigo_localidades_ibge
#' @examples
#' codigo_localidades_ibge_dt <- read_codigo_localidades_ibge()
read_codigo_localidades_ibge <- function() {
  codigo_localidades_ibge_df <- readr::read_csv(here::here("../fetcher/data/codigo_localidades_ibge.csv"),
                                   col_types = list(
                                     .default = readr::col_character(),
                                    UF = readr::col_number(),
                                    Nome_UF	= readr::col_character(),
                                    "Mesorregião Geográfica" = readr::col_number(),
                                    Nome_Mesorregião = readr::col_character(),
                                    "Microrregião Geográfica" = readr::col_number(),
                                    Nome_Microrregião	= readr::col_character(),
                                    Município	= readr::col_number(),
                                    "Código Município Completo"	= readr::col_number(),
                                    Nome_Município = readr::col_character()
                                   ))
}

#' @title Lê dataframe contendo informações das licitações contidas no tramita
#' @return Dataframe contendo informações das licitações do tramita
#' @rdname read_licitacoes_tramita
#' @examples
#' licitacoes_tramita_df <- read_licitacoes_tramita()
read_licitacoes_tramita <- function() {
  codigo_localidades_ibge_df <- readr::read_csv(here::here("../fetcher/data/licitacoes_pb_2020.csv"),
                                   col_types = list(
                                    .default = readr::col_character(),
                                    cod_unidade_gestora = readr::col_integer(),
                                    ente = readr::col_character(),
                                    unidade_gestora = readr::col_character(),
                                    esfera = readr::col_character(),
                                    numero_licitacao = readr::col_character(),
                                    data_homologacao = readr::col_character(),
                                    valor_homologacao = readr::col_number(),
                                    valor_estimado = readr::col_number(),
                                    objeto = readr::col_character(),
                                    tipo_objeto = readr::col_character(),
                                    cod_modalidade_licitacao = readr::col_integer(),
                                    modalidade_licitacao = readr::col_character(),
                                    situacao = readr::col_character(),
                                    valor_proposta = readr::col_number(),
                                    cpf_cnpj_licitante = readr::col_character(),
                                    nome_licitante = readr::col_character(),
                                    numero_protocolo = readr::col_character(),
                                    tipo_protocolo = readr::col_character()
                                   ))
}