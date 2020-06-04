const models = require("../models/index.model");

const Licitacao = models.licitacao;

const BAD_REQUEST = 400;
const SUCCESS = 200;

exports.getLicitacoes = async (req, res) => {
    Licitacao.findAll({limit: 10})
    .then(licitacoes => res.status(SUCCESS).json(licitacoes))
    .catch(err => res.status(BAD_REQUEST).json({ err }));
};



