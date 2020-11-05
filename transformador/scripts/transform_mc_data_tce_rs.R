message("")
message(" ------------------------------------------")
message("    INICIANDO SCRIPT - TRANSFORMAÇÃO DOS DADOS   ")
message(" ------------------------------------------")
message("")


library(magrittr)

source(here::here("R/tradutor/interface.R"))
source(here::here("utils/join_utils.R"))

.HELP <- "Rscript transform_mc_data_tce_rs.R"

#Instala pacote mcTransformador
devtools::document()


#-----------------------------------------------------------------------------#
#-------------------------          IBGE            --------------------------#
#-----------------------------------------------------------------------------#

message(" CARREGANDO DADOS DO IBGE...")
message("")

# RECUPERA AS TABELAS
codigo_localidades_ibge_df <- get_codigo_localidades_ibge()

message(" TRANSFORMANDO OS DADOS DO IBGE...")
message("")
# TRANSFORMA AS TABELAS
codigo_localidades_ibge_transformados <- codigo_localidades_ibge_df  %>%
  mcTransformador::process_codigo_localidades_ibge()


message("   Dados do IBGE carregados, transformados e salvos com sucesso!")
message("")
message("")


#-----------------------------------------------------------------------------#
#-------------------------          TCE-RS          --------------------------#
#-----------------------------------------------------------------------------#

ANOS_DISPONIVEIS <- c(2018, 2019, 2020)
anos_fetch <- list.dirs(path = "./../fetcher/data/rs/contratos", full.names = FALSE, recursive = TRUE)

message(" CARREGANDO DADOS DO TCE-RS...")
message("")

# --- Carregando e transformando Órgãos ---
message("  - Carregando e processando órgãos auditados...")
orgaos_rs_df <- get_orgaos_tce_rs()

orgaos_rs_transformados <- orgaos_rs_df  %>%
  join_orgaos_rs_localidades_ibge(codigo_localidades_ibge_transformados)

# --- Carregando os tipos de licitações existentes ---
message("  - Carregando tipos de licitação...")
modalidade_licitacao_rs_df <- get_modalidade_licitacao_tce_rs()



# ----------------------------
# Recupera dados do RS por ano
# ----------------------------
for(ano in anos_fetch){
  # evita a leitura de pastas estranhas no diretório
  if (! (ano %in% ANOS_DISPONIVEIS)) next

  # --- Carregando os fornecedores/pessoas existentes ---
  message("  - Carregando e processando fornecedores/pessoas...")
  pessoas_rs_df <- get_pessoas_tce_rs(ano)

  # --- Carregando e transformando Licitações ---
  message(sprintf("  - Carregando e processando licitações do ano %s...", ano))
  licitacao_rs_df <- get_licitacoes_tce_rs(ano)

  licitacao_rs_transformados <- licitacao_rs_df %>% mcTransformador::process_licitacao_tce_rs() %>%
    join_licitacoes_rs_modalidade(modalidade_licitacao_rs_df) %>%
    join_licitacoes_rs_orgaos(orgaos_rs_transformados)

  # --- Carregando e transformando Contratos ---
  message(sprintf("  - Carregando e processando contratos do ano %s...", ano))
  contratos_rs_df <- get_contratos_tce_rs(ano)

  contratos_rs_transformados <- contratos_rs_df %>% mcTransformador::process_contrato_tce_rs() %>%
    join_contratos_rs_licitacoes(licitacao_rs_transformados) %>%
    join_contratos_rs_pessoas(pessoas_rs_df)

  # --- Formata tabelas ---
  message(sprintf("  - Formatando licitações do ano %s...", ano))
  licitacoes_rs_formatadas <- licitacao_rs_transformados %>%
    format_licitacao_tce_rs()

  message(sprintf("  - Formatando contratos do ano %s...", ano))
  contratos_rs_formatados <- contratos_rs_transformados %>%
    format_contrato_tce_rs()

  # --- Criando arquivos ---
  message(sprintf("  - Salvando licitações e contratos do ano %s...", ano))
  # Cria a pasta de saída caso ela não exista
  output_dir_contratos_rs = 'data/rs/'
  if (!dir.exists(output_dir_contratos_rs)){
    dir.create(output_dir_contratos_rs)
    dir.create('data/rs/licitacoes')
    dir.create('data/rs/contratos')
    dir.create('data/rs/empenhos')
    dir.create('data/rs/pagamentos')
  }

  readr::write_csv(contratos_rs_formatados, here::here(sprintf("./data/rs/contratos/contratos_%s.csv", ano)))
  readr::write_csv(licitacoes_rs_formatadas, here::here(sprintf("./data/rs/licitacoes/licitacoes_%s.csv", ano)))

  #
  # --- Carregando e transformando EMPENHOS e PAGAMENTOS
  #
  message(sprintf("  - Carregando e processando empenhos e pagamentos do ano %s...", ano))

  #seta o caminho dos arquivos de empenhos/pagamentos
  path_files_empenhos <- sprintf("../fetcher/data/rs/empenhos/%s", ano)
  files_empenhos <-list.files(path_files_empenhos)

  for(file_empenho in files_empenhos){
    message(sprintf("  - Carregando empenhos/pagamentos do arquivo %s (%s)...", file_empenho, ano))
    empenho_pagamento_rs_df <- get_empenho_tce_rs(ano, file_empenho)

    empenhos_pagamento_rs_transformados <-  empenho_pagamento_rs_df  %>%
      mcTransformador::process_empenhos_pagamento_tce_rs(file_empenho) %>%
      join_empenhos_pagamentos_rs_contratos(contratos_rs_transformados)

    message(sprintf("  - Formatando empenhos do arquivo %s (%s)...", file_empenho, ano))
    empenhos_rs_formatados <- empenhos_pagamento_rs_transformados %>%
      format_empenhos_tce_rs()

    message(sprintf("  - Formatando pagamentos do arquivo %s (%s)...", file_empenho, ano))
    pagamentos_rs_formatados <- empenhos_pagamento_rs_transformados %>%
      format_pagamentos_tce_rs()

    message(sprintf("  - Salvando empenhos/pagamentos do arquivo %s (%s)...", file_empenho, ano))
    readr::write_csv(empenhos_rs_formatados, here::here(sprintf("./data/rs/empenhos/empenhos_%s_%s", ano, file_empenho)))
    readr::write_csv(pagamentos_rs_formatados, here::here(sprintf("./data/rs/pagamentos/pagamentos_%s_%s", ano, file_empenho)))

    rm(empenho_pagamento_rs_df)
    rm(empenhos_pagamento_rs_transformados)
    rm(empenhos_rs_formatados)
    rm(pagamentos_rs_formatados)
    gc()

  }

}




