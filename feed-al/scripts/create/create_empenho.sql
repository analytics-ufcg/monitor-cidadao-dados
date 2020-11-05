DROP TABLE IF EXISTS empenho;

CREATE TABLE IF NOT EXISTS "empenho" (
    "id_empenho" VARCHAR(50),
    "id_licitacao" VARCHAR(50),
    "id_contrato" VARCHAR(50),
    "cd_u_gestora" INTEGER,
    "dt_ano" SMALLINT,
    "cd_unid_orcamentaria" VARCHAR(5),
    "cd_funcao" VARCHAR(2),
    "cd_subfuncao" VARCHAR(3),
    "cd_programa" VARCHAR(4),
    "cd_acao" VARCHAR(4),
    "cd_classificacao" VARCHAR(6),
    "cd_cat_economica" VARCHAR(1),
    "cd_nat_despesa" VARCHAR(1),
    "cd_modalidade" VARCHAR(2),
    "cd_elemento" VARCHAR(20),
    "cd_sub_elemento" VARCHAR(3),
    "tp_licitacao" SMALLINT,
    "nu_licitacao" VARCHAR(50),
    "nu_empenho" VARCHAR(50),
    "tp_empenho" SMALLINT,
    "dt_empenho" DATE,
    "vl_empenho" DECIMAL,
    "cd_credor" VARCHAR(14),
    "no_credor" VARCHAR(100),
    "tp_credor" SMALLINT,
    "de_historico1" VARCHAR,
    "de_historico2" VARCHAR,
    "de_historico" VARCHAR,
    "tp_meta" SMALLINT,
    "nu_obra" VARCHAR(8),
    "dt_mes_ano" VARCHAR(6),
    "dt_mes_ano_referencia" VARCHAR(6),
    "tp_fonte_recursos" SMALLINT,
    "nu_cpf" VARCHAR(14),
    "cd_sub_elemento_2" VARCHAR(3),
    "cd_ibge" VARCHAR(7),
    PRIMARY KEY("id_empenho"),
    FOREIGN KEY("cd_ibge") REFERENCES localidade_ibge("cd_ibge") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY("id_licitacao") REFERENCES licitacao("id_licitacao") ON DELETE CASCADE ON UPDATE CASCADE


																										
);
