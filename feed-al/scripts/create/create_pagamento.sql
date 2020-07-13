DROP TABLE IF EXISTS pagamento;

CREATE TABLE IF NOT EXISTS "pagamento" (
  "cd_u_gestora" VARCHAR(6),
  "dt_ano" VARCHAR(4),
  "cd_unid_orcamentaria" VARCHAR(5),
  "nu_empenho" VARCHAR(7),
  "nu_parcela" VARCHAR(7),
  "tp_lancamento" VARCHAR(3),
  "vl_pagamento" DECIMAL,
  "dt_pagamento" VARCHAR(6),
  "cd_conta" VARCHAR(15),
  "nu_cheque_pag" VARCHAR(30),
  "nu_deb_aut" VARCHAR(10),
  "cd_banco_rec" VARCHAR(5),
  "cd_agencia_rec" VARCHAR(5),
  "nu_conta_rec" VARCHAR(15),
  "tp_fonte_recursos" VARCHAR(3),
  "dt_mes_ano" VARCHAR(6),
  "cd_banco" VARCHAR(3),
  "cd_agencia" VARCHAR(5),
  "tp_conta_bancaria" VARCHAR(1),
  PRIMARY KEY("nu_parcela"),
  CONSTRAINT pagamento_key UNIQUE (cd_u_gestora, dt_ano, cd_unid_orcamentaria, nu_empenho, tp_lancamento)
);
