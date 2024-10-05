// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./AggregatorInterface.sol";

contract CheckInterfaceViaAddress {

    function latestRoundData() public view returns(int256){
        return AggregatorV3Interface(0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD).latestRoundData();
    }

}