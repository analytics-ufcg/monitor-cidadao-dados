#  Monitor Cidadão
Repositório do projeto Monitor Cidadão. Ufcg + Laboratório Analytics + CampinaTec.

## Antes de tudo

Todos os serviços utilizados pelo Monitor Cidadão utilizam docker para configuração do ambiente e execução do script.

Instale o [docker](https://docs.docker.com/install/) e o [docker-compose](https://docs.docker.com/compose/install/). Tenha certeza que você também tem o [Make](https://www.gnu.org/software/make/) instalado.

Obs: todos comandos citados nesse README utilizam o make como facilitador para execução. Caso você queira executar os comandos docker diretamente confira o código correspondende a seu comando no arquivo `Makefile` na raiz desse repositório.


### Setup

Para que nossos serviços tenham o devido acesso aos dados (hospedados em uma Máquina Virtual remota e privada), preencha os arquivos em `fetcher/credenciais` com as credenciais e chaves necessárias.

Faça o build das imagens docker com as dependências:

```shell
sudo make build
```

Execute os serviços:

```shell
make make run
```

### Busca e Processamento

O processamento de dados do Monitor Cidadão tem, atualmente, os seguintes passos:

1. Fetch dos dados do SAGRES do TCE-PB

Para realizar estes passos siga o tutorial:

#### 1. Fetcher




