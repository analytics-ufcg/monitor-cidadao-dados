const path = require('path')
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

module.exports = {
    SAGRES: {
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
        }
    } //AL_DB {...}
}