//Indicamos al compilador la versión
pragma solidity ^0.4.24;

import "./Ownable.sol";

contract MessageStore is Ownable {
    
    //propietario del smartContract
    //solidity tiene tipo de variable addres
    
    string private message;
    
    //invocado cuando smartContract sea desplegado en la red
    
    
    //funciones que modifican datos dentro del smartContract
    //requiere minadores verifiquen la transacción con el minado
    
    //payable metodo pagable requiere divisa
    //se establece dentro del campo value
    
    //isOwner
    
    function setMessage(string newMessage) public payable {
        require(msg.value == 3 ether);
        message = newMessage;
    }
    
    //view no se va a almacenar ningun valor dentro de smartContract
    //no tiene conste asociado las de tipo view
    
    function getMessage () public view returns (string) {
        return message;
    }
    
    
    
    //creo una nueva funcion para ver el balance del contrato
    function getBalance() public view returns (uint) {
        //deprecated return this.balance;
        return address(this).balance;
    }
    
    function getBalanceInEther() public view returns (uint) {
        //1 ether = 1e18
        return getBalance() / 1e18;
    }
    
    //La transferencia solo puede ser ejecutada
    //por el owner del contrato
    function transferWei (uint amount) public isOwner {
        require(address(this).balance >= amount);
        owner.transfer(amount);
    }
    
    function transferToUserWei (uint amount,address usuario) public isOwner {
        require(address(this).balance >= amount);
        require(usuario != address(0));
        usuario.transfer(amount);
    }
    
    function transferEther (uint amount) public isOwner {
        require((address(this).balance / 1e18) >= amount);
        owner.transfer(amount);
    }
    
    function transferToUserEther (uint amount,address usuario) public isOwner {
        require((address(this).balance / 1e18) >= amount);
        require(usuario != address(0));
        usuario.transfer(amount);
    }
    
    
    function transferAll () public isOwner {
        require(address(this).balance > 0);
        owner.transfer(address(this).balance);
    }
    
    
   
}