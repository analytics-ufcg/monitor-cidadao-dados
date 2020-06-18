/**
 * Arquivo: config/db.config.js
 * Descrição: arquivo responsável por criar a conexão com o banco de dados.
 */

const { Sequelize } = require('sequelize');
const { SAGRES } = require("./credentials");

/**  Adiciona as configurações específicas de um banco. Caso seja necessário mudar
 o BD basta alterar o parâmetro do Sequelize.
*/
const sequelize = new Sequelize(SAGRES)

// Testa se a conexão foi estabelecida
run().catch(error => console.log(error.stack));
async function run() {
  try {
    await sequelize.authenticate();
    console.log('Conexão estabelecida com o banco de dados ', SAGRES.database);
  } catch (error) {
    console.error('Não foi possível conectar-se ao banco de dados:', error);
  }
}

module.exports = {
  sequelize
}







