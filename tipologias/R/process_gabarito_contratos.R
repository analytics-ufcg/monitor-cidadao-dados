#' @description Carrega informações de rescisão relativas a contratos e classifica os contratos como suspensos ou não. 
#' A rescisão de um contrato é obtida através dos dados do tramita
#' @param dados dataframe com os dados de contratos. É preciso ter a chave de contrato (cd_UGestora, nu_Contrato)
#' @return Data Frame com os dados passados como parâmetro e uma nova coluna status_tramita com a classe (pertence a classe positiva (1) ou não (0))
processa_gabarito_tramita <- function(dados, contratos_tramita) {
 
    # Adiciona filtragem nos contratos mutados - considerando apenas as mutações de interesse a seguir
    alteracoes_interesse = c("Impedimento", "Paralisação", "Rescisão", "Suspensão", "Sustação")
    
    contratos_tramita <- contratos_tramita %>%
        dplyr::filter(tipo_alteracao %in% alteracoes_interesse) %>% 
        dplyr::mutate(nu_contrato = str_pad(nu_contrato, 12, "left", "0"))
        
    contratos_tramita_group <- contratos_tramita %>% 
        dplyr::group_by(cd_u_gestora, nu_contrato) %>% 
        dplyr::summarise(status_tramita = dplyr::n()) %>% 
        dplyr::ungroup()

    dados_status <- dados %>% 
        dplyr::left_join(contratos_tramita_group, by = c("cd_u_gestora", "nu_contrato")) %>% 
        dplyr::mutate(status_tramita = dplyr::if_else(is.na(status_tramita), 0, 1))
    
    return(dados_status)
}