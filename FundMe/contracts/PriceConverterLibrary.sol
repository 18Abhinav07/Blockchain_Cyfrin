
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    
    function conversion_price() internal view returns (uint256){
        (,int price,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
        return uint256(price * 1e10); // to match the wei decimal range of 18 as price has 8 decimals 
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = conversion_price(); // get the eth price from the price feed contract
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18; // convert to usd from eth (multiply by eth price and divide by eth price)  
        return ethAmountInUsd;
    }


}