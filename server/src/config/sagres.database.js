var sql = require("mssql");

const path = require('path')
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

// Configurações do banco de dados SAGRES 2019
const config = {
	user: process.env.SQLSERVER_SAGRES19_USER,
  server: process.env.SQLSERVER_SAGRES19_HOST,
  database: process.env.SQLSERVER_SAGRES19_Database,
  password: process.env.SQLSERVER_SAGRES19_PASS,
  port: parseInt(process.env.SQLSERVER_SAGRES19_PORT),
	driver: 'tedious',
	stream: false,
	options: {
		trustedConnection: true,
		encrypt: false,
		enableArithAbort: true
	},
}

const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log('Connected to MSSQL')
    return pool
  })
  .catch(err => console.log('Database Connection Failed! Bad Config: ', err))

module.exports = {
  sql, poolPromise
}





