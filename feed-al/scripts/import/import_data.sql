\copy municipio FROM '/data/municipios.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy licitacao FROM '/data/licitacoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy contrato FROM '/data/contratos.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy participante FROM '/data/participantes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;