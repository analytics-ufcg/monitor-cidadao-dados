DROP TABLE IF EXISTS municipio_sagres;

CREATE TABLE IF NOT EXISTS "municipio_sagres" ( 
    "cd_municipio" VARCHAR(3),
    "cd_ibge" VARCHAR(7),
    PRIMARY KEY("cd_municipio"),
    CONSTRAINT municipio_key UNIQUE (cd_municipio),
    FOREIGN KEY("cd_ibge") REFERENCES localidade_ibge("cd_ibge") ON DELETE CASCADE ON UPDATE CASCADE

);