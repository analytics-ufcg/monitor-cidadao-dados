DROP TABLE IF EXISTS previsao_prod;

CREATE TABLE IF NOT EXISTS "previsao_prod" (
    "id_previsao_prod" VARCHAR(50),
    "id_contrato" VARCHAR(50),
    "id_experimento" VARCHAR(50),
    "risco" DECIMAL,
    "timestamp" VARCHAR(40),
    PRIMARY KEY("id_previsao_prod"),
    CONSTRAINT previsao_prod_key UNIQUE (id_contrato, id_experimento)
);