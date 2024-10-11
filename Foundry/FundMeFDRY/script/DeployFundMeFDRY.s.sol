// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMeFDRY} from "../src/FundMeFDRY.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMeFDRY is Script {
    function run() external returns (FundMeFDRY) {

        HelperConfig helper_config = new HelperConfig();
        address chain_hash = helper_config.current_network();

        // before the broadcast everything is simulated transactiona and does not cost gas.
        vm.startBroadcast();
        FundMeFDRY fund_me_FDRY = new FundMeFDRY(chain_hash);
        vm.stopBroadcast();

        return fund_me_FDRY;
    }
}
