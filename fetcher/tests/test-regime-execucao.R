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

regime_execucao <- fetch_regime_execucao(sagres_2017)

DBI::dbDisconnect(sagres_2017)

test_that("Is dataframe", {
  expect_true(is.data.frame(regime_execucao))
})

test_that("Not Empty", {
  expect_true(nrow(regime_execucao) != 0)
})

test_that("fetch_regime_execucao()", {
  expect_true(all(sapply(regime_execucao, class) %in% COLNAMES_REGIME_EXECUCAO))
})