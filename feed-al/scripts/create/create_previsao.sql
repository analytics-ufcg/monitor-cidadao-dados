DROP TABLE IF EXISTS previsao;

CREATE TABLE IF NOT EXISTS "previsao" ( 
    "id_contrato" VARCHAR(50),	
    "cd_u_gestora" INTEGER,	
    "nu_licitacao" VARCHAR(10),	
    "nu_contrato" VARCHAR(9),
    "dt_ano" SMALLINT,
    "data_inicio" DATE,
    "nu_cpfcnpj" VARCHAR(14),
    "tp_licitacao" SMALLINT,
    "vl_total_contrato" DECIMAL,
    "n_licitacoes_part"	INTEGER,
    "n_licitacoes_venceu" INTEGER,
    "montante_lic_venceu" DECIMAL,
    "perc_vitoria" DECIMAL,
    "media_n_licitacoes_part" DECIMAL,
    "media_n_licitacoes_venceu" DECIMAL,
    "n_propostas" INTEGER,
    "media_n_propostas"	DECIMAL,
    "total_ganho" DECIMAL,
    "status_tramita" SMALLINT,
    "razao_contrato_por_vl_recebido" DECIMAL,	
    "media_num_contratos" DECIMAL,
    "num_contratos"	DECIMAL,
    "vig_pred" VARCHAR(1),
    "vig_prob_0" DECIMAL,
    "vig_prob_1" DECIMAL,
    FOREIGN KEY("id_contrato") REFERENCES contrato("id_contrato") ON DELETE CASCADE ON UPDATE CASCADE

);