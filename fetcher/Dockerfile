FROM rocker/tidyverse:3.6.1

WORKDIR /app

## Cria arquivo para indicar raiz do repositório (Usado pelo pacote here)
RUN touch .here

RUN sudo apt -y install openssh-server
	
WORKDIR ../root/.ssh

COPY ./credenciais/config ./ \
	 ./credenciais/id_rsa.pub ./ \
	 ./credenciais/id_rsa ./ \
	 ./credenciais/known_hosts ./ 

RUN chown root ./config && \
    chmod 400 ./id_rsa

WORKDIR ../../app/fetcher

## Instala dependências
RUN R -e "install.packages(c('DBI', 'RMySQL', 'here', 'crayon', 'testthat'), repos='http://cran.rstudio.com/')"

EXPOSE 8787