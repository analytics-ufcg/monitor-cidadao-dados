

-- COPIA DADOS DO INDICE_PART.CSV
\copy indice_part FROM '/data/indice_part.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
-- COPIA DADOS DO EXPERIMENTO.CSV
\copy experimento FROM '/data/experimento.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

-- -- COPIA DADOS DO PREVISAO_PROD.CSV
-- \copy previsao_prod FROM '/data/previsao_prod.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;