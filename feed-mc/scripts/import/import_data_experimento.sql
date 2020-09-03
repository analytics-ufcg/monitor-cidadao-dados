
-- COPIA DADOS DO INDICE_PART.CSV
\copy indice_part FROM PROGRAM 'awk FNR-1 /data/indice_part/indices_exp*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- COPIA DADOS DO EXPERIMENTO.CSV
\copy experimento FROM PROGRAM 'awk FNR-1 /data/experimento/experimento*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

-- COPIA DADOS DO EXPERIMENTO.CSV
\copy metrica FROM PROGRAM 'awk FNR-1 /data/metricas/metricas*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
