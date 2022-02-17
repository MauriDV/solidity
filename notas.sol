//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;
pragma experimental ABIEncoderV2;

//marcos 777777 5
//joan 777333 9
//Maria 777444 2

contract notas {
    //Direccion del profesor
    address public profesor;

    constructor() {
        profesor = msg.sender;
    }

    mapping (bytes32 => uint) Notas;

    string [] revisiones;

    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){
        //hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Relacion entre el hash de la identificacion del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        //emision de evento evaluar
        emit alumno_evaluado(hash_idAlumno);
    }

    function getNota(string memory _idAlumno) public view returns(uint) {
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        return Notas[hash_idAlumno];
    }

    function revisionNota(string memory _idAlumno) public {
        revisiones.push(_idAlumno);
        emit evento_revision(_idAlumno);
    }

    function getRevisiones() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        return revisiones;
    }

    //Modificadores
    modifier UnicamenteProfesor(address _direccion){
        require(_direccion == profesor, "No tiene permisos para ejecutar esta funcion");
        _;
    }

    //Eventos 
    event alumno_evaluado(bytes32);
    event evento_revision(string);
}
