// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract simpleStorage {

    struct tokenHolder {
        string name;
        uint256 token;
    }

    tokenHolder[] public  holders;
    mapping(string => uint256) public holderMapTokenCounts;

    function setToken(uint256 _token , string memory _name) public {
        holders.push(tokenHolder(_name, _token));
        holderMapTokenCounts[_name] = _token;
    }

    function getTokenHolders() public view returns(tokenHolder[] memory){
        return holders;
    }

    function getTokens(string memory _name) public view returns(uint256){
        return holderMapTokenCounts[_name];
    }        
}