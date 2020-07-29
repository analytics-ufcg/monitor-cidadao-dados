## ---------------------------
## ACESSO AO MARIA DB
##    VM 150.165.15.81

library(tidyverse)
library(DBI)
library(RMySQL)

# Instancia conexão com o BD usando as configurações em ~/.my.cnf
sagres <- dbConnect(MySQL(), dbname = "sagres_municipal", group="ministerio-publico", username="root")

# Listagem de tabelas existentes
src_tbls(sagres)

# Recupera algumas linhas
# head

# Descreve as colunas e seus valores
#glimpse(licitacao)

# Prepara queries em cima dos dados, mas não as executa


sagres <- DBI::dbConnect(RMySQL::MySQL(), 
                    dbname = 'sagres_municipal', 
                    group = 'ministerio-publico', 
                    username = 'root')



## ---------------------------
## ACESSO AO SQLSERVER
##    VM 150.165.15.81



















