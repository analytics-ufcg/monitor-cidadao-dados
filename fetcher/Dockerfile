FROM rocker/tidyverse:3.6.1

WORKDIR /app

## Cria arquivo para indicar raiz do repositório (Usado pelo pacote here)
RUN touch .here

RUN sudo apt -y install openssh-server

##Instala drivers do SQLServer
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
        apt-transport-https \
        curl \
        gnupg \
        unixodbc-dev \
 && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && ACCEPT_EULA=Y apt-get install --yes --no-install-recommends msodbcsql17 \
 && install2.r odbc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/*
## Finaliza instalacao dos drivers SQLServers

WORKDIR ../root/.ssh

COPY ./credenciais/config ./ \
	 ./credenciais/id_rsa.pub ./ \
	 ./credenciais/id_rsa ./ \
	 ./credenciais/known_hosts ./ 

RUN chown root ./config && \
    chmod 400 ./id_rsa

WORKDIR ../../app/fetcher

## Instala dependências
RUN R -e "install.packages(c('DBI', 'odbc', 'optparse', 'here', 'crayon', 'testthat', 'readxl'), repos='http://cran.rstudio.com/')"

EXPOSE 8787
