-- CRIA TABELA TEMPORARIA COM PARA AS INFORMACOES RECEBIDAS DO FEATURES.CSV
CREATE TEMPORARY TABLE tmp_feature 
(
    id_feature VARCHAR(50),
    id_contrato VARCHAR(50), 
    nome_feature VARCHAR(30), 
    valor_feature VARCHAR(30), 
    timestamp TIMESTAMP, 
    vigencia DATE,
    hash_bases_geradoras VARCHAR(50), 
    hash_codigo_gerador_feature VARCHAR(50),
    PRIMARY KEY("id_feature")
);

-- COPIA DADOS DO FEATURES.CSV PARA A TABELA TEMPORARIA
\copy tmp_feature FROM '/data/features.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

-- ATUALIZA CADA FEATURE
INSERT INTO feature (id_feature, id_contrato, nome_feature, valor_feature, timestamp, vigencia, hash_bases_geradoras, hash_codigo_gerador_feature) 
SELECT *
FROM   tmp_feature 
ON     CONFLICT (id_feature) DO UPDATE  
SET    timestamp = excluded.timestamp;

-- REMOVE A TABELA TEMPORARIA
DROP TABLE tmp_feature;


 