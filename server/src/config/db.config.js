/**
 * Arquivo: config/db.config.js
 * Descrição: arquivo responsável por recuperar as configurações de
 * cada banco de dados utilizado.
 */

const path = require('path')
// Define o caminho para o .env inicial 
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

// configurações dos bancos de dados
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
    } //, AL_DB {...}
}