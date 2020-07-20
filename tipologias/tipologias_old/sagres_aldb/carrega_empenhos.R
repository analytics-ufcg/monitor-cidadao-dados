# Essa função não considera uma data limite para o processamento e carregamento dos empenhos.
#' @description Carrega a lista de empenhos realizados em um intervalo de tempo
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param lista_cnpjs Lista com os CNPJ's distintos
#' @return Data frame com informações do empenho, do valor de pagamentos associados a este empenho e o valor estornado associado aos pagamentos
carrega_empenhos <- function(ano_inicial = 2014, ano_final = 2014, lista_cnpjs) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    sagres <- dbConnect(MySQL(), dbname = "sagres_municipal", group="ministerio-publico", username="shiny")
    
    template <- ('
            SELECT cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, 
                   total_pago, total_estornado
            FROM Empenhos e
            INNER JOIN (
	            SELECT p.cd_UGestora, p.dt_Ano, p.cd_UnidOrcamentaria, p.nu_Empenho, SUM(vl_Pagamento) as total_pago, SUM(estornado_pagamento) as total_estornado
                    FROM Pagamentos p
                    LEFT JOIN (
                        SELECT ep.cd_UGestora, ep.dt_Ano, ep.cd_UnidOrcamentaria, ep.nu_EmpenhoEstorno, 
                               ep.nu_ParcelaEstorno, ep.tp_Lancamento, SUM(vl_Estorno) as estornado_pagamento
                        FROM EstornoPagamento ep
                        GROUP BY ep.cd_UGestora, ep.dt_Ano, ep.cd_UnidOrcamentaria, ep.nu_EmpenhoEstorno, 
                                 ep.nu_ParcelaEstorno, ep.tp_Lancamento
                    ) as est
                    ON 
                        p.cd_UGestora = est.cd_UGestora AND
                        p.dt_Ano = est.dt_Ano AND
                        p.cd_UnidOrcamentaria = est.cd_UnidOrcamentaria AND
                        p.nu_Empenho = est.nu_EmpenhoEstorno AND
                        p.nu_Parcela = est.nu_ParcelaEstorno AND
                        p.tp_Lancamento = est.tp_Lancamento
                    GROUP BY p.cd_UGestora, p.dt_Ano, p.cd_UnidOrcamentaria, p.nu_Empenho
                 ) as Pagamentos_group
            USING (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho)
            WHERE e.dt_Ano BETWEEN %d AND %d AND 
                  cd_Credor IN (%s)
                 ')

    query <- template %>%
        sprintf(ano_inicial, ano_final, paste(lista_cnpjs, collapse = ", ")) %>%
        sql()
    
    empenhos <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(empenhos)
}

# Esta função executa uma consulta que demora um tempo considerável dependendo da entrada. Opte por executar a função carrega_empenhos_data_limite
#' @description Carrega a lista de empenhos realizados em um intervalo de tempo
#' @param data_limite_superior Data limite para o cálculo do total de pagamentos acumulados (considerando estornos)
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações do empenho, do valor de pagamentos associados a este empenho e o valor estornado associado aos pagamentos
carrega_empenhos_data <- function(data_limite_superior, ano_inicial = 2014, ano_final = 2014, cnpjs_datas_contratos) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)
    
    lista_cnpjs <- cnpjs_datas_contratos %>% filter(data_inicio == data_limite_superior) %>% distinct(nu_CPFCNPJ) %>% pull(nu_CPFCNPJ)
    
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")
    
    template <- ('
            SELECT cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, 
                   total_pago, total_estornado
            FROM Empenhos e
            INNER JOIN (
	            SELECT p.cd_UGestora, p.dt_Ano, p.cd_UnidOrcamentaria, p.nu_Empenho, SUM(vl_Pagamento) as total_pago, SUM(estornado_pagamento) as total_estornado
                    FROM Pagamentos p
                    LEFT JOIN (
                        SELECT ep.cd_UGestora, ep.dt_Ano, ep.cd_UnidOrcamentaria, ep.nu_EmpenhoEstorno, 
                               ep.nu_ParcelaEstorno, ep.tp_Lancamento, SUM(vl_Estorno) as estornado_pagamento
                        FROM EstornoPagamento ep
                        WHERE STR_TO_DATE(ep.dt_Estorno, "%%Y-%%m-%%d") < STR_TO_DATE("%s", "%%Y-%%m-%%d")
                        GROUP BY ep.cd_UGestora, ep.dt_Ano, ep.cd_UnidOrcamentaria, ep.nu_EmpenhoEstorno, 
                                 ep.nu_ParcelaEstorno, ep.tp_Lancamento
                    ) as est
                    ON 
                        p.cd_UGestora = est.cd_UGestora AND
                        p.dt_Ano = est.dt_Ano AND
                        p.cd_UnidOrcamentaria = est.cd_UnidOrcamentaria AND
                        p.nu_Empenho = est.nu_EmpenhoEstorno AND
                        p.nu_Parcela = est.nu_ParcelaEstorno AND
                        p.tp_Lancamento = est.tp_Lancamento
                    WHERE STR_TO_DATE(p.dt_Pagamento, "%%Y-%%m-%%d") < STR_TO_DATE("%s", "%%Y-%%m-%%d")
                    GROUP BY p.cd_UGestora, p.dt_Ano, p.cd_UnidOrcamentaria, p.nu_Empenho
                 ) as Pagamentos_group
            USING (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho)
            WHERE e.dt_Ano BETWEEN %d AND %d AND 
                  cd_Credor IN (%s)
                 ')

    query <- template %>%
        sprintf(data_limite_superior, data_limite_superior, ano_inicial, ano_final, paste(lista_cnpjs, collapse = ", ")) %>%
        sql()
    
    empenhos <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    
    return(empenhos)
}

