\copy municipio FROM '/data/municipios.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy licitacao FROM '/data/licitacoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

