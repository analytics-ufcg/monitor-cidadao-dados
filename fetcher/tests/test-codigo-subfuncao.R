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

codigo_subfuncao <- fetch_codigo_subfuncao(sagres_2017)

DBI::dbDisconnect(sagres_2017)

test_that("Is dataframe", {
  expect_true(is.data.frame(codigo_subfuncao))
})

test_that("Not Empty", {
  expect_true(nrow(codigo_subfuncao) != 0)
})

test_that("fetch_codigo_subfuncao()", {
 expect_true(all(sapply(codigo_subfuncao, class) %in% COLNAMES_CODIGO_SUBFUNCAO))
})