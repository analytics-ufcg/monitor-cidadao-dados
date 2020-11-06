DROP TABLE IF EXISTS estorno_pagamento;

CREATE TABLE IF NOT EXISTS "estorno_pagamento" (
  "id_estorno_pagamento" VARCHAR(80),
  "cd_u_gestora" INTEGER,
  "dt_ano" SMALLINT,
  "cd_unid_orcamentaria" VARCHAR(5),
  "nu_empenho_estorno" VARCHAR(7),
  "nu_parcela_estorno" VARCHAR(7),
  "tp_lancamento" VARCHAR(3),
  "dt_estorno" DATE,
  "de_motivo_estorno" VARCHAR(200),
  "st_desp_liquidada" VARCHAR(1),
  "vl_estorno" DECIMAL,
  "dt_mes_ano" VARCHAR(6),
  "nu_estorno" VARCHAR(7),
  PRIMARY KEY("id_estorno_pagamento"),
  CONSTRAINT estorno_pagamento_key UNIQUE (cd_u_gestora, dt_ano, cd_unid_orcamentaria,
     nu_empenho_estorno, nu_parcela_estorno, tp_lancamento)
);
