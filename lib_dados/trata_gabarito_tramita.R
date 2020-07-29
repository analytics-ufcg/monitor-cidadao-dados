#  Essa função deve ser executada para realizar o tratamento do arquivo: dados/contratos_mutados_2020/doc_43432_20_lista_de_mutacoes_contratuais.csv 
#  Para geração do arquivo dados/contratos_mutados_2020/contratos_tramita_mutados2020.csv 

#' @description Importa os dados de contratos do Tramita conseguidos em Julho de 2020 e faz os tratamentos necessários
#' @param contratos_tramita_data_path Caminho para o arquivo mais atualizado dos dados do Tramita
#' @return Data Frame com os dados do tramita tratados
trata_tramita_2020 <- function() {
  library(tidyverse)
  
  tramita_mutados <- read_delim(here::here("dados/contratos_mutados_2020/doc_43432_20_lista_de_mutacoes_contratuais.csv"), 
                                "|", quote = "\\\"", escape_double = FALSE, col_types = cols(cod_jurisdicionado = col_character(), 
                                                                             cod_sagres = col_character(), numero_contrato = col_character(), 
                                                                             id_contrato = col_character(), cpf_cnpj = col_character()), trim_ws = TRUE)  

  codigo_unidade_gestora <- read_csv(here::here("fetcher/data/codigo_unidade_gestora.csv"), 
                                     col_types = cols(cd_Municipio = col_character(), cd_Ugestora = col_character()))
  
  
  contratos_tramita <- tramita_mutados %>% 
    left_join(codigo_unidade_gestora, by = c("cod_sagres" = "cd_Ugestora")) %>% 
    select(-protocolo, -cd_Ibge, -previdencia, -`justificativa;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;`) %>% 
    mutate(modalidade_licitacao = if_else(grepl("Ata de Registro", modalidade_licitacao), "Adesão a Ata de Registro de Preços", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("Chamada", modalidade_licitacao), "Chamada Pública", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("Concorr", modalidade_licitacao), "Concorrência", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("Eletr", modalidade_licitacao), "Pregão Eletrônico", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("Presencial", modalidade_licitacao), "Pregão Presencial", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("RDC", modalidade_licitacao), "RDC - Regime Diferenciado de Contratações Públicas", modalidade_licitacao),
           modalidade_licitacao = if_else(grepl("Tomada", modalidade_licitacao), "Tomada de Preços", modalidade_licitacao),
           tipo_alteracao = if_else(grepl("Aditivo", tipo_alteracao), "Aditivo", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Ordem", tipo_alteracao), "Ordem de Serviço", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Parali", tipo_alteracao), "Paralisação", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Resci", tipo_alteracao), "Rescisão", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Retomada", tipo_alteracao), "Retomada", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Suspen", tipo_alteracao), "Suspensão", tipo_alteracao),
           tipo_alteracao = if_else(grepl("Susta", tipo_alteracao), "Sustação", tipo_alteracao))
  
    
  write.csv(contratos_tramita, 
            file = here::here("dados/contratos_mutados_2020/ContratosMutadosTramita_Julho2020.csv"), 
            row.names = FALSE)
}
