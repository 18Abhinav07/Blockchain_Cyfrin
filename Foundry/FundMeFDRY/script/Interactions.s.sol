// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {FundMeFDRY} from "../src/FundMeFDRY.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMeFDRY is Script {
    uint256 public constant SEND_VALUE = 1 ether;

    function Fund_FundMeFDRY(address recent_deployment) public {
        vm.startBroadcast();
        FundMeFDRY(payable(recent_deployment)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log("Funded the contract with %s.", SEND_VALUE);
    }

    function run() external {
        address most_recent_deployed = DevOpsTools.get_most_recent_deployment(
            "FundMeFDRY",
            block.chainid
        );

        Fund_FundMeFDRY(most_recent_deployed);
    }
}

contract WithdrawFundMeFDRY is Script {
    function Withdraw_FundMeFDRY(address recent_deployment) public {
        vm.startBroadcast();
        FundMeFDRY(payable(recent_deployment)).withdraw();
        vm.stopBroadcast();
        
        console.log("Withdrawn all the contract funds.");
    }

    function run() external {
        address most_recent_deployed = DevOpsTools.get_most_recent_deployment(
            "FundMeFDRY",
            block.chainid
        );
        Withdraw_FundMeFDRY(most_recent_deployed);
    }
}
