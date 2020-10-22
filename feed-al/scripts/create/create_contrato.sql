DROP TABLE IF EXISTS contrato;

CREATE TABLE IF NOT EXISTS "contrato" ( 
    "id_contrato" VARCHAR(50),
    "id_licitacao" VARCHAR(50),
    "cd_u_gestora" INTEGER,   
    "dt_ano" SMALLINT,
    "nu_contrato" VARCHAR(40),
    "dt_assinatura" DATE,
    "pr_vigencia" DATE,
    "nu_cpfcnpj" VARCHAR(14),
    "nu_licitacao" VARCHAR(20),
    "tp_licitacao" VARCHAR(20),
    "vl_total_contrato" DECIMAL,
    "de_obs" VARCHAR,
    "dt_mes_ano" VARCHAR(6),
    "registro_cge" varchar(40),
    "cd_siafi" varchar(40),
    "dt_recebimento" DATE,
    "foto" VARCHAR(150),
    "planilha" VARCHAR(150),
    "ordem_servico" VARCHAR(150),
    "language" VARCHAR(10),
    "de_ugestora" VARCHAR(100),
    "no_fornecedor" VARCHAR(500),
    "cd_ibge" VARCHAR(7),
    "uf" VARCHAR(2),
    "mesorregiao_geografica" VARCHAR(2),
    "microrregiao_geografica" VARCHAR(2),
    PRIMARY KEY("id_contrato"),
    FOREIGN KEY("cd_ibge") REFERENCES localidade_ibge("cd_ibge") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY("id_licitacao") REFERENCES licitacao("id_licitacao") ON DELETE CASCADE ON UPDATE CASCADE

);