const assert = require('assert');
const AssertionError = require('assert').AssertionError;
const Web3 = require('web3');

//Capa de comunicación con el servidor
const provider = new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545");
//Creo una nueva instancia que apunta al server de Ganache
const web3 = new Web3(provider);

const {interface, bytecode } = require('../Scripts/compile');

let accounts;
//Almaceno la instancia del contrato una vez desplegado
let usersContract;

beforeEach(async() => {
    accounts = await web3.eth.getAccounts();
    usersContract = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode})
    .send({from:accounts[0],gas:'1000000'});
});

describe('The UserContract', async() => {
    it('should deploy', () => {
        assert.ok(usersContract.options.address);
    })

    it('should join a user', async () => {
        let name = "Ivan";
        let surname = "Garcia";
        await usersContract.methods.join(name,surname)
        .send({from:accounts[0],gas:'500000'});
    })


    it('should retrieve a user', async () => {
        let name = "Ivan";
        let surname = "Garcia";
        await usersContract.methods.join(name,surname)
        .send({from:accounts[0],gas:'500000'});

        let user = await usersContract.methods.getUser(accounts[0]).call();

        assert.equal(name,user[0]);
        assert.equal(surname,user[1]);
    })

    it('should not allow joinin an account twice', async () => {
        await usersContract.methods.join("Ivan","Garcia")
        .send({from:accounts[1],gas:'500000'});
        try{
            await usersContract.methods.join("Andrea","Sanchez")
            .send({from:accounts[1],gas:'500000'});
            assert.fail('same account cant join twice');
        }catch(e){
            if(e instanceof AssertionError){
                assert.fail(e.message);
            }
        }
    })


    it('should not retrieve a user not logged', async () => {
        try{
            await usersContract.methods.getUser(accounts[0]).call();
            assert.fail('you cant retrieve a user not logged');
        }catch(e){
            if(e instanceof AssertionError){
                assert.fail(e.message);
            }
        }
    })

    it('should retrieve total registered users', async () => {

        await usersContract.methods.join("Ana", "Gomez")
            .send({ from: accounts[0], gas: '500000' });

        await usersContract.methods.join("Mario", "Bros")
            .send({ from: accounts[1], gas: '500000' });

        await usersContract.methods.join("Alberto", "Garcia")
            .send({ from: accounts[2], gas: '500000' });

        let total = await usersContract.methods.totalUsers().call();        
        assert.equal(total, 3);        
    });

})

