var sql = require("mssql");

const path = require('path')
const { SAGRES } = require("./db.config");

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





