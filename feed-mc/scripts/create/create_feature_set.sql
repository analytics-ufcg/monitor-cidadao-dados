DROP TABLE IF EXISTS feature_set;

CREATE TABLE IF NOT EXISTS "feature_set" ( 
    "id_feature_set" VARCHAR(50),
    "feature_set" json,
    "features_descricao" text[],		
    "timestamp" TIMESTAMP,	
    PRIMARY KEY("id_feature_set")
);