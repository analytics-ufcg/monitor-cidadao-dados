-- ######################### FEATURE SET #########################
-- CRIA TABELA TEMPORARIA COM PARA AS INFORMACOES RECEBIDAS DO FEATURES_SET
CREATE TEMPORARY TABLE tmp_feature_set
(
 "id_feature_set" VARCHAR(50),
  "timestamp" TIMESTAMP,	
  "features_descricao" json
);

-- COPIA DADOS DO CSV
\copy tmp_feature_set FROM PROGRAM 'awk FNR-1 /data/feature_set/feature_set*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- INSERE FEATURE_SET
INSERT INTO feature_set (id_feature_set, timestamp, features_descricao) 
SELECT *
FROM   tmp_feature_set 
ON     CONFLICT (id_feature_set) DO NOTHING;

-- REMOVE A TABELA TEMPORARIA
DROP TABLE tmp_feature_set;

-- ######################### FEATURE SET HAS FETURE #########################
-- CRIA TABELA TEMPORARIA COM PARA AS INFORMACOES RECEBIDAS DO FEATURES_SET_HAS_FEATURE
CREATE TEMPORARY TABLE tmp_feature_set_has_feature
(
  "id_feature" VARCHAR(50),
  "id_feature_set" VARCHAR(50)
);

-- COPIA DADOS DO FEATURE_SET_HAS_FEATURE.CSV
\copy tmp_feature_set_has_feature FROM PROGRAM 'awk FNR-1 /data/feature_set_has_feature/feature_set_has_feature*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

INSERT INTO feature_set_has_feature (id_feature, id_feature_set) 
SELECT DISTINCT *
FROM   tmp_feature_set_has_feature 
ON     CONFLICT (id_feature, id_feature_set) DO NOTHING;

DROP TABLE tmp_feature_set_has_feature;