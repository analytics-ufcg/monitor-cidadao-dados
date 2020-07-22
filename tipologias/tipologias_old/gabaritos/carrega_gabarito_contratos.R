#' @description Carrega informações de rescisão relativas a contratos e classifica os contratos como suspensos ou não. 
#' A rescisão de um contrato é obtida através dos dados do tramita
#' @param dados dataframe com os dados de contratos. É preciso ter a chave de contrato (cd_UGestora, nu_Contrato)
#' @return Data Frame com os dados passados como parâmetro e uma nova coluna status_tramita com a classe (pertence a classe positiva (1) ou não (0))
carrega_gabarito_tramita <- function(dados) {
    library(tidyverse)
    library(here)
    
    contratos_tramita <- read_csv(here::here("../dados/contratos_rescindidos_2018/contratos_tramita_tratado.csv"))

    contratos_tramita_group <- contratos_tramita %>% 
        group_by(cd_Ugestora, numero_contrato) %>% 
        summarise(status_tramita = n()) %>% 
        ungroup()

    dados_status <- dados %>% 
        left_join(contratos_tramita_group, by = c("cd_UGestora" = "cd_Ugestora", "nu_Contrato" = "numero_contrato")) %>% 
        mutate(status_tramita = if_else(is.na(status_tramita), 0, 1))
    
    return(dados_status)
}