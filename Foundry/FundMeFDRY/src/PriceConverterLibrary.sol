// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function conversion_price(address chain) internal view returns (uint256) {
        (, int price, , , ) = AggregatorV3Interface(chain).latestRoundData();
        return uint256(price * 1e10);
    }

    function get_conversion_rate(
        uint256 ETH_amount,
        address chain
    ) internal view returns (uint256) {
        uint256 ETH_price = conversion_price(chain);
        uint256 ETH_amount_in_USD = (ETH_amount * ETH_price) / 1e18;
        return ETH_amount_in_USD;
    }

    function get_version(address chain) public view returns(uint256) {
        return AggregatorV3Interface(chain).version();
    }
}
