DROP TABLE IF EXISTS participante;

CREATE TABLE IF NOT EXISTS "participante" ( 
    "id_participante" VARCHAR(50),
    "id_licitacao" VARCHAR(50),
    "cd_u_gestora" INTEGER,   
    "dt_ano" SMALLINT,
    "nu_licitacao" VARCHAR(10),
    "tp_licitacao" SMALLINT,
    "nu_cpfcnpj" VARCHAR(14),
    "dt_mes_ano" VARCHAR(6),
    "no_fornecedor" VARCHAR(100),
    PRIMARY KEY("id_participante"),
    CONSTRAINT participante_key UNIQUE (nu_licitacao, dt_ano, cd_u_gestora, tp_licitacao, nu_cpfcnpj),
    FOREIGN KEY("id_licitacao") REFERENCES licitacao("id_licitacao") ON DELETE CASCADE ON UPDATE CASCADE

);