// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function conversion_price(address chain) internal view returns (uint256) {
        (, int price, , , ) = AggregatorV3Interface(chain).latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount,
        address chain
    ) internal view returns (uint256) {
        uint256 ethPrice = conversion_price(chain);
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(address chain) internal view returns (uint256) {
        return AggregatorV3Interface(chain).version();
    }

    function getDecimals(address chain) internal view returns (uint8) {
        return AggregatorV3Interface(chain).decimals();
    }

    function getDescription(
        address chain
    ) internal view returns (string memory) {
        return AggregatorV3Interface(chain).description();
    }

    function getRoundData(
        uint80 _roundId,
        address chain
    )
        internal
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return AggregatorV3Interface(chain).getRoundData(_roundId);
    }
}
