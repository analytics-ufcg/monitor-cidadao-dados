DROP TABLE IF EXISTS indice_part;

CREATE TABLE IF NOT EXISTS "indice_part" (
    "id_experimento" VARCHAR(50),
    "index_treino" TEXT,
    PRIMARY KEY("id_experimento")
);