SQLSERVER_SAGRES19_HOST <- Sys.getenv("SQLSERVER_SAGRES19_HOST")
SQLSERVER_SAGRES19_USER <- Sys.getenv("SQLSERVER_SAGRES19_USER")
SQLSERVER_SAGRES19_Database <- Sys.getenv("SQLSERVER_SAGRES19_Database")
SQLSERVER_SAGRES19_PORT <- Sys.getenv("SQLSERVER_SAGRES19_PORT")
SQLSERVER_SAGRES19_PASS <- Sys.getenv("SQLSERVER_SAGRES19_PASS")


# CONSTANTES DOS DADOS ABERTOS DO TCE-RS
TCE_RS_OPENDATA_CONTRATOS <- "http://dados.tce.rs.gov.br/dados/licitacon/contrato/ano/%s.csv.zip"
TCE_RS_OPENDATA_LICITACOES <- "http://dados.tce.rs.gov.br/dados/licitacon/licitacao/ano/%s.csv.zip"
TCE_RS_OPENDATA_ORGAOS <- "http://dados.tce.rs.gov.br/dados/auxiliar/orgaos_auditados_rs.csv"
TCE_RS_OPENDATA_EMPENHOS <- "http://dados.tce.rs.gov.br/dados/municipal/empenhos/%s.csv.zip"

# CONSTANTES DO IBGE
DADOS_DISTRITOS_IBGE <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/divisao_territorial/2018/DTB_2018.zip"

# CONSTANTES DOS CSVs DO TRAMITA
TRAMITA_PB_DATA_CONTRATOS_2020 <- Sys.getenv("TRAMITA_PB_DATA_CONTRATOS_2020")
TRAMITA_PB_DATA_LICITACOES_2020 <- Sys.getenv("TRAMITA_PB_DATA_LICITACOES_2020")