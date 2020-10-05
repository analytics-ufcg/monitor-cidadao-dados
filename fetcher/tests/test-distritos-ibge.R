library(testthat)

source(here::here("R/ibge.R"))
source(here::here("R/setup/constants.R"))
source(here::here("R/cols_constants.R"))


codigo_localidades_ibge <- fetch_distritos_ibge(DADOS_DISTRITOS_IBGE)


test_that("Is dataframe", {
  expect_true(is.data.frame(codigo_localidades_ibge))
})

test_that("Not Empty", {
  expect_true(nrow(codigo_localidades_ibge) != 0)
})

test_that("fetch_distritos_ibge(DADOS_DISTRITOS_IBGE)", {
  expect_true(all(sapply(codigo_localidades_ibge, class) %in% COLNAMES_CODIGO_LOCALIDADES))
})
