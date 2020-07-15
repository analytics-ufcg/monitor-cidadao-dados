FROM rocker/tidyverse:3.6.1

WORKDIR /app

## Cria arquivo para indicar raiz do repositório (Usado pelo pacote here)
RUN touch .here

## Copia o .env para uma pasta dentro do conteiner
COPY . .


## Instala dependências
RUN R -e "install.packages(c('DBI', 'odbc', 'here', 'RPostgres'), repos='http://cran.rstudio.com/')"


## Define em qual porta da máquina local o conteiner estará disponível
EXPOSE 9090