pragma solidity ^0.4.24;

contract UserContract {

    //Creacion de estructura de usuario
    struct User {
        string name;
        string apellido;
    }

    //Para cada dirección representaremos un usuario
    mapping(address => User) private usuarios;

}