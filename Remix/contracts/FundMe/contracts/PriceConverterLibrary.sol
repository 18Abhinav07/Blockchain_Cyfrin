// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// created my own static dummy aggregator as sepolia has so high gas fee.
// import {AggregatorV3Interface} from "./PracticeInterface/AggregatorInterface.sol";

// same constructor from my github repo.It works on my code but not on other on the same address, I guess REMIX Vm is different for each user.
// nope it works on the other vm too the above was just an error but the contract needs to be deployed in their vm which specifies the functions working of the interface
// my deployed contract will not work.

// import  {AggregatorV3Interface} from "https://raw.githubusercontent.com/18Abhinav07/Blockchain_Cyfrin/main/FundMe/contracts/PracticeInterface/AggregatorInterface.sol";
// --> during zkSync deployment hardhat does not allow using https to import.

library PriceConverter {
    
    function conversion_price() internal view returns (uint256){
        // (int price) = AggregatorV3Interface(0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD).latestRoundData(); // VM deployed

        // (,int price,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData(); // for sepolia

        (,int price,,,) = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).latestRoundData(); // zkSync Sepolia testnet
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = conversion_price(); // get the eth price from the price feed contract
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18; // convert to usd from eth (multiply by eth price and divide by eth price)  
        return ethAmountInUsd;
    }

}