-- CRIA TABELA TEMPORARIA COM PARA AS INFORMACOES RECEBIDAS DO FEATURES.CSV
CREATE TEMPORARY TABLE tmp_feature 
(
    id_feature VARCHAR(50),
    id_contrato VARCHAR(50), 
    nome_feature VARCHAR(30), 
    valor_feature VARCHAR(30), 
    timestamp TIMESTAMP, 
    hash_bases_geradoras VARCHAR(50), 
    hash_codigo_gerador_feature VARCHAR(50)
);

-- COPIA DADOS DO FEATURES.CSV PARA A TABELA TEMPORARIA
\copy tmp_feature FROM PROGRAM 'awk FNR-1 /data/features/features_gather*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;


-- ATUALIZA CADA FEATURE
INSERT INTO feature (id_feature, id_contrato, nome_feature, valor_feature, timestamp, hash_bases_geradoras, hash_codigo_gerador_feature) 
SELECT DISTINCT *
FROM   tmp_feature 
ON     CONFLICT (id_feature) DO UPDATE  
SET    timestamp = excluded.timestamp;

-- REMOVE A TABELA TEMPORARIA
DROP TABLE tmp_feature;

-- -- COPIA DADOS DO FEATURE_SET.CSV
\copy feature_set FROM '/data/feature_set.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
-- -- COPIA DADOS DO FEATURE_SET_HAS_FEATURE.CSV
\copy feature_set_has_feature FROM '/data/feature_set_has_feature.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

-- -- COPIA DADOS DO INDICE_PART.CSV
-- \copy indice_part FROM '/data/indice_part.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
-- -- COPIA DADOS DO EXPERIMENTO.CSV
-- \copy experimento FROM '/data/experimento.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
-- -- COPIA DADOS DO PREVISAO_PROD.CSV
-- \copy previsao_prod FROM '/data/previsao_prod.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;