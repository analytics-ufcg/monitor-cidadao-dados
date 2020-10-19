
## Monitor Cidadão - Camada de Dados
O Monitor Cidadão é um sistema desenvolvido através da parceria entre a CampinaTec e o laboratório Analytics, da Universidade Federal de Campina Grande-PB, com finalidade de possibilitar aos cidadãos o acompanhamento dos contratos realizados pelos municípios do estado da Paraíba. 

## Camada de Dados

A Camada de dados consiste em uma arquitetura que fornece meios para a extração e tratamento de dados provindos de diversas fontes. Essa estrutura é formada por quatro subcategorias distintas com suas próprias responsabilidades:

* **Fetch** : responsável por buscar os dados em suas fontes;
* **Tradutor**:  responsável por traduzir os dados para um formato tabular - especialmente útil para dados que são disponibilizados em formato *.csv*;
* **Transformador**: realiza manipulações nos dados como, por exemplo, joins;
* **Preditor**: encapsula diversas funções para a realização das predições em torno dos contratos públicos.

Abaixo é apresentado o fluxo de dados geral das camadas citadas acima.

![Fluxo de dados](https://github.com/analytics-ufcg/monitor-cidadao/blob/dev/img/data-pipeline.png?raw=true)


## Tecnologias/framework usadas

<b>Desenvolvido em: </b>
- [R](https://www.r-project.org/)

## Setup
Os serviços deste módulo utilizam docker para configuração do ambiente e execução do script. Instale o  [docker](https://docs.docker.com/install/), [docker-compose](https://docs.docker.com/compose/install/) e tenha certeza que você também tem o  [Make](https://www.gnu.org/software/make/)  instalado.

Adicione os seguintes arquivos com variáveis de ambiente e credenciais:

 - Adicione o arquivo [*.env*](https://doc-08-6s-docs.googleusercontent.com/docs/securesc/qph2akfo04c7b0qviq0omfmbqectvj9r/90pf21leaqv39j5e5hjskd5tf70b2ekb/1593364725000/02066499184667500127/02066499184667500127/1cnKe1G0nO0SukbyHM06iVZ0t1CcPv0H1?e=download&authuser=0&nonce=v1c2japd9r2tu&user=02066499184667500127&hash=kddfpumuv1enicl51mbg80p5a7f5fdj0) na pasta raiz do projeto;
 - Adicione os arquivos [*config*, *id_rsa*, *id_rsa.pub* e *known_hosts*](https://drive.google.com/drive/u/0/folders/1QgxQlKgNCvGtUrFAXSl-mm0S3z2GZ2XV) na pasta fetcher/credenciais.


## Como usar?
Nesta camada o make é utilizado como facilitador para execução. Abaixo estão descritos os passos necessários para importar os dados para o banco de dados Analytics (também chamado de AL_DB) e Monitor Cidadão (também chamado de MC_DB):

<b> Passos comuns a ambos os bancos:</b>

 1. Faça o build das imagens necessárias com `sudo make build`;
 2. Crie e inicie os containers do docker com `sudo make up`;
 3. Obtenha os dados através do `sudo make fetch-data-sagres` e `sudo make fetch-data-tce-rs ano=<2016,2017, 2018 , 2019, 2020 ou todos>`. Nesta etapa você também pode testar a integridade dos dados obtidos utilizando os testes unitários de cada tabela com `sudo docker exec -it fetcher sh -c "Rscript tests/<nome-da-tabela>.R"`;
 4. Traduza e transforme os dados colhidos `sudo make transform-data` e `sudo make transform-data-tce-rs`;

<b> Para o AL_DB: </b>

 5. Crie as tabelas no banco AL_DB com `sudo make feed-al-create`;
 6. Agora importe os dados para as tabelas do banco com `sudo make feed-al-import` e `sudo make feed-al-import-tce-rs`;
 7. Você pode verificar se a(s) tabela(s) estão no banco com `sudo make feed-al-shell` e `\dt`.

<b> Geração das previsões: </b>

 8. Gere as features da previsão com `sudo make gera-feature vigencia=<encerrados, vigentes e todos> data_range_inicio=<2012-01-01> data_range_fim=<2018-01-01>`;
 9. Gere o feature set da previsão com `sudo make gera-feature-set tipo_construcao_features=<recentes>`;
 10. Gere o experimento com as informações do risco com `sudo make gera-experimento tipo_contrucao_feature_set=<recentes>`.

<b> Para o MC_DB: </b>

 11. Crie as tabelas no banco MC_DB com `sudo make feed-mc-create`;
 12. Importe os dados das features para as tabelas do banco com `sudo make feed-mc-import-feature`;
 13. Importe os dados do features set para as tabelas do banco com `sudo make feed-mc-import-feature-set`;
 14. Agora importe os dados do experimento para as tabelas do banco com `sudo make feed-mc-import-experimento`;
 15. Você pode verificar se a(s) tabela(s) estão no banco com `sudo make feed-mc-shell` e `\dt`.


Caso você queira executar os comandos docker diretamente, confira o código correspondente a seu comando no arquivo  `Makefile`. Abaixo estão todos os comandos disponíveis para serem executados com `sudo make <Comando>`:
Comando | Descrição
------------ | -------------
help |Mostra esta mensagem de ajuda
build | Realiza o build das imagens com as dependências necessárias para a obtenção dos dados.
up  | Cria e inicia os containers.
stop | Para todos os serviços.
clean-volumes | Para e remove todos os volumes.
enter-fetcher-container  | Abre cli do container fetcher
fetch-data | Obtem dados
fetch-data-tce-rs | Obtem dados do TCE-RS
enter-transformer-container | Abre cli do container transformador
transform-data | Traduz e transforma os dados colhidos
transform-data-tce-rs | Traduz e transforma os dados do TCE-RS
enter-feed-al-container | Abre cli do container feed-al
feed-al-create | Cria as tabelas do Banco de Dados Analytics
feed-al-import | Importa dados para as tabelas do Banco de Dados Analytics
feed-al-import-tce-rs | Importa dados do RS para as tabelas do Banco de Dados Analytics
feed-al-clean | Dropa as tabelas do Banco de Dados Analytics
feed-al-shell | Acessa terminal do Banco de Dados Analytics
gera-feature | Gera features
gera-feature-set | Gera conjunto de features
gera-experimento | Gera previsão de risco
enter-feed-mc-container | Abre cli do container feed-mc
feed-mc-create | Cria as tabelas do Banco de Dados Monitor Cidadão
feed-mc-import-feature | Importa features para o Banco de dados Monitor Cidadão
feed-mc-import-feature-set | Importa features set para o Banco de dados Monitor Cidadão
feed-mc-import-experimento | Importa experimento para o Banco de dados Monitor Cidadão
feed-mc-clean | Dropa as tabelas do Banco de Dados Monitor Cidadão
feed-mc-shell | Acessa terminal do Banco de Dados Monitor Cidadão

## License

GNU Affero General Public License v3.0 © [Monitor Cidadão]()
