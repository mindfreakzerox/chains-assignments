// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {CalldataTask} from "../src/CalldataTask.sol";

contract PublicTest is Test {
    CalldataTask task;

    function setUp() public {
        task = new CalldataTask();
    }

    function testSum() public {
        uint256[] memory nums = new uint256[](3);
        nums[0] = 1; nums[1] = 2; nums[2] = 3;
        uint256 total = task.sum(nums);
        assertEq(total, 6);
    }
}
