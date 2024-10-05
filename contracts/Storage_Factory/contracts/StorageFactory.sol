// SPDX-License-Identifier: MIT


pragma solidity ^0.8.24;


import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public simpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorageTemp = new SimpleStorage();
        simpleStorageContracts.push(simpleStorageTemp);
    }

    function sfStore ( uint256 _contractIndex , uint256 _favNumber) public {
        simpleStorageContracts[_contractIndex].store(_favNumber);
    }

    function sfAddPerson (uint256 _contractIndex, string memory _name, uint256 _favNumber)  public  {
        simpleStorageContracts[_contractIndex].addPerson(_name, _favNumber);
    }

    

    function sfRetrieve(uint256 _contractIndex) public view returns(uint256) {
        return simpleStorageContracts[_contractIndex].retrieve();    
    }


}