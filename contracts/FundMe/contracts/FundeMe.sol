// CODE OUTLINE
// 1- send funds                                DONE
// 2- withdraw funds                            DONE
// 3- cap a minimum value on sending funds      DONE


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





















// import {PriceConverter} from "./PriceConverterLibrary.sol";

error notOwner();

contract FundMe {

    using PriceConverter for uint256; // declaring that all functions of the library can be directly used as a property on a uint256 value.

    uint256 public constant MINIMUM_USD_TO_SEND = 10e18;
    address public immutable i_owner;
    uint256 result;


    address[] public funders;
    mapping(address => uint256) public fundersFundings;

    constructor () {
        i_owner = msg.sender;
    }

    receive() external payable {
        fund();
     }


    function fund() public payable {
        require( msg.value.getConversionRate() >= MINIMUM_USD_TO_SEND , "You need to send at least 10 USD worth of Ether!");
        // require( PriceConverter.getConversionRate(msg.value) >= minimumUSD_toSend , "You need to send at least 10 USD worth of Ether!"); // high gas fee 
        funders.push(msg.sender);
        fundersFundings[msg.sender] += msg.value;
    }


    function getFundingDetails(address _funder) public view returns (uint256) {
        return fundersFundings[_funder];
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner," Not Owner of the contract ");
        // if (msg.sender != i_owner) revert("Not the owner of this contract!");
        if (msg.sender != i_owner) { revert notOwner();} // custom error used.
        _;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "You don't have permission to withdraw!");
        for(uint256 _funderIndex = 0 ; _funderIndex < funders.length ; _funderIndex ++ ){
            // withdrawing will make the funders current funds 0 in the contract.
            address _funder = funders[_funderIndex];
            fundersFundings[_funder] = 0;
        }

        funders = new address[](0); // reset the address array.

        // // transfer ( automatically reverts a failed transaction )
        // payable(msg.sender).transfer(address(this).balance);

        // // send (returns bool )
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed"); ( needs manual require statement to revert )

        // both the above have 2300 gas limit.

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

    function getPrice() public view returns (uint256) {
        return PriceConverter.conversion_price();
    }

    function getEthAmountUsd() public view returns(uint256){
        uint256 eth = 1;
        return eth.getConversionRate(); // standard conversion rate for 1 eth
    }

    fallback() external payable {
       fund();
    }


}