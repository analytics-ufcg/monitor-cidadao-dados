/**
 * Arquivo: controllers/licitacoes.controller.js
 * Descrição: arquivo responsável por recuperar informações relacionadas as
 * licitações.
 */

const models = require("../models/index.model");
const Licitacao = models.licitacao;
const Op = models.Sequelize.Op;

const BAD_REQUEST = 400;
const SUCCESS = 200;

// Retorna as 10 primeiras licitações (terá mudanças)
exports.getLicitacoes = async (req, res) => {
    Licitacao.findAll({limit: 100, where: { de_Obs: { [Op.ne]: null } }})
    .then(licitacoes => res.status(SUCCESS).json(licitacoes))
    .catch(err => res.status(BAD_REQUEST).json({ err }));
};



