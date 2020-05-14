#' @description Calcula o recall para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (predicao, status)
#' @param col_predicao Nome da coluna (string) com a predição do modelo.  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor do recall
recall <- function(dados, col_predicao, col_status) {
    library(tidyverse)
    
    predicao <- sym(col_predicao)
    status <- sym(col_status)
    
    relevantes <- dados %>%
        filter(!!status == 1)
    
    verdadeiros_positivos <- relevantes %>%
        filter(!!predicao == 1)
    
    if (nrow(relevantes) > 0)
        return(nrow(verdadeiros_positivos)/nrow(relevantes))
    return(0)
}

#' @description Calcula a precisão para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (predicao, status)
#' @param col_predicao Nome da coluna (string) com a predição do modelo.  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor da precisão
precision <- function(dados, col_predicao, col_status) {
    library(tidyverse)
    
    predicao <- sym(col_predicao)
    status <- sym(col_status)
    
    selecionados <- dados %>%
        filter(!!predicao == 1)
    
    verdadeiros_positivos <- dados %>%
        filter(!!predicao == 1, !!status == 1)
    
    if (nrow(selecionados) > 0)
        return(nrow(verdadeiros_positivos)/nrow(selecionados))
    return(0)
}

#' @description Calcula a métrica F1 para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (predicao, status)
#' @param col_predicao Nome da coluna (string) com a predição do modelo.  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor da métrica F1
f1 <- function(dados, col_predicao, col_status) {
    library(tidyverse)
    
    precisao <- precision(dados, col_predicao, col_status)
    revocacao <- recall(dados, col_predicao, col_status)
    
    if ((precisao + revocacao) > 0)
        return( (2 * precisao * revocacao) / (precisao + revocacao)) 
    return(0)
}

#' @description Calcula a métrica AUC para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (predicao, status)
#' @param col_predicao Nome da coluna (string) com a predição do modelo.  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor da métrica AUC
auc_metric <- function(dados, col_predicao, col_status) {
    library(tidyverse)
    library(pROC)
    
    roc <- roc(dados[[col_status]], dados[[col_predicao]])
    
    auc_score <- auc(roc)
    
    return(auc_score)
}

#' @description Calcula a métrica NDCG para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (posicao no ranking, status)
#' @param col_id Nome da coluna (string) com a posição no ranking para cada observação  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor da métrica NDCG
ndcg <- function(dados, col_id, col_status) {
    library(tidyverse)
    library(StatRank)
    
    niveis_relevancia <- c(ifelse(dados[[col_status]] == "1", 1, 0))
    
    ranking <- dados[[col_id]]
    
    ndcg <- Evaluation.NDCG(ranking, niveis_relevancia)
    
    return(ndcg)
}
