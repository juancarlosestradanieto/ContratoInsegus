// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract LicitacionVickrey {

    uint siguienteId;

    address payable public propietario;

    struct Propuesta {
        address licitador;
        uint monto;
    }

    Propuesta mejorPropuesta;
    Propuesta segundaMejorPropuesta;

    bool licitacionIniciada = false;
    bool licitacionTerminada = false;

    mapping(address => uint) propuestas;

    constructor() 
    {
        /*
        En el constructor se indica la dirección del propietario del contrato
        la cual será usada para ciertas validaciones
        */
        propietario = payable(msg.sender);
    }

    function iniciarLicitacion(uint monto) public
    {
        /*
        este debe ser un método privado
        aqui el propietario del contrato debe poder hacer su propuesta inicial contra la que deberán competir los demás
        la cual será asignada inmediatamente como mejorPropuesta y como segundaMejorPropuesta
        */

        require(msg.sender == propietario, "Solo el propietario del contrato puede inciar la licitacion.");
        if(licitacionIniciada == true)
        {
            revert("La licitacion ya ha sido iniciada.");
        }

        mejorPropuesta = Propuesta(propietario, monto);
        segundaMejorPropuesta = Propuesta(propietario, monto);

        licitacionIniciada = true;
    }

    function obtenerTimestamp() private view returns (uint256)
    {
        uint256 timestamp = block.timestamp;
        return timestamp;
    }

    function obtenerId() private returns (uint)
    {
        uint idActual = siguienteId;
        siguienteId++;
        return idActual;
    }

    //si la función es payable va a pedir indicar un monto y va a tomar la dirección el usuario que indica el monto
    function hacerPropuesta() public payable 
    {
        require(msg.sender != propietario, "El propietario del contrato no puede hacer propuestas.");

        if(licitacionIniciada == false)
        {
            revert("La licitacion aun no ha sido iniciada");
        }
        if(licitacionTerminada == true)
        {
            revert("La licitacion ya ha terminado");
        }

        /*
        como la función es payable, tenemos a nuestra disposición los valores
        msg.sender: dirección del usuario que ejecuta el método
        msg.value: monto indicado por el usuario que ejecuta el método

        */
        address licitador = msg.sender;
        uint monto = msg.value;

        if(monto >= mejorPropuesta.monto)
        {
             revert("La propuesta debe ser menor a la mejor propuesta actual");
        }
        else
        {
            Propuesta memory nuevaPropuesta = Propuesta(licitador, monto);

            segundaMejorPropuesta = mejorPropuesta;
            mejorPropuesta = nuevaPropuesta;

            propuestas[licitador] = monto;

            //se transfiere el 10% del monto de la propuesta hacia el propietario del contrato
            propietario.transfer(monto/10);

        }

    }

    function terminarLicitacion() public
    {
        require(msg.sender == propietario, "Solo el propietario del contrato puede terminar la licitacion.");

        licitacionTerminada = true;
    }

    function obtenerMejorPropuesta() public view returns (Propuesta memory)
    {
        return mejorPropuesta;
    }

    function obtenerSegundaMejorPropuesta() public view returns (Propuesta memory)
    {
        return segundaMejorPropuesta;
    }

    function recuperarGarantia() external returns (bool) 
    {
        /*
        retirar el dinero de las propuestas no ganadoras
        */

        address solicitante = msg.sender;

        if(licitacionTerminada == false)
        {
            revert("No se pueden retirar fondos hasta que la licitacion haya terminado");
        }

        if(solicitante == mejorPropuesta.licitador)
        {
            revert("El licitador con la mejor propuesta no puede retirar sus fondos");
        }

        uint monto = propuestas[solicitante];

        if (monto > 0) 
        {
            /* 
            Es importante poner esto a cero porque el solicitante
            puede volver a llamar a esta función
            antes de que `send` termine de ejecutarse.
            */
            propuestas[solicitante] = 0;

            /*
            msg.sender no es del tipo `address payable` y debe ser
            convertida explícitamente usando `payable(msg.sender)` para
            usa la función miembro `send()`.
            */
            if (!payable(solicitante).send(monto/10)) 
            {
                // No es necesario lanzar una excepción aquí, solo restablecer la cantidad adeudada
                propuestas[solicitante] = monto;
                return false;
            }
        }
        return true;
    }

}
