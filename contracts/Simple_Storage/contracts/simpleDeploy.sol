// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract simpleStorage {

    uint256 public storedData;

    function set(uint256 _newage) public{
        storedData = _newage;
    }

    function retrieve() public view returns (uint256){
        return storedData ;
    }
}