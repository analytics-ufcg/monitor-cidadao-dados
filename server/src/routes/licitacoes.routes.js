/**
 * Arquivo: src/routes/licitacoes.routes.js
 * Descrição: arquivo responsável pelas rotas da api relacionadas a classe 'Licitacoes'.
 */

const router = require('express-promise-router')();
const licitacoesController = require('../controllers/licitacoes.controller');

// Retrieve all Customers
// Example: http://localhost:3000/api/licitacoes
router.get('/licitacoes', licitacoesController.getLicitacoes)

module.exports = router;