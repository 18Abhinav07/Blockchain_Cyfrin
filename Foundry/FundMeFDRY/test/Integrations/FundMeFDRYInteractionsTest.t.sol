// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundFundMeFDRY, WithdrawFundMeFDRY} from "../../script/Interactions.s.sol";
import {Script} from "forge-std/Script.sol";
import {FundMeFDRY} from "../../src/FundMeFDRY.sol";
import {DeployFundMeFDRY} from "../../script/DeployFundMeFDRY.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeFDRYInteractionsTest is Test, Script {
    FundMeFDRY fund_me_FDRY;
    DeployFundMeFDRY deploy_fund_me_FDRY;
    address USER = makeAddr("USER");

    uint256 public constant SEND_VALUE = 10 ether;
    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant GAS_PRICE = 1;

    function setUp() external {
        vm.deal(USER, STARTING_BALANCE);
        deploy_fund_me_FDRY = new DeployFundMeFDRY();
        fund_me_FDRY = deploy_fund_me_FDRY.run();
    }

    function test_user_can_fund_and_owner_can_withdraw() public {
        FundFundMeFDRY fund_interaction = new FundFundMeFDRY();
        WithdrawFundMeFDRY withdraw_interaction = new WithdrawFundMeFDRY();

        vm.deal(address(fund_interaction), 1000 ether);

        uint256 starting_user_balance = address(USER).balance;
        uint256 starting_owner_balance = address(fund_me_FDRY.get_owner()).balance;

        //-----------------------------------------------------------------------------------//
        fund_interaction.Fund_FundMeFDRY(address(fund_me_FDRY)); // does not send any eth to the contract. Cannot figure out why.
        //_________________________________________________________________________________//
        
        vm.prank(USER);
        fund_me_FDRY.fund{value: SEND_VALUE}();

        withdraw_interaction.Withdraw_FundMeFDRY(address(fund_me_FDRY)); // withdrawl

        uint256 ending_contract_balance = address(fund_me_FDRY).balance;
        uint256 ending_user_balance = address(USER).balance;
        uint256 ending_owner_balance = address(fund_me_FDRY.get_owner()).balance;

        console.log("fund_interaction balance", address(fund_interaction).balance);

        console.log("Starting user balance:", starting_user_balance);
        console.log("Starting owner balance:", starting_owner_balance);
        console.log("Ending contract balance:", ending_contract_balance);
        console.log("Ending user balance:", ending_user_balance);
        console.log("Ending owner balance:", ending_owner_balance);
        console.log("funded: ", ending_owner_balance - starting_owner_balance);

        assert(ending_contract_balance == 0);
        assert(ending_user_balance == starting_user_balance - SEND_VALUE);
        assert(ending_owner_balance == starting_owner_balance + SEND_VALUE);
    }
}
