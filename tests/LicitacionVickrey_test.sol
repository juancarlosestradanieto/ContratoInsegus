// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/LicitacionVickrey.sol";

contract LicitacionVickreyTest {
 
    LicitacionVickrey LicitacionVickreyToTest;
    function beforeAll () public {
        LicitacionVickreyToTest = new LicitacionVickrey();
    }

    function verificarPropuestaGanadora () public {
        console.log("Ejecutando verificarPropuestaGanadora solo propietario");       

        LicitacionVickreyToTest.iniciarLicitacion(350);

        Assert.equal(LicitacionVickreyToTest.obtenerMejorPropuesta().monto, 350, "proposal at index 0 should be the winning proposal");
    }

    function addValueOnce() public payable {
        console.log("Ejecutando verificarPropuestaGanadora solo licitador");

        LicitacionVickreyToTest.iniciarLicitacion(350);

        // check if value is same as provided through devdoc
        //Assert.equal(msg.value, 200, 'value should be 200');
        // execute 'addValue'
        LicitacionVickreyToTest.hacerPropuesta{value: 200}(); // introduced in Solidity version 0.6.2
        // As per the calculation, check the total balance
        Assert.equal(LicitacionVickreyToTest.obtenerMejorPropuesta().monto, 200, 'token balance should be 20');
    }
}