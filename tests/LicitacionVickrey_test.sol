// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/LicitacionVickrey.sol";
import "remix_accounts.sol"; //Use accounts defined here for testing

contract LicitacionVickreyTest is LicitacionVickrey {
 
    //LicitacionVickrey LicitacionVickreyToTest;

    //https://medium.com/coinmonks/solidity-unit-testing-with-remix-ide-a-few-missing-pieces-6677786735d4
    //Variables used to emulate different accounts
    address acc0;
    address acc1;
    address acc2;
    address acc3;

    function beforeAll () public {
        //LicitacionVickreyToTest = new LicitacionVickrey();    

        //Initiate acc variables
        acc0 = TestsAccounts.getAccount(0);//el propietario el contrato
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
        acc3 = TestsAccounts.getAccount(3);
    }

    /// Custom Transaction Context
    /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-0
    function verificarPropuestaGanadora () public {
        console.log("Ejecutando verificarPropuestaGanadora solo propietario");
        // LicitacionVickreyToTest.iniciarLicitacion(350);
        iniciarLicitacion(350);

        // Assert.equal(LicitacionVickreyToTest.obtenerMejorPropuesta().monto, 350, "La propuesta ganadora debe ser la primera porque solo han hecho una");
        Assert.equal(obtenerMejorPropuesta().monto, 350, "La propuesta ganadora debe ser la primera porque solo han hecho una");
    }

    /// #sender: account-0
    /// #value: 10
    function checkSenderAccount0 () public payable {
        Assert.equal(msg.sender, TestsAccounts.getAccount(0), "wrong sender in checkSenderIs0AndValueis10");
        Assert.equal(msg.value, 10, "wrong value in checkSenderIs0AndValueis10");
    }
    
    /// Custom Transaction Context
    /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 200
    function verificarHacerPropuestaPorLicitador() public payable {
        console.log("Ejecutando hacerPropuesta por licitador");

        hacerPropuesta();

        // Assert.equal(LicitacionVickreyToTest.obtenerMejorPropuesta().monto, 200, 'La propuesta ganadora debe ser 200');
        Assert.equal(obtenerMejorPropuesta().monto, 200, 'La propuesta ganadora debe ser 200');
    }
    
    /// Custom Transaction Context
    /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-2
    /// #value: 150
    function verificarHacerSegundaPropuestaPorOtroLicitador() public payable {
        console.log("Ejecutando hacerPropuesta por licitador");

        hacerPropuesta();

        // Assert.equal(LicitacionVickreyToTest.obtenerMejorPropuesta().monto, 200, 'La propuesta ganadora debe ser 200');
        Assert.equal(obtenerMejorPropuesta().monto, 150, 'La propuesta ganadora debe ser 150');
    }

    

}