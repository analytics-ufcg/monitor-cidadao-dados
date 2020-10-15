\copy licitacao FROM PROGRAM 'awk FNR-1 /data/rs/licitacoes/*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
\copy contrato FROM PROGRAM 'awk FNR-1 /data/rs/contratos/*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;

