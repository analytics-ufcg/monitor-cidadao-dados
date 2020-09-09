
-- COPIA DADOS DO INDICE_PART
\copy indice_part FROM PROGRAM 'awk FNR-1 /data/indice_part/indices_exp*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- COPIA DADOS DO EXPERIMENTO
\copy experimento FROM PROGRAM 'awk FNR-1 /data/experimento/experimento*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- COPIA DADOS DA METRICA
\copy metrica FROM PROGRAM 'awk FNR-1 /data/metricas/metricas*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- COPIA DADOS DA PREVISAO PROD
\copy previsao_prod FROM PROGRAM 'awk FNR-1 /data/previsao_prod/previsao_prod*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
