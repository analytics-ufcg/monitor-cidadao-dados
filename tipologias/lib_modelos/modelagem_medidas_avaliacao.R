#' @description Calcula o recall para um conjunto de dados
#' @param dados Data Frame com pelo menos duas colunas (predicao, status)
#' @param col_predicao Nome da coluna (string) com a predição do modelo.  
#' @param col_status Nome da coluna (string) com o valor real para a variável de interesse.  
#' @return Valor do recall
recall <- function(dados, col_predicao, col_status) {
    library(tidyverse)
    
    # dados <- teste
    # col_predicao <- "rf_smote_pred"
    # col_status <- "status_tramita"
    # relevantes <- subset(dados, dados[[status]] == 1)
    # verdadeiros_positivos <- subset(relevantes, relevantes[[col_predicao]] == 1)
    
    status <- sym(col_status)
    predicao <- sym(col_predicao)
    
    relevantes <- dados %>%
        dplyr::filter(dados[[status]] == 1)

    verdadeiros_positivos <- relevantes %>%
        dplyr::filter(relevantes[[predicao]] == 1)
    
    if(nrow(relevantes) > 0)
        return(nrow(verdadeiros_positivos)/nrow(relevantes))
    return("fail")
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
        dplyr::filter(!!predicao == 1)
    
    verdadeiros_positivos <- dados %>%
        dplyr::filter(!!predicao == 1, !!status == 1)
    
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
    
    roc <- pROC::roc(as.numeric(as.character(dados[[col_status]])), 
               as.numeric(as.character(dados[[col_predicao]])))
    
    auc_score <- pROC::auc(roc)
    
    return(auc_score)
}


avaliacao <- function(modelo, dados, col_prediction, ground_truth) {
    temp <- data.frame(modelo = c(modelo),
                       F1 = f1(dados, col_prediction, ground_truth),
                       AUC = c(auc_metric(dados, col_prediction, ground_truth)),
                       precision = c(precision(dados, col_prediction, ground_truth)),
                       recall = c(recall(dados, col_prediction, ground_truth)),
                       mcc = c(mccr::mccr(dados[[col_prediction]], dados[[ground_truth]])),
                       TP = c(sum(dados[[ground_truth]] == 1 & dados[[col_prediction]] == 1)),
                       TN = c(sum(dados[[ground_truth]] == 0 & dados[[col_prediction]] == 0)),
                       FP = c(sum(dados[[ground_truth]] == 0 & dados[[col_prediction]] == 1)),
                       FN = c(sum(dados[[ground_truth]] == 1 & dados[[col_prediction]] == 0)),
                       stringsAsFactors = FALSE) %>%
        mutate_if(is.numeric, .funs = ~round(., 3))
    return(temp)
}
