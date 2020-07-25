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

empenhos <- fetch_empenhos(sagres, '001')
codigo_municipio <- fetch_codigo_municipio(sagres)

DBI::dbDisconnect(sagres)

test_that("Is dataframe", {
  expect_true(is.data.frame(empenhos))
})

test_that("Not Empty", {
  expect_true(nrow(empenhos) != 0)
})

test_that("Contains All Cities", {
  expect_true(nrow(codigo_municipio) == length(list.files("data/empenhos")))
})