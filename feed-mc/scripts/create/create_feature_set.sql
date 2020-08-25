DROP TABLE IF EXISTS feature_set;

CREATE TABLE IF NOT EXISTS "feature_set" ( 
    "id_feature_set" VARCHAR(50),
    "timestamp" TIMESTAMP,	
    "features_descricao" json,		
    PRIMARY KEY("id_feature_set")
);

CREATE TABLE IF NOT EXISTS "feature_set_has_feature" ( 
    "id_feature" VARCHAR(50),
    "id_feature_set" VARCHAR(50),
    FOREIGN KEY("id_feature") REFERENCES feature("id_feature"), 
    FOREIGN KEY("id_feature_set") REFERENCES feature_set("id_feature_set"),
    CONSTRAINT feature_set_has_feature_key UNIQUE ("id_feature", "id_feature_set")
);