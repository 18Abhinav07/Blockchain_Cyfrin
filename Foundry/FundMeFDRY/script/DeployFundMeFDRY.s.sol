// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMeFDRY} from "../src/FundMeFDRY.sol";

contract DeployFundMeFDRY is Script {
    function run() external returns (FundMeFDRY) {
        address chainHash = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

        vm.startBroadcast();
        FundMeFDRY fundMeFDRY = new FundMeFDRY(chainHash);
        vm.stopBroadcast();

        return fundMeFDRY;
    }
}
