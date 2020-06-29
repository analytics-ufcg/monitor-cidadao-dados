DROP TABLE IF EXISTS municipio;

CREATE TABLE IF NOT EXISTS "municipio" ( 
    "cd_municipio" VARCHAR(3),
    "cd_ibge" INTEGER,
    "no_municipio" VARCHAR(30),
    "dt_ano_criacao" DATE,
    "cd_regiao_administrativa" VARCHAR(3),
    "cd_micro_regiao" VARCHAR(3),
    "cd_meso_regiao" VARCHAR(3),
    PRIMARY KEY("cd_municipio"),
    CONSTRAINT municipio_key UNIQUE (cd_municipio)

);