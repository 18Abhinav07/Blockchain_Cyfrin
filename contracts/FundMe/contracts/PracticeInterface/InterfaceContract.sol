// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./AggregatorInterface.sol";

contract InterfaceContract is AggregatorV3Interface {

    int256 price;

    constructor(int256 _data) {
        price = _data;
    }

    function latestRoundData() external view override  returns(int256) {
        return price;
    }
    
}