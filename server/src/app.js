/**
 * Arquivo: app.js
 * Descrição: arquivo responsável por toda a configuração da aplicação.
 */

const express = require('express');
const cors = require('cors');

const app = express();

// ==> Rotas da API:
const licitacoesRoute = require('./routes/licitacoes.routes');

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.json({ type: 'application/vnd.api+json' }));
app.use(cors());

app.use('/api/', licitacoesRoute);

module.exports = app;

const port = 3000;

app.listen(port, () => {
  console.log('Aplicação executando na porta ', port);
});
