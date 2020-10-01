
# Fetcher

Este diretório contém as funções e rotinas necessárias para a busca e obtenção dos dados utilizados na aplicação Monitor Cidadão, compondo a camada *Fetcher* da mesma.

Os dados serão salvos sem qualquer tratamento para posterior processamento.

## Bases de dados utilizadas para o desenvolvimento dos modelos do Monitor Cidadão

### SAGRES
O Sistema de Acompanhamento da Gestão e Recursos da Sociedade (SAGRES) é um sistema voltado para o acompanhamento de atos (eg. compras públicas) dos gestores públicos, e permite o acesso de informações sobre a execução orçamentária e financeira da administração estadual, prefeituras e câmaras municipais. Os dados nele contidos estão disponibilizados de forma bruta, ou seja, conforme foram recebidos.

Abaixo está a listagem das tabelas adicionadas ([seguindo as convenções de nomenclaturas](https://martendb.io/documentation/postgres/naming/)):

|  SAGRES| Fetcher | Tradutor | Transformador |  Script Feed | AL_DB|
|:-:|:-:|:-:|:-:|:-:|:-:|
| Aditivos | x | x | x |  |  |
| Codigo_ElementoDespesa | x | x | x |  |  |
| Codigo_Funcao | x | x | x |  |  |
| Codigo_Municipios |  x | x | x | x | municipio |
| Codigo_Subelemento | x | x | x |  |  |
| Codigo_Subfuncao | x | x | x |  |  |
| Codigo_Unidade_Gestora | x | x | x |  |  |
| Contratos |x | x | x | x |  contrato |
| Convenios | x | x | x | |  |
| Empenhos | x | x | x |  |  |
| Estorno Pagamento | x | x | x | x | estorno_pagamento |
| Fornecedores | x | x | x |  |  |
| Licitacao | x | x | x | x | licitacao |
| Pagamentos | x | x | x |  | |
| Participantes | x | x | x | x | participante |
| Propostas | x | x | x | x | proposta |
| RegimeExecucao | x | x | x |  | |
| Tipo_Modalidade_Licitacao | x | x | x |  | |
| Tipo_Objeto_Licitacao | x | x | x |  | |
