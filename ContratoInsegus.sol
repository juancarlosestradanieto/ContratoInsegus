// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract ContratoInsegus {

    uint nextId;

    struct Propuesta {
        uint id;
        string empresa;
        uint monto;
        uint256 timestamp;
    }

    Propuesta[] propuestas;

    function hacerPropuesta(string memory empresa, uint monto) public
    {
        uint256 timestamp = block.timestamp;
        propuestas.push(Propuesta(nextId, empresa, monto, timestamp));
        nextId++;
    }

    function consultarTodasLasPropuestas() public view returns (Propuesta[] memory)
    {
        return propuestas;
    }

    function obtenerGanador() public view returns (Propuesta memory)
    {
        Propuesta memory propuestaGanadora;
        Propuesta memory propuestaActual;

        for (uint i = 0; i < propuestas.length; i++)
        {
            propuestaActual = propuestas[i];

            if(i == 0)
            {
                propuestaGanadora = propuestas[i];
            }

            if(i > 0)
            {
                if(propuestaActual.monto < propuestaGanadora.monto)
                {
                    propuestaGanadora = propuestaActual;
                }
            }
        }

        return propuestaGanadora;
    }

}
