const { sql, poolPromise } = require("../config/sagres.database");

exports.getLicitacoes = async (req, res) => {
    var query = 'SELECT TOP 10 cd_UGestora, nu_licitacao, vl_licitacao, de_Obs FROM Licitacao';
    try {
        const pool = await poolPromise;
        const result = await pool.request().query(query);
        res.send(result.recordset);
    } catch (e) {
        console.error(e)
    }
};



