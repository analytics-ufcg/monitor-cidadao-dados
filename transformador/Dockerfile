FROM rocker/tidyverse:3.6.1

WORKDIR /app/transformador

## Cria arquivo para indicar raiz do repositório (Usado pelo pacote here)
RUN touch .here

## Instala dependências
RUN R -e "install.packages(c('here', 'testthat', 'digest', 'janitor', 'stringr'), repos='http://cran.rstudio.com/')"
