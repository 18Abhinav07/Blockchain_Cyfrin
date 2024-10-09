// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./AggregatorInterface.sol";

contract InterfaceContract is AggregatorV3Interface {
    // DEMO INTERFACE

    function latestRoundData() external pure override returns (int256) {
        return 1000;
    }

    function version() external pure override returns (uint256) {
        return 4;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function description() external pure override returns (string memory) {
        return "Demo Aggregator Interface";
    }

    function getRoundData(
        uint80 _roundId
    )
        external
        pure
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (_roundId, 1000, 0, 0, _roundId);
    }
}
