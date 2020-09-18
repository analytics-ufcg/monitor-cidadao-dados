DROP TABLE IF EXISTS metrica;

CREATE TABLE IF NOT EXISTS "metrica" ( 
    "id_experimento" VARCHAR(50),
    "nome_metrica" VARCHAR(50),	
    "valor_metrica" VARCHAR(50),	
    "modelo" VARCHAR(50),			
    "tipo_metrica" VARCHAR(20),	
    "balanceamento" VARCHAR(50),
    CONSTRAINT metrica_key UNIQUE (id_experimento, nome_metrica, valor_metrica, modelo, tipo_metrica)

);