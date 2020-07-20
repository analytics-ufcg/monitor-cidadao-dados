# Features (contratos relacionados a Obras. Situação é o status da Obra): 
# - Número de contratos terminados Administrativamente ou judicialmente (status 8) até a data limite do contrato.
# - Número de contratos com situação Inacabado (status 4) até a data limite do contrato.
# - Número de contratos com situação Abandonado (status 9) até a data limite do contrato.

#' @description Carrega a informações do status de contratos (relacionados a uma lista de CNPJ's) anteriores a uma data limite
#' @param ano_inicial Ano inicial do intervalo de tempo (limite inferior). Default é 2011.
#' @param ano_final Ano final do intervalo de tempo (limite superior). Default é 2016.
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações do status de contratos anteriores
#' @return Data frame com informações do status de contratos anteriores. Ex: quantidade de contratos relacionados a obras que terminaram Administrativamente ou Judicialmente
carrega_info_status_contrato <- function(ano_inicial = 2011, ano_final = 2016, manter_obras_em_andamento = FALSE, cnpjs_datas_contratos) {
    library(tidyverse)
    library(here)
    library(rsagrespb)
    source(here("lib/obras/merge_obras_contratos.R"))
    
    # Carrega contratos relacionados a obras
    contratos_obras <- merge_obras_contratos(ano_inicial, ano_final, "prod")
    
    contratos_all <- carrega_contratos(ano_inicial, ano_final, limite_inferior = 0)
    
    contratos_merge <- contratos_obras %>% 
        filter((andamento != 1) | manter_obras_em_andamento) %>% ## SERemove contratos associados a obras que ainda estão em execução
        left_join(contratos_all %>% select(cd_UGestora, nu_Contrato, dt_Assinatura), by = c("cd_UGestora", "nu_Contrato")) %>% 
        mutate(dt_Assinatura = as.Date(dt_Assinatura, "%Y-%m-%d")) %>% 
        select(cd_UGestora, nu_Contrato, nu_CPFCNPJ, dt_Assinatura, andamento) %>% 
        
        group_by(cd_UGestora, nu_Contrato, nu_CPFCNPJ) %>% 
        summarise(dt_Assinatura = first(dt_Assinatura),
                  andamento = max(andamento)) %>% 
        ungroup()
    
    # Determina número de contratos para cada categoria de andamento. Filtra contratos considerando uma data de limite superior
    contratos_status <- cnpjs_datas_contratos %>% 
        left_join(contratos_merge, by = c("nu_CPFCNPJ")) %>% 
        filter(dt_Assinatura < dt_Inicio) %>% 
        
        group_by(nu_CPFCNPJ, dt_Inicio, andamento) %>% 
        summarise(num_contratos = n_distinct(cd_UGestora, nu_Contrato)) %>% 
        ungroup()
        
    # "1" -> "Em Execução Normal (Dentro do Cronograma) # "2" -> "Atrasada (Cronograma Atrasado)" # "3" -> "Paralisada (Sem Execução)"
    # "4" -> "Inacabada (Não Concluída Após Término do Contrato)" # "7" -> "Finalizada por Conclusão de Construção" 
    # "8" -> "Finalizada Administrativa ou Judicialmente" # "9" -> "Abandonada"
    andamento_features <- c(4, 8, 9)
    
    andamento_descricao <- data.frame(cd_Andamento = c(1, 2, 3, 4, 7, 8, 9), 
                                      desc_Andamento = c("Execucao_Normal", "Atrasado", "Paralisado", "Inacabado", 
                                                         "Conclusao", "Finalizado_Judicialmente", "Abandonado"),
                                      stringsAsFactors = FALSE)
    
    contratos_status_features <- contratos_status %>% 
        filter(andamento %in% andamento_features) %>% 
        left_join(andamento_descricao, by = c("andamento" = "cd_Andamento")) %>% 
        select(nu_CPFCNPJ, dt_Inicio, desc_Andamento, num_contratos) %>% 
        
        mutate(desc_Andamento = paste0("n_contratos_", desc_Andamento)) %>% 
        spread(desc_Andamento, num_contratos, fill = 0)
    
    return(contratos_status_features)
}
