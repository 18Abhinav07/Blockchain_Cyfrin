// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// solhint-disable-next-line interface-starts-with-i
interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData() external pure returns (int256 answer);

    function version() external pure returns (uint256 version);
}

// NOTE:

/* deployment to different chains have different hash codes for the contract, thus to test locally on a zkSync node running in docker i had to deploy the dummy aggregator to the chain and use that in the library for the test file to run correctly in foundry. This is done all before patrick taught the way to do fork testing and all that, did it just for the hell of it. */
