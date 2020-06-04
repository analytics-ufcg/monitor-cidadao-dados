var sql = require("mssql");

const path = require('path')
const { SAGRES } = require("../config/index");

const poolPromise = new sql.ConnectionPool(SAGRES)
  .connect()
  .then(pool => {
    console.log('Connected to MSSQL')
    return pool
  })
  .catch(err => console.log('Database Connection Failed! Bad Config: ', err))

module.exports = {
  sql, poolPromise
}





