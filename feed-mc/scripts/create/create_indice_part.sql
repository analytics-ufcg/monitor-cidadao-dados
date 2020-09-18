DROP TABLE IF EXISTS indice_part;

CREATE TABLE IF NOT EXISTS "indice_part" (
    PRIMARY KEY("id_indice")
    "id_experimento" VARCHAR(50),
    "index_treino" TEXT,
    PRIMARY KEY("id_experimento")
);