#' @description Carrega a lista de empenhos realizados em um intervalo de tempo
#' @param data_limite_superior Data limite para o cálculo do total de pagamentos acumulados (considerando estornos)
#' @param ano_inicial Ano inicial do intervalo de tempo
#' @param ano_final Ano final do intervalo de tempo
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações do empenho, do valor de pagamentos associados a este empenho e o valor estornado associado aos pagamentos
carrega_empenhos_data_limite <- function(ano_inicial = 2014, ano_final = 2014, cnpjs_datas_contratos) {
    library(tidyverse)
    library(DBI)
    library(RMySQL)

    date()
    sagres <- dbConnect(RMySQL::MySQL(), dbname = "sagres_municipal", group = "ministerio-publico", username = "shiny")

    ## Lista de CNPJS distintos
    lista_cnpjs <- cnpjs_datas_contratos %>% 
        distinct(nu_CPFCNPJ) %>% 
        pull(nu_CPFCNPJ)
    
    template <- ('
                SELECT cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor
                FROM Empenhos e
                WHERE e.dt_Ano BETWEEN %d AND %d AND 
                  cd_Credor IN (%s)
                 ')
    
    query <- template %>%
        sprintf(ano_inicial, ano_final, paste(lista_cnpjs, collapse = ", ")) %>%
        sql()
    
    ## Carrega empenhos realizados entre o ano inicial e o ano final
    empenhos <- tbl(sagres, query) %>%
        compute(name = "emp") %>% 
        collect(n = Inf)

    template <- ('
                  SELECT p.cd_UGestora, p.dt_Ano, p.cd_UnidOrcamentaria, p.nu_Empenho, p.nu_Parcela, p.tp_Lancamento, dt_Pagamento, vl_Pagamento
                  FROM Pagamentos p
                  INNER JOIN emp
                  USING (cd_UGestora, nu_Empenho, cd_UnidOrcamentaria, dt_Ano)
                 ')
    
    query <- template %>%
        sql()
    
    ## Carrega os pagamentos associados aos empenhos
    pagamentos <- tbl(sagres, query) %>%
        compute(name = "pag") %>% 
        collect(n = Inf)
    
    template <- ('
                  SELECT ep.cd_UGestora, ep.cd_UnidOrcamentaria, ep.nu_EmpenhoEstorno, ep.nu_ParcelaEstorno, ep.tp_Lancamento, ep.dt_Ano,
                         ep.dt_Estorno, ep.vl_Estorno
                  FROM EstornoPagamento ep
                  INNER JOIN pag
                  ON
                    ep.cd_UGestora = pag.cd_UGestora AND
                    ep.cd_UnidOrcamentaria = pag.cd_UnidOrcamentaria AND
                    ep.nu_EmpenhoEstorno = pag.nu_Empenho AND
                    ep.nu_ParcelaEstorno = pag.nu_Parcela AND
                    ep.tp_Lancamento = pag.tp_Lancamento AND
                    ep.dt_Ano = pag.dt_Ano
                 ')
    
    query <- template %>%
        sql()
    
    ## Carrega os estornos associados aos pagamentos
    estornos_pagamento <- tbl(sagres, query) %>%
        collect(n = Inf)
    
    DBI::dbDisconnect(sagres)
    date()
    
    ## Lista de datas distintas nas quais existem contratos iniciando
    datas_lista <- cnpjs_datas_contratos %>% 
        distinct(data_inicio) %>% 
        pull(data_inicio)
    
    date()
    
    ## Carrega as informações de empenho 
    ## (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, total_pago, total_estornado)
    empenhos_data <- tibble(data = datas_lista) %>%
        mutate(dados = map(
            data,
            empenhos_credores_data,
            empenhos,
            pagamentos,
            estornos_pagamento,
            cnpjs_datas_contratos
        )) %>% 
        unnest(dados)
    date()
    
    return(empenhos_data)
}

#' @description Cruza informações sobre empenhos, pagamentos e estornos a partir de uma data de limite. Retorna todos os empenhos até esta data.
#' @param data_limite_superior Data limite para a data do pagamento e do estorno
#' @param empenhos Data frame com todos os empenhos recuperados do SAGRES
#' @param pagamentos Data frame com todos os pagamentos recuperados do SAGRES
#' @param estornos_pagamento Data frame com todos os estornos de pagamentos recuperados do SAGRES
#' @param cnpjs_datas_contratos Lista de CNPJ's e de datas de início de contrato para o cálculo das informações de fornecimento.
#' @return Data frame com informações do empenho, do valor de pagamentos associados a este empenho e o valor estornado associado aos pagamentos
#' Data frame retornado (cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Licitacao, tp_Licitacao, cd_Credor, no_Credor, total_pago, total_estornado)
empenhos_credores_data <- function(data_limite_superior, empenhos, pagamentos, estornos_pagamento, cnpjs_datas_contratos) {
    library(tidyverse)
    
    lista_cnpjs <- cnpjs_datas_contratos %>% 
        filter(data_inicio == data_limite_superior) %>% 
        distinct(nu_CPFCNPJ) %>% 
        pull(nu_CPFCNPJ)
    
    empenhos_credor <- empenhos %>% 
        filter(cd_Credor %in% lista_cnpjs)
    
    pagamentos_data <- pagamentos %>% 
        filter(dt_Pagamento < data_limite_superior) %>% 
        inner_join(empenhos_credor %>% select(cd_UGestora, nu_Empenho, cd_UnidOrcamentaria, dt_Ano), 
                   by = c("cd_UGestora", "nu_Empenho", "cd_UnidOrcamentaria", "dt_Ano"))
    
    estornos_pagamento_data <- estornos_pagamento %>% 
        filter(dt_Estorno < data_limite_superior)
    
    pagamentos_data_merge <- pagamentos_data %>% 
        left_join(estornos_pagamento_data, by = c("cd_UGestora" = "cd_UGestora", "cd_UnidOrcamentaria" = "cd_UnidOrcamentaria",
                                                  "nu_Empenho" = "nu_EmpenhoEstorno", "nu_Parcela" = "nu_ParcelaEstorno", 
                                                  "tp_Lancamento" = "tp_Lancamento", "dt_Ano" = "dt_Ano")) %>% 
        mutate(vl_Estorno = replace_na(vl_Estorno, 0)) %>% 
        group_by(cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho, nu_Parcela, tp_Lancamento) %>% 
        summarise(vl_Pagamento = first(vl_Pagamento),
                  total_estornado = sum(vl_Estorno)) %>% 
        ungroup() %>% 
        select(cd_UGestora, nu_Empenho, cd_UnidOrcamentaria, dt_Ano, total_pago = vl_Pagamento, total_estornado)
    
    empenhos_credor_merge <- empenhos_credor %>% 
        inner_join(pagamentos_data_merge, by = c("cd_UGestora", "nu_Empenho", "cd_UnidOrcamentaria", "dt_Ano")) %>% 
        
        group_by(cd_Credor, cd_UGestora, dt_Ano, cd_UnidOrcamentaria, nu_Empenho) %>% 
        summarise(nu_Licitacao = first(nu_Licitacao),
                  tp_Licitacao = first(tp_Licitacao),
                  no_Credor = first(no_Credor),
                  total_pago = sum(total_pago),
                  total_estornado = sum(total_estornado)) %>% 
        ungroup()
    
    return(empenhos_credor_merge)
}
