DROP TABLE IF EXISTS contrato_mutado;

CREATE TABLE IF NOT EXISTS "contrato_mutado" (
    "id_contrato" VARCHAR(50),
    "nu_contrato" VARCHAR(20),
    "jurisdicionado" VARCHAR(200),
    "cod_jurisdicionado" INTEGER,
    "cd_u_gestora" INTEGER,
    "modalidade_licitacao" varchar(500),
    "nu_licitacao" VARCHAR(50),
    "nu_cpfcnpj" VARCHAR(14),
    "tipo_alteracao" VARCHAR(30),
    "data_alteracao" VARCHAR(30),
    "cd_municipio" VARCHAR(3),
    "no_municipio" VARCHAR(30),
    "de_u_gestora" VARCHAR(100),
    "data_atualizacao" VARCHAR(30),
    PRIMARY KEY("id_contrato", "data_alteracao"),
    CONSTRAINT contrato_mutado_key UNIQUE (cd_u_gestora, nu_licitacao, nu_contrato)
);
