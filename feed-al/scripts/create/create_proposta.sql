DROP TABLE IF EXISTS proposta;

CREATE TABLE IF NOT EXISTS "proposta" (
    "id_proposta" VARCHAR(50),
    "id_licitacao" VARCHAR(50),
    "id_participante" VARCHAR(50),
    "cd_u_gestora" INTEGER,
    "dt_ano" SMALLINT,
    "nu_licitacao" VARCHAR(9),
    "tp_licitacao" SMALLINT,
    "cd_item" VARCHAR(5),
    "cd_sub_grupo_item" VARCHAR(9),
    "nu_cpfcnpj" VARCHAR(14),
    "cd_u_gestora_item" INTEGER,
    "nu_contrato" VARCHAR(9),
    "qt_ofertada" INTEGER,
    "vl_ofertado" DECIMAL,
    "st_proposta" SMALLINT,
    "dt_mes_ano" VARCHAR(6),
    PRIMARY KEY("id_proposta"),
    CONSTRAINT proposta_key UNIQUE (cd_u_gestora, nu_licitacao, tp_licitacao, nu_cpfcnpj),
    FOREIGN KEY("id_licitacao") REFERENCES licitacao("id_licitacao") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY("id_participante") REFERENCES participante("id_participante") ON DELETE CASCADE ON UPDATE CASCADE
    

);