pragma solidity ^0.4.24;

contract Ownable {
    
    //internal es parecido a protected
    //ambito disponible dentro del contrato Ownable
    //y todos los tipos derivados heredados del mismo
    
    address internal owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier isOwner(){
        require (owner == msg.sender);
        _;
    }
    
}