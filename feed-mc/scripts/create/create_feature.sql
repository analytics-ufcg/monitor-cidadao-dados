DROP TABLE IF EXISTS feature;

CREATE TABLE IF NOT EXISTS "feature" ( 
    "id_feature" VARCHAR(50),
    "id_contrato" VARCHAR(50),	
    "nome_feature" VARCHAR(30),	
    "valor_feature" VARCHAR(30),			
    "timestamp" TIMESTAMP,	
    "hash_bases_geradoras" VARCHAR(50),
    "hash_codigo_gerador_feature" VARCHAR(50),
    PRIMARY KEY("id_feature"),
    CONSTRAINT feature_key UNIQUE (id_contrato, nome_feature, hash_bases_geradoras, hash_codigo_gerador_feature)

);