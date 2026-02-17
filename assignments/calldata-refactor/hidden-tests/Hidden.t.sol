// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {CalldataTask} from "../project/src/CalldataTask.sol";

contract HiddenTest is Test {
    CalldataTask task;

    function setUp() public {
        task = new CalldataTask();
    }

    function testGasBenefitFromCalldata() public {
        uint256 len = 120;
        uint256[] memory nums = new uint256[](len);
        for (uint256 i = 0; i < len; i++) {
            nums[i] = i + 1;
        }
        uint256 g1 = gasleft();
        task.sum(nums);
        uint256 used = g1 - gasleft();
        // Using calldata should avoid copying ~3k+ gas for this input size.
        // If implemented with memory copies, this threshold will likely be exceeded.
        assertLt(used, 16000);
    }

    function testPushMany() public {
        uint256[] memory nums = new uint256[](4);
        nums[0] = 5; nums[1] = 6; nums[2] = 7; nums[3] = 8;
        task.pushMany(nums);
        // call sum over empty array to avoid revert
        uint256 total = task.sum(nums);
        assertEq(total, 26);
    }
}
