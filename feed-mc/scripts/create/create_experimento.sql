DROP TABLE IF EXISTS experimento;

CREATE TABLE IF NOT EXISTS "experimento" (
    "id_experimento" VARCHAR(50),
    "data_hora" TEXT,
    "algoritmo" VARCHAR(50),
    "modelo" VARCHAR(50),
    "hiperparametros" VARCHAR(50),
    "tipo_balanceamento" VARCHAR(50),
    "fk_indice_part" VARCHAR(50),
    "fk_feature_set" VARCHAR(50),
    "hash_codigo_gerador" VARCHAR(50),
    CONSTRAINT experimento_key UNIQUE ("id_experimento", "algoritmo"),
    FOREIGN KEY("fk_indice_part") REFERENCES indice_part("id_experimento") ON DELETE CASCADE ON UPDATE CASCADE
);