library(testthat)

source(here::here("R/sagres.R"))
source(here::here("R/setup/constants.R"))
source(here::here("R/cols_constants.R"))

tryCatch({sagres <- DBI::dbConnect(odbc::odbc(),
                                   Driver = "ODBC Driver 17 for SQL Server",
                                   Database = SQLSERVER_SAGRES19_Database,
                                   Server = paste0(SQLSERVER_SAGRES19_HOST,",", SQLSERVER_SAGRES19_PORT),
                                   UID = SQLSERVER_SAGRES19_USER,
                                   PWD = SQLSERVER_SAGRES19_PASS)
}, error = function(e) print(paste0("Erro ao tentar se conectar ao Banco Sagres (SQLServer): ", e)))

estorno_pagamento <- fetch_estorno_pagamento(sagres)

DBI::dbDisconnect(sagres)

test_that("Is dataframe", {
  expect_true(is.data.frame(estorno_pagamento))
})

test_that("Not Empty", {
  expect_true(nrow(estorno_pagamento) != 0)
})

test_that("fetch_estorno_pagamento()", {
 expect_true(all(sapply(estorno_pagamento, class) %in% COLNAMES_ESTORNO_PAGAMENTO))
})
