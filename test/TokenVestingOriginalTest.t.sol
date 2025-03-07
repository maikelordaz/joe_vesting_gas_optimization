// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TokenVesting} from "src/original/TokenVesting.sol";
import {Test, console2} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract TokenVestingTest is Test {
    TokenVesting tokenVesting;
    MockERC20 token;

    uint256 start;
    uint256 cliff;
    uint256 duration;
    address beneficiary = makeAddr("beneficiary");

    function setUp() public {
        start = 1;
        cliff = 7;
        duration = 100;

        tokenVesting = new TokenVesting(
            beneficiary,
            start,
            cliff,
            duration,
            true
        );
        token = new MockERC20();
    }

    function testRelease() public {
        vm.warp(50);
        token.transfer(address(tokenVesting), 1_000e18);

        vm.prank(beneficiary);
        tokenVesting.release(IERC20(token));
    }

    function testRevoke() public {
        vm.warp(50);
        token.transfer(address(tokenVesting), 1_000e18);
        tokenVesting.release(token);

        tokenVesting.revoke(token);
    }

    function testEmergencyRevoke() public {
        vm.warp(50);
        token.transfer(address(tokenVesting), 1_000e18);

        tokenVesting.release(IERC20(token));
        tokenVesting.emergencyRevoke(IERC20(token));
    }
}
