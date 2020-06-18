DROP TABLE IF EXISTS licitacao;

CREATE TABLE IF NOT EXISTS "licitacao" ( 
    "id_licitacao" VARCHAR(50),
    "cd_u_gestora" INTEGER,   
    "dt_ano" SMALLINT,
    "nu_licitacao" VARCHAR(9),
    "tp_licitacao" SMALLINT,
    "dt_homologacao" DATE,
    "nu_propostas" SMALLINT,
    "vl_licitacao" DECIMAL,
    "tp_objeto" SMALLINT,
    "de_obs" VARCHAR(120),
    "dt_mes_ano" VARCHAR(6),
    "registro_cge" varchar(40),
    "tp_regime_execucao" SMALLINT,
    PRIMARY KEY("id_licitacao"),
    CONSTRAINT licitacao_key UNIQUE (cd_u_gestora, dt_ano, nu_licitacao, tp_licitacao)
);