DROP TABLE IF EXISTS localidade_ibge;

CREATE TABLE IF NOT EXISTS "localidade_ibge" ( 
    "cd_ibge" VARCHAR(7),
    "uf" VARCHAR(2),
    "nome_uf" VARCHAR(200),
    "mesorregiao_geografica" VARCHAR(2),
    "nome_mesorregiao" VARCHAR(200),
    "microrregiao_geografica" VARCHAR(2),
    "nome_microrregiao" VARCHAR(200),
    "municipio" VARCHAR(6),
    "nome_municipio" VARCHAR(200),
    PRIMARY KEY("cd_ibge")
);