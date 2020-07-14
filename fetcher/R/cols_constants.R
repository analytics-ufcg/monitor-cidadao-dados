# ---------------------------
# tabelas em ordem alfabética


COLNAMES_ADITIVOS <-  c("cd_UGestora"="character","dt_Ano"="character","nu_Contrato"="character",
                        "nu_Aditivo"="character","dt_Assinatura"="character","de_Motivo"="character",
                        "vl_Aditivo"="numeric","dt_MesAno"="character","dt_Aditado"="character"
)

COLNAMES_CONTRATOS <- c("cd_UGestora"="integer", "dt_Ano"="integer",
                        "nu_Contrato"="character", "dt_Assinatura"="character",
                        "pr_Vigencia"="character", "nu_CPFCNPJ"="character",
                        "nu_Licitacao"="character", "tp_Licitacao"="integer",
                        "vl_TotalContrato"="numeric", "de_Obs"="character",
                        "dt_MesAno"="character", "registroCGE"="character",
                        "cd_SIAFI"="character", "dt_Recebimento"="character",
                        "foto"="character", "planilha"="character",
                        "ordemServico"="character"
)

COLNAMES_CONVENIOS <-  c("cd_Ugestora"="character","dt_Ano"="character","nu_Convenio"="character",
                         "dt_AnoCelebracao"="character","no_Convenio"="character","cd_Concedente"="numeric",
                         "no_Concedente"="numeric","de_Objeto"="character","tp_OrigemRecursoConvenio"="integer",
                         "dt_MesAno"="character"
)



COLNAMES_CODIGO_ELEMENTO_DESPESA <- c("cd_Elemento"="character","de_Elemento"="character","de_Abreviacao"="character"
)

COLNAMES_CODIGO_FUNCAO <- c("cd_Funcao"="integer","de_Funcao"="character","st_Ativo"="character"
)


COLNAMES_CODIGO_MUNICIPIO <-  c("cd_Ibge"="integer","cd_Municipio"="character","no_Municipio"="character",
                                "dt_AnoCriacao"="character","cd_RegiaoAdministrativa"="character",
                                "cd_MicroRegiao"="character","cd_MesoRegiao"="character"
)


COLNAMES_CODIGO_SUBELEMENTO <-  c("cd_Subelemento"="character","de_Subelemento"="character","de_Conteudo"="character"
)


COLNAMES_CODIGO_SUBFUNCAO <-c("cd_SubFuncao"="integer","de_SubFuncao"="character","st_Ativo"="character"
)


COLNAMES_CODIGO_UNIDADE_GESTORA <- c("cd_Ibge"="integer", "cd_Municipio"="character",
                                     "no_Municipio"="character", "cd_Ugestora"="integer",
                                     "de_Ugestora"="character", "previdencia"="character"
)

COLNAMES_EMPENHOS <- c("cd_UGestora"="character", "dt_Ano"="integer", "cd_UnidOrcamentaria"="character",
                       "cd_Funcao"="character", "cd_Subfuncao"="character", "cd_Programa"="character",
                       "cd_Acao"="character", "cd_classificacao"="character", "cd_CatEconomica"="character",
                       "cd_NatDespesa"="character", "cd_Modalidade"="character", "cd_Elemento"="character",
                       "cd_SubElemento"="character", "tp_Licitacao"="character", "nu_Licitacao"="character",
                       "nu_Empenho"="character", "tp_Empenho"="character", "dt_Empenho"="character",
                       "vl_Empenho"="numeric", "cd_Credor"="character", "no_Credor"="character",
                       "tp_Credor"="character", "de_Historico1"="character", "de_Historico2"="character",
                       "de_Historico"="character", "tp_Meta"="character", "nu_Obra"="character",
                       "dt_MesAno"="character", "dt_MesAnoReferencia"="character", "tp_FonteRecursos"="character",
                       "nu_CPF"="character"
)

COLNAMES_ESTORNO_PAGAMENTO <- c("cd_UGestora"="character", "dt_Ano"="integer", "cd_UnidOrcamentaria"="character",
                                  "nu_EmpenhoEstorno"="character", "nu_ParcelaEstorno"="character",
                                  "tp_Lancamento"="integer","dt_Estorno"="character","de_MotivoEstorno"="character",
                                  "st_DespesaLiquida"="numeric", "vl_Estorno"="numeric","dt_MesAno"="character"
)

COLNAMES_FORNECEDORES <-c("cd_UGestora"="integer","dt_Ano"="integer",
                      			"nu_CPFCNPJ"="character","tp_Credor"="integer",
                      			"no_Fornecedor"="character","nu_IncEstadual"="character",
                      			"de_Endereco"="character","de_Bairro"="character",
                      			"de_Complemento"="character","nu_CEP"="character",
                      			"de_Municipio"="character","cd_UF"="character",
                      			"nu_ddd"="character","nu_Fone"="character",
                      			"dt_MesAno"="character","dt_MesAnoReferencia"="character"
)

COLNAMES_LICITACOES <- c("cd_UGestora"="integer","dt_Ano"="integer",
                         "nu_Licitacao"="character","tp_Licitacao"="integer",
                         "dt_Homologacao"="character","nu_Propostas"="integer",
                         "vl_Licitacao"="numeric","tp_Objeto"="integer",
                         "de_Obs"="character","dt_MesAno"="character",
                         "registroCGE"="character","tp_regimeExecucao"="integer"
                        )

COLNAMES_PAGAMENTOS <-  c("cd_UGestora"="character","dt_Ano"="character","cd_UnidOrcamentaria"="character",
                          "nu_Empenho"="character","nu_Parcela"="character","tp_Lancamento"="integer",
                          "vl_Pagamento"="numeric","dt_Pagamento"="character","cd_Conta"="character",
                          "nu_ChequePag"="character","nu_DebAut"="character","cd_BancoRec"="character",
                          "cd_AgenciaRec"="character","nu_ContaRec"="character","tp_FonteRecursos"="integer",
                          "dt_MesAno"="character","cd_Banco"="character","cd_Agencia"="character",
                          "tp_ContaBancaria"="character"
)

COLNAMES_PARTICIPANTES <- c("cd_UGestora"="integer","dt_Ano"="integer",
                        			"nu_Licitacao"="character","tp_Licitacao"="integer",
                        			"nu_CPFCNPJ"="character","dt_MesAno"="character"
)

COLNAMES_REGIME_EXECUCAO <- c("tp_regimeExecucao"="integer",
                              "de_regimeExecucao"="character"
)

COLNAMES_TIPO_OBJETO_LICITACAO <- c("tp_Objeto"="integer",
                                    "de_TipoObjeto"="character"
                                    )

COLNAMES_TIPO_MODALIDADE_LICITACAO <- c("tp_Licitacao"="integer",
                                        "de_TipoLicitacao"="character"
                                        )
