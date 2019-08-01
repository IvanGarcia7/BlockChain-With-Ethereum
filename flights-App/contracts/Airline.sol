pragma solidity ^0.4.23;

contract Airline {

    address public owner;

    struct Customer {
        uint loyalty_points;
        uint total_flights;
    }

    struct Fligths {
        string name;
        uint price;
    }

    uint etherRP = 0.5 ether;

    Fligths[] public flights;
    mapping(address => Customer) private customersMapping;
    mapping(address => Fligths[]) private fligthsMapping;
    mapping(address => uint) private customerTotalFligthsMapping;
    event FlightPurchased(address indexed customer, uint price);

    constructor() public {
        owner = msg.sender;
        //Primer requisito cumplido, poseer vuelos iniciales disponibles de forma pública
        flights.push(Fligths('España',4 ether));
        flights.push(Fligths('Venecia',2 ether));
        flights.push(Fligths('Tomorrowland',3 ether));
        flights.push(Fligths('Palo Alto',10 ether));
    }

    function buyFlights(uint fligthIndex) public payable {
        Fligths storage fligthSelected = flights[fligthIndex];
        require(msg.value == fligthSelected.price, "Not Enought Quantity");
        Customer storage  user = customersMapping[msg.sender];
        //Segundo requisito cumplido sumar 5 royal points por cada compra a el cliente
        user.loyalty_points += 5;
        user.total_flights += 1;
        fligthsMapping[msg.sender].push(fligthSelected);
        customerTotalFligthsMapping[msg.sender]++;
        emit FlightPurchased(msg.sender,fligthSelected.price);
    }

    function totalFlights() public view returns(uint) {
        return flights.length;
    }

    //Clientes puedan recuperar dinero a partir de RP
    function redeemLoyaltyPoints() public {
        Customer storage customer = customersMapping[msg.sender];
        uint etherToRP = etherRP * customer.loyalty_points;
        msg.sender.transfer(etherToRP);
        customer.loyalty_points = 0;
    }

    //Recuperar los RP por parte del cliente
    function getRefundableEther() public view returns(uint) {
        Customer storage customer = customersMapping[msg.sender];
        return etherRP * customer.loyalty_points;
    }

    //Recuperar el balance de la aerolínea
    function getAirlineBalance() public isOwner view returns(uint) {
        address airlineAddress = this;
        return airlineAddress.balance;
    }

    modifier isOwner() {
        require(msg.sender == owner,"You need to be the owner to the Airline");
        _;
    }

}