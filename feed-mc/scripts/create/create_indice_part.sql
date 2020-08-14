DROP TABLE IF EXISTS indice_part;

CREATE TABLE IF NOT EXISTS "indice_part" (
    "id_indice" VARCHAR(50),
    ind_valores_treino INTEGER,
    ind_valores_teste INTEGER,
    ind_valores_vigentes INTEGER,
    PRIMARY KEY("id_indice")
);