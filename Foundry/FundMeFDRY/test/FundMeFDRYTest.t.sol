// // sPDX-License-Identifier: MIT

// pragma solidity ^0.8.24;

// import {Test, console} from "forge-std/Test.sol";
// import {FundMeFDRY} from "../src/FundMeFDRY.sol";

// contract FundMeTest {
//     FundMeFDRY fundMeFDRY;

//     function setUp() external {
//         // setup always runs first.
//         console.log("Deploying FundMeFDRY contract...");
//         fundMeFDRY = new FundMeFDRY();

//         console.log(
//             "FundMeFDRY contract deployed at address: ",
//             address(fundMeFDRY)
//         );
//     }

//     function testMinimumUSDToSend() public view {
//         uint256 expected = 10e18;
//         uint256 actual = fundMeFDRY.MINIMUM_USD_TO_SEND();
//         assert(expected == actual);
//     }

//     function testOwner() public view {
//         address expected = address(this); // the test setup is used to send the contract thus it is the owner and we are msg.sender right now as we called it thus we need to match it to this test files address not msg.sender

//         // address actual = msg.sender; // gives error
//         address actual = fundMeFDRY.i_owner();
//         assert(expected == actual);
//     }

//     function testAggregatorVersionIsAccurate() public view {
//         uint256 version = fundMeFDRY.getVersion();
//         console.log("Checking the version of the aggregator...",version);
//         assert(version == 4);
//     }
// }

// _______------------------------> NEW MODULAR CODE <-----------------------________
// __________________________________________________________________________________

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMeFDRY} from "../src/FundMeFDRY.sol";
import {DeployFundMeFDRY} from "../script/DeployFundMeFDRY.s.sol";

contract FundMeTest {
    FundMeFDRY fundMeFDRY;
    DeployFundMeFDRY deployFundMeFDRY;

    function setUp() external {
        console.log("Deploying FundMeFDRY contract...");
        deployFundMeFDRY = new DeployFundMeFDRY();
        fundMeFDRY = deployFundMeFDRY.run();
        console.log(
            "FundMeFDRY contract deployed at address: ",
            address(fundMeFDRY)
        );
    }

    function testMinimumUSDToSend() public view {
        uint256 expected = 10e18;
        uint256 actual = fundMeFDRY.MINIMUM_USD_TO_SEND();
        assert(expected == actual);
    }

    function testOwner() public view {
        // address expected = address(this);

        address expected =msg.sender;
        address actual = fundMeFDRY.i_owner();
        console.log("Expected address of owner: ", expected);
        console.log("Actual address of owner: ", actual);
        assert(expected == actual);
    }

    function testAggregatorVersionIsAccurate() public view {
        uint256 version = fundMeFDRY.getVersion();
        console.log("Checking the version of the aggregator...", version);
        assert(version == 4);
    }
}
