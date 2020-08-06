\copy municipio FROM '/data/municipios.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy licitacao FROM '/data/licitacoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy contrato FROM '/data/contratos.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy previsao FROM '/data/previsoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy empenho FROM PROGRAM 'awk FNR-1 /data/empenhos/*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
\copy participante FROM '/data/participantes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy pagamento FROM '/data/pagamentos.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;