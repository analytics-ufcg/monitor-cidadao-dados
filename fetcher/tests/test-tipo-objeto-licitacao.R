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

tipo_objeto_licitacao <- fetch_tipo_objeto_licitacao(sagres_2017)

DBI::dbDisconnect(sagres_2017)

test_that("Is dataframe", {
  expect_true(is.data.frame(tipo_objeto_licitacao))
})

test_that("Not Empty", {
  expect_true(nrow(tipo_objeto_licitacao) != 0)
})

test_that("fetch_tipo_objeto_licitacao()", {
  expect_true(all(sapply(tipo_objeto_licitacao, class) %in% COLNAMES_TIPO_OBJETO_LICITACAO))
})