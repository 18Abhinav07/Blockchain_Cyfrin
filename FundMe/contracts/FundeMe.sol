// CODE OUTLINE
// 1- send funds
// 2- withdraw funds
// 3- cap a minimum value on sending funds


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverterLibrary.sol";



contract FundMe {

    using PriceConverter for uint256; // declaring that all functions of the library can be directly used as a property on a uint256 value.

    uint256 minimumUSD_toSend = 10e18;
    address[] public funders;
    mapping(address => uint256) public fundersFundings;


    function fund() public payable {
        require( msg.value.getConversionRate() >= minimumUSD_toSend , "You need to send at least 10 USD worth of Ether!");
        funders.push(msg.sender);
        fundersFundings[msg.sender] += msg.value;
    }


    function getFundingDetails(address _funder) public view returns (uint256) {
        return fundersFundings[_funder];
    }


    function withdraw() public {
        for(uint256 _funderIndex = 0 ; _funderIndex < funders.length ; _funderIndex ++ ){
            // withdrawing will make the funders current funds 0 in the contract.
            address _funder = funders[_funderIndex];
            fundersFundings[_funder] = 0;
        }

        funders = new address[](0); // reset the address array.

        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        
    }


}