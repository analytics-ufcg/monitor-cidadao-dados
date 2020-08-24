DROP TABLE IF EXISTS previsao_prod;

CREATE TABLE IF NOT EXISTS "previsao_prod" (
    "id_previsao" VARCHAR(50),
    "data_previsao" DATE,
    "id_experimento" VARCHAR(50),
    "id_contrato" VARCHAR(50),
    "previsao_risco" DECIMAL,
    PRIMARY KEY("id_previsao"),
    CONSTRAINT previsao_prod_key UNIQUE (data_previsao, id_contrato),
    FOREIGN KEY("id_experimento") REFERENCES experimento("id_experimento") ON DELETE CASCADE ON UPDATE CASCADE

);