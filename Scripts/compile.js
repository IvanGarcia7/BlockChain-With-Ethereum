const path = require('path');
const fs = require('fs');
const chalk = require('chalk');
const solc = require('solc');

const contractPath = path.resolve(__dirname,"../contracts","UserContract.sol");
const source = fs.readFileSync(contractPath,'utf8');

//console.log(source);


const {interface, bytecode } = solc.compile(source,1).contracts[':UserContract'];

console.log(chalk.green(bytecode));
console.log(chalk.cyan(interface));