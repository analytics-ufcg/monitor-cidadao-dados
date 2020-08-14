DROP TABLE IF EXISTS experimento;

CREATE TABLE IF NOT EXISTS "experimento" (
    "id_experimento" VARCHAR(50),
    "data" DATE,
    "objeto_modelo" VARCHAR(50),
    "tipo_modelo" VARCHAR(50),
    "modelo_hiperparams" VARCHAR(50),
    "tipo_balanceamento" VARCHAR(50),
    "indice_part" VARCHAR(50),
    "feature_set" VARCHAR(50),
    "previsoes_teste" VARCHAR(50),
    "hash_codigo_gerador_modelo" VARCHAR(50),
    PRIMARY KEY("id_experimento"),
    FOREIGN KEY("indice_part") REFERENCES indice_part("id_indice") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY("feature_set") REFERENCES feature_set("id_feature_set") ON DELETE CASCADE ON UPDATE CASCADE
);