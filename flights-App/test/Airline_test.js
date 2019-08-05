Web3 = require('web3');
const Airline = artifacts.require('Airline');

let instance;

beforeEach(async () => {
    //Nuevo Smartcontract para cada test
    instance = await Airline.new();
});

contract('Airline', accounts => {

    //Vuelos disponibles una vez creado el contrato
    it('should have available flights', async() => {
        let total = await instance.totalFlights();
        assert(total > 0);
    });

    
    it('should allow customers to buy a flight providing its value', async() => {
        let flights = await instance.flights(0);
        let flightName = flights[0], price = flights[1];
        await instance.buyFlights(0,{from: accounts[0], value: price});
        let customerFlight = await instance.fligthsMapping(accounts[0],0);
        let customerTotalFlight = await instance.customerTotalFligthsMapping(accounts[0]);
        //console.log(customerFlight,customerTotalFlight);
        assert(customerFlight[0],flightName);
        assert(customerFlight[1],price);
        assert(customerTotalFlight,1);
    });


    it('should not allow customers to buy a flight under the price', async() => {
        let flights = await instance.flights(0);
        let price = flights[1]-5000;
        try{
            await instance.buyFlights(0,{from: accounts[0], value: price});
        }catch(e){
            return;
        }
        assert.fail();
    });

    it('should get the real balance of the contract', async() => {
        let flights = await instance.flights(0);
        let flightName = flights[0], price = flights[1];
        await instance.buyFlights(0,{from: accounts[0], value: price});
        
        let flights2 = await instance.flights(1);
        let flightName2 = flights2[0], price2 = flights[1];
        await instance.buyFlights(0,{from: accounts[0], value: price2});

        let balance = await instance.getAirlineBalance();
        let total = price+price2;
        
        assert(price.toNumber()+price2.toNumber(),balance.toNumber());
    });

    it('should allow customers to redeem loyalty points', async() => {
        
        let flights = await instance.flights(1);
        let price = flights[1];
        await instance.buyFlights(1,{from: accounts[0], value: price});

        let balance = await web3.eth.getBalance(accounts[0]);
        await instance.redeemLoyaltyPoints({from: accounts[0]});
        //Al comprar un vuelo obteníamos en base a los requisitos 5LP => 0.5 ETHER PER RP
        let finalBalance = await web3.eth.getBalance(accounts[0]);

        let customer = await instance.customersMapping(accounts[0]);
        let LP = customer[0];

        assert(LP,0);
        assert(finalBalance > balance);

    });


});