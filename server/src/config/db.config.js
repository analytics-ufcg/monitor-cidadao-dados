const { Sequelize } = require('sequelize');
const { SAGRES } = require("./credentials");

const sequelize = new Sequelize(SAGRES)

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







