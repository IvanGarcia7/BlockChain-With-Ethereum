pragma solidity ^0.4.24;

contract UserContract {

    //Creacion de estructura de usuario
    struct User {
        string name;
        string surname;
    }

    //Para cada dirección representaremos un usuario
    mapping(address => User) private usuarios;

    //funcion para registrarse en el contrato
    function join(string name,string surname) public {
        User storage userActual = usuarios[msg.sender];
        userActual.name = name;
        userActual.surname = surname;
    }

    //funcion para recuperar nombre y apellido usuario
    function getUser(address addr) public view returns(string,string) {
        User memory userActual = usuarios[addr];
        return (userActual.name,userActual.surname);
    }

}