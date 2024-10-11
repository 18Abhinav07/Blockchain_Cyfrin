// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {FundMeFDRY} from "../../src/FundMeFDRY.sol";
import {DeployFundMeFDRY} from "../../script/DeployFundMeFDRY.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "lib/foundry-devops/src/FoundryZkSyncChecker.sol";

contract FundMeTest is Script, StdCheats, ZkSyncChainChecker {
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

    function test_minimum_USD_to_send() public skipZkSync {
        uint256 expected = 10e18;
        uint256 actual = fund_me_FDRY.MINIMUM_USD_TO_SEND();
        assert(expected == actual);
    }

    function test_owner() public skipZkSync {
        address expected = msg.sender;
        address actual = fund_me_FDRY.get_owner();
        console.log("Expected address of owner: ", expected);
        console.log("Actual address of owner: ", actual);
        assert(expected == actual);
    }

    function test_aggregator_version_is_accurate() public skipZkSync {
        uint256 version = fund_me_FDRY.get_version();
        console.log("Version from the chain: ", version);
        assert(version == 4);
    }

    modifier fund_contract() {
        fund_me_FDRY.fund{value: SEND_VALUE}();
        _;
    }

    function test_fund_fails_without_enough_ETH() public skipZkSync {
        vm.expectRevert();
        fund_me_FDRY.fund{value: 0 ether}();
    }

    function test_only_owner_can_withdraw() public fund_contract skipZkSync {
        vm.expectRevert();
        vm.prank(address(3)); // Not the owner
        fund_me_FDRY.withdraw();
    }

    function test_mapping_of_funders_updates() public skipZkSync {
        vm.startPrank(USER);
        fund_me_FDRY.fund{value: SEND_VALUE}();
        vm.stopPrank();

        uint256 amountFunded = fund_me_FDRY.get_funders_mapped_fundings(USER);
        assert(amountFunded == SEND_VALUE);
    }

    function test_adds_funder_to_history() public skipZkSync {
        vm.startPrank(USER);
        fund_me_FDRY.fund{value: SEND_VALUE}();
        vm.stopPrank();

        address[] memory funders = fund_me_FDRY.get_funders();
        assert(funders.length == 1);
        assert(funders[0] == USER);
    }

    function test_withdrawl_with_a_single_funder()
        public
        fund_contract
        skipZkSync
    {
        uint256 starting_contract_balance = address(fund_me_FDRY).balance;
        uint256 starting_owner_balance = fund_me_FDRY.get_owner().balance;

        vm.prank(fund_me_FDRY.get_owner());
        fund_me_FDRY.withdraw();

        uint256 ending_contract_balance = address(fund_me_FDRY).balance;
        uint256 ending_owner_balance = fund_me_FDRY.get_owner().balance;

        assert(ending_contract_balance == 0);
        assert(
            starting_contract_balance + starting_owner_balance ==
                ending_owner_balance
        );
    }

    function test_withdrawl_with_a_multiple_funders()
        public
        fund_contract
        skipZkSync
    {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            hoax(address(i), STARTING_BALANCE);
            fund_me_FDRY.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fund_me_FDRY).balance;
        uint256 startingOwnerBalance = fund_me_FDRY.get_owner().balance;

        vm.startPrank(fund_me_FDRY.get_owner());
        fund_me_FDRY.withdraw();
        vm.stopPrank();

        assert(address(fund_me_FDRY).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fund_me_FDRY.get_owner().balance
        );
        assert(
            (numberOfFunders + 1) * SEND_VALUE ==
                fund_me_FDRY.get_owner().balance - startingOwnerBalance
        );
    }

    function test_withdrawl_with_a_multiple_funders_cheaper()
        public
        fund_contract
        skipZkSync
    {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            hoax(address(i), STARTING_BALANCE);
            fund_me_FDRY.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fund_me_FDRY).balance;
        uint256 startingOwnerBalance = fund_me_FDRY.get_owner().balance;

        vm.startPrank(fund_me_FDRY.get_owner());
        fund_me_FDRY.cheaper_withdraw();
        vm.stopPrank();

        assert(address(fund_me_FDRY).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fund_me_FDRY.get_owner().balance
        );
        assert(
            (numberOfFunders + 1) * SEND_VALUE ==
                fund_me_FDRY.get_owner().balance - startingOwnerBalance
        );
    }
}
