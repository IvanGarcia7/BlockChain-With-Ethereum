pragma solidity >=0.4.24;

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
    mapping(address => Customer) public customersMapping;
    mapping(address => Fligths[]) public fligthsMapping;
    mapping(address => uint) public customerTotalFligthsMapping;

    //se emite cuando se compra un vuelo
    event FlightPurchased(address indexed customer, uint price,string flight);



    constructor() public {
        owner = msg.sender;
        //Primer requisito cumplido, poseer vuelos iniciales disponibles de forma pública
        flights.push(Fligths('España',3 ether));
        flights.push(Fligths('Venecia',3 ether));
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
        FlightPurchased(msg.sender,fligthSelected.price,fligthSelected.name);
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
        return etherRP * customersMapping[msg.sender].loyalty_points;
    }

    //Recuperar el balance de la aerolínea
    function getAirlineBalance() public isOwner view returns(uint) {
        address airlineAddress = address(this);
        return airlineAddress.balance;
    }

    modifier isOwner() {
        require(msg.sender == owner,"You need to be the owner to the Airline");
        _;
    }

}