DROP TABLE IF EXISTS contrato;

CREATE TABLE IF NOT EXISTS "contrato" ( 
    "id_contrato" VARCHAR(50),
    "id_licitacao" VARCHAR(50),
    "cd_municipio" VARCHAR(3),
    "cd_u_gestora" INTEGER,   
    "dt_ano" SMALLINT,
    "nu_contrato" VARCHAR(9),
    "dt_assinatura" DATE,
    "pr_vigencia" DATE,
    "nu_cpfcnpj" VARCHAR(14),
    "nu_licitacao" VARCHAR(10),
    "tp_licitacao" SMALLINT,
    "vl_total_contrato" DECIMAL,
    "de_obs" VARCHAR(200),
    "dt_mes_ano" VARCHAR(6),
    "registro_cge" varchar(40),
    "cd_siafi" varchar(40),
    "dt_recebimento" DATE,
    "foto" VARCHAR(150),
    "planilha" VARCHAR(150),
    "ordem_servico" VARCHAR(150),
    PRIMARY KEY("id_contrato"),
    CONSTRAINT contrato_key UNIQUE (cd_u_gestora, dt_ano, nu_licitacao, tp_licitacao, nu_contrato),
    FOREIGN KEY("cd_municipio") REFERENCES municipio("cd_municipio") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY("id_licitacao") REFERENCES licitacao("id_licitacao") ON DELETE CASCADE ON UPDATE CASCADE

);