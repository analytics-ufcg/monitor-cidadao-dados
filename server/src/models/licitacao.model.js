module.exports = (sequelize, type) => {
    Licitacao = sequelize.define(
        "Licitacao",
        {
            nu_licitacao: { // deixei este como PK por enquanto
                type: type.STRING,
                primaryKey: true
            },
            cd_UGestora: type.INTEGER,
            vl_licitacao: type.INTEGER,
            de_Obs: type.STRING,
        },
        {
            freezeTableName: true,
            timestamps: false
        }
    );

    return Licitacao;
};