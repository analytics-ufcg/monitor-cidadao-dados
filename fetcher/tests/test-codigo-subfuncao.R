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

codigo_subfuncao <- fetch_codigo_subfuncao(sagres)

DBI::dbDisconnect(sagres)

test_that("Is dataframe", {
  expect_true(is.data.frame(codigo_subfuncao))
})

test_that("Not Empty", {
  expect_true(nrow(codigo_subfuncao) != 0)
})

test_that("fetch_codigo_subfuncao()", {
 expect_true(all(sapply(codigo_subfuncao, class) %in% COLNAMES_CODIGO_SUBFUNCAO))
})