const path = require('path');
const fs = require('fs');
const chalk = require('chalk');
const solc = require('solc');

const contractPath = path.resolve(__dirname,"../contracts","UserContract.sol");
const source = fs.readFileSync(contractPath,'utf8');

//console.log(source);


//const {interface, bytecode } = solc.compile(source,1).contracts[':UserContract'];
//console.log(chalk.green(bytecode));
//describe un contrato y sus funciones
//console.log(chalk.cyan(interface));

//exportará todo el objeto de salida de la compilación
module.exports = solc.compile(source,1).contracts[':UserContract'];


