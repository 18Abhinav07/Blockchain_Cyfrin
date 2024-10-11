//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockV3Aggregator} from "../test/Mocks/MockAggregatorV3Interface.sol";

import {InterfaceContract} from "../src/PracticeInterface/InterfaceContract.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2414e8;

    struct NetworkConfig {
        address chain_hash;
    }

    NetworkConfig public current_network;

    constructor() {
        if (block.chainid == 11155111) {
            current_network = getZkSyncLocalETH_USD();
        } else if (block.chainid == 300) {
            current_network = getZkSyncSepoliaETH_USD();
        } else {
            current_network = getAnvilETH_USD();
        }
        console.log("current_network: ", current_network.chain_hash);
        console.log("blockId: ", block.chainid);
    }

    function getSepoliaETH_USD() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetwork = NetworkConfig({
            chain_hash: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaNetwork;
    }

    function getZkSyncLocalETH_USD()
        public
        returns (NetworkConfig memory)
    {
        vm.startBroadcast();
    
        MockV3Aggregator priceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );

        /*  InterfaceContract priceFeed = new InterfaceContract(
            DECIMALS,
            INITIAL_PRICE
        );*/

        vm.stopBroadcast();

        NetworkConfig memory zkSyncLocalNetwork = NetworkConfig({
            chain_hash: address(priceFeed)
        });
        return zkSyncLocalNetwork;
    }

    function getZkSyncSepoliaETH_USD()
        public
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory zkSyncSepoliaNetwork = NetworkConfig({
            chain_hash: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        });
        return zkSyncSepoliaNetwork;
    }

    function getAnvilETH_USD() public returns (NetworkConfig memory) {
        vm.startBroadcast();

        MockV3Aggregator priceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        /*  InterfaceContract priceFeed = new InterfaceContract(
            DECIMALS,
            INITIAL_PRICE
        );*/

        vm.stopBroadcast();

        NetworkConfig memory anvil = NetworkConfig({
            chain_hash: address(priceFeed)
        });
        return anvil;
    }
}

/*  
        ______________________NOTES________________________
        
        ```
        vm.startBroadcast();

        MockV3Aggregator priceFeed = new MockV3Aggregator(4, 2414e8);

        InterfaceContract priceFeed = new InterfaceContract();

        vm.stopBroadcast();

        NetworkConfig memory <network-name> = NetworkConfig({
            chain_hash: address(priceFeed)
        });

        ```


        The mock aggregator or any other contract must be deployed by the vm inside the test function as needed, a seperate deployment is not working.

        --> till now I have found only sepolia network to function fine by forking the url and not bradcasting a mock feed.
           
*/
