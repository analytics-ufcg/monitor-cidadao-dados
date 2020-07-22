library(dplyr)
library(here)
library(RMySQL)

sagres <- src_mysql('sagres_municipal', group='ministerio-publico', username = "empenhados", password = NULL)

query <- sql("SELECT cd_credor CNPJ, max(dt_Ano) dt_Ano FROM Empenhos GROUP BY cd_credor")

empresas <- tbl(sagres, query) %>%
  collect(n = Inf)

write.csv(empresas, "data/empresas_all.csv")
