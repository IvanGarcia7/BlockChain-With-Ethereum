pragma solidity ^0.4.24;

contract UserContract {

    //Creacion de estructura de usuario
    struct User {
        string name;
        string surname;
    }

    //Para cada dirección representaremos un usuario
    mapping(address => User) private usuarios;
    //Mapping de tipo direcciona  bool
    mapping(address => bool) private usuariosRegistrados;

    //funcion para registrarse en el contrato
    function join(string name,string surname) public {
        require(!userJoined(msg.sender),"Address already registered");
        User storage userActual = usuarios[msg.sender];
        userActual.name = name;
        userActual.surname = surname;
        usuariosRegistrados[msg.sender] = true;
    }

    //funcion para recuperar nombre y apellido usuario
    function getUser(address addr) public view returns(string,string) {
        require(userJoined(msg.sender),"Unregistered Address");
        User memory userActual = usuarios[addr];
        return (userActual.name,userActual.surname);
    }

    function userJoined(address addr) private view returns(bool) {
        return usuariosRegistrados[addr];
    }


}