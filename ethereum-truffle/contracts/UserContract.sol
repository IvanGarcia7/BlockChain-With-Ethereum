pragma solidity >=0.4.21 <0.6.0;

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
    //Array con los usuarios
    address[]total;
    //Creación de eventos
    //event onUserJoined(address,string);

    //funcion para registrarse en el contrato
    function join(string memory name,string memory surname) public {
        require(!userJoined(msg.sender),"Address already registered");
        User storage userActual = usuarios[msg.sender];
        userActual.name = name;
        userActual.surname = surname;
        usuariosRegistrados[msg.sender] = true;
        total.push(msg.sender);
        //emit onUserJoined(msg.sender,string(abi.encodePacked(name," ",surname)));
    }

    //funcion para recuperar nombre y apellido usuario
    function getUser(address addr) public view returns(string memory,string memory) {
        require(userJoined(msg.sender),"Unregistered Address");
        User memory userActual = usuarios[addr];
        return (userActual.name,userActual.surname);
    }

    function userJoined(address addr) private view returns(bool) {
        return usuariosRegistrados[addr];
    }

    //funcion para conocer el número de usuarios registrados
    function totalUsers() public view returns(uint) {
        return total.length;
    }


}