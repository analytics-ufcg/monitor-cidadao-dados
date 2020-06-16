library(testthat)

source(here::here("R/sagres.R"))
source(here::here("R/setup/constants.R"))
source(here::here("R/cols_constants.R"))

sagres_2017 <- DBI::dbConnect(RMySQL::MySQL(),
                              dbname = MYSQL_DB,
                              host = MYSQL_HOST,
                              port = as.numeric(MYSQL_PORT),
                              user = MYSQL_USER,
                              password = MYSQL_PASSWORD)
DBI::dbGetQuery(sagres_2017, "SET NAMES 'utf8'")

codigo_elemento_despesa <- fetch_codigo_elemento_despesa(sagres_2017)

DBI::dbDisconnect(sagres_2017)

test_that("Is dataframe", {
  expect_true(is.data.frame(codigo_elemento_despesa))
})

test_that("Not Empty", {
  expect_true(nrow(codigo_elemento_despesa) != 0)
})

test_that("fetch_codigo_elemento_despesa()", {
  expect_true(all(sapply(codigo_elemento_despesa, class) %in% COLNAMES_CODIGO_FUNCAO))
})
