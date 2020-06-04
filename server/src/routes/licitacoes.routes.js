/**
 * Arquivo: src/routes/licitacoes.routes.js
 * Descrição: arquivo responsável pelas rotas da api relacionado a classe 'Licitacoes'.
 */


const router = require('express-promise-router')();
const licitacoesController = require('../controllers/licitacoes.controller');

// http://localhost:3000/api/licitacoes
router.get('/licitacoes', licitacoesController.getLicitacoes)

module.exports = router;