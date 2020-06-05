
# Monitor Cidadão

Repositório do projeto Monitor Cidadão. Ufcg + Laboratório Analytics + CampinaTec.

## Módulo de Busca e Processamento
Os serviços deste módulo utilizam docker para configuração do ambiente e execução do script.

Instale o  [docker](https://docs.docker.com/install/)  e o  [docker-compose](https://docs.docker.com/compose/install/). Tenha certeza que você também tem o  [Make](https://www.gnu.org/software/make/)  instalado.

Obs: todos comandos citados nesse README utilizam o make como facilitador para execução. Caso você queira executar os comandos docker diretamente confira o código correspondende a seu comando no arquivo  `Makefile`  na raiz desse repositório.

### Setup

#### Acesso à VM

Para que nossos serviços tenham o devido acesso aos dados (hospedados em uma Máquina Virtual remota e privada), preencha os arquivos em  `fetcher/credenciais`  com as credenciais e chaves necessárias.

#### Acesso aos Bancos

Crie uma cópia do arquivo .env.sample no diretório raiz desse repositório e renomeie para .env (deve também estar no diretório raiz desse repositório)

Preencha as variáveis contidas no .env.sample também para o .env. Altere os valores conforme sua necessidade.

#### Serviços

Faça o build das imagens docker com as dependências:

sudo make build

Execute os serviços:

sudo make run

## Executando back-end (server)

A execução do back-end ainda não está sendo feita com o auxílio do docker. Dessa forma, antes de tudo, garanta que você tenha instalado em sua máquina o **nodejs**, **npm** e o **nodemon**.

Adicione as informações do SQLServer no .env (essas informações estão no arquivo '07 - Instruções e Acessos Monitor Cidadão') .
>SQLSERVER_SAGRES19_HOST
SQLSERVER_SAGRES19_Database
SQLSERVER_SAGRES19_USER
SQLSERVER_SAGRES19_PASS
SQLSERVER_SAGRES19_PORT

Agora, para executar, bastar entrar na pasta **server** via terminal e inserir o comando:
 > nodemon
 
 Você pode testar se tudo deu certo com o link abaixo:
 > [http://localhost:3000/api/licitacoes](http://localhost:3000/api/licitacoes)
 


