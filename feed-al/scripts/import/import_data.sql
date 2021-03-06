\copy municipio FROM '/data/municipios.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy licitacao FROM '/data/licitacoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy contrato FROM '/data/contratos.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy empenho FROM PROGRAM 'awk FNR-1 /data/empenhos/*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
\copy participante FROM '/data/participantes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy proposta FROM '/data/propostas.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy pagamento FROM PROGRAM 'awk FNR-1 /data/pagamentos/*.csv | cat' WITH NULL AS 'NA' DELIMITER ',' CSV;
\copy contrato_mutado FROM '/data/contratos_mutados.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy estorno_pagamento FROM '/data/estorno_pagamento.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
