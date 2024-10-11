// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverterLibrary.sol";

error FundMe__notOwner();

contract FundMeFDRY {
    using PriceConverter for uint256;

    address private chain_hash;
    uint256 public constant MINIMUM_USD_TO_SEND = 10e18;
    address private immutable i_owner;
    address[] private s_history_of_funders;
    mapping(address => uint256) private s_funder_to_funding;

    constructor(address _chain_hash) {
        i_owner = msg.sender;
        chain_hash = _chain_hash;
    }

    modifier only_owner() {
        if (msg.sender != i_owner) {
            revert FundMe__notOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    /*_______________________________________________________________ 
    |                                                                |
    |                    FUND ME CONTRACT FUNCTIONS                  |
    |________________________________________________________________|*/

    function fund() public payable {
        require(
            msg.value.get_conversion_rate(chain_hash) >= MINIMUM_USD_TO_SEND,
            "You need to send at least 10 USD worth of Ether!"
        );
        s_history_of_funders.push(msg.sender);
        s_funder_to_funding[msg.sender] += msg.value;
    }

    function get_funding_details(
        address _funder
    ) public view returns (uint256) {
        return s_funder_to_funding[_funder];
    }

    function withdraw() public only_owner {
        for (
            uint256 _funderIndex = 0;
            _funderIndex < s_history_of_funders.length;
            _funderIndex++
        ) {
            address _funder = s_history_of_funders[_funderIndex];
            s_funder_to_funding[_funder] = 0;
        }

        s_history_of_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    //________________ CHEAPER GAS OPTIMIZED VERISON __________________

    function cheaper_withdraw() public only_owner {
        uint256 _total_funders = s_history_of_funders.length;

        /*
        ------------------------------------------------------------------------------------
        instead of reading the length everytime the loop ran we saved it in memory and read | 
        it from there.                                                                      | 
        ------------------------------------------------------------------------------------
        */
        for (
            uint256 _funderIndex = 0;
            _funderIndex < _total_funders;
            _funderIndex++
        ) {
            address _funder = s_history_of_funders[_funderIndex];
            s_funder_to_funding[_funder] = 0;
        }

        s_history_of_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    /*_______________________________________________________________ 
    |                                                                |
    |                       PRICE FEED FUNCTIONS                     |
    |________________________________________________________________|*/

    function get_price() public view returns (uint256) {
        return PriceConverter.conversion_price(chain_hash);
    }

    function get_ETH_amount_in_USD() public view returns (uint256) {
        uint256 test_ETH = 1;
        return test_ETH.get_conversion_rate(chain_hash);
    }

    fallback() external payable {
        fund();
    }

    /*_______________________________________________________________ 
    |                                                                |
    |                       VIEW FUNCTIONS                           |
    |________________________________________________________________|*/

    function get_owner() public view returns (address) {
        return i_owner;
    }

    function get_funders() public view returns (address[] memory) {
        return s_history_of_funders;
    }

    function get_funders_mapped_fundings(
        address funder
    ) public view returns (uint256) {
        return s_funder_to_funding[funder];
    }

    function get_version() public view returns (uint256) {
        return PriceConverter.get_version(chain_hash);
    }
}
