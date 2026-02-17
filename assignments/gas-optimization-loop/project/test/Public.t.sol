// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {GasTask} from "../src/GasTask.sol";

contract PublicTest is Test {
    GasTask task;

    function setUp() public {
        task = new GasTask();
    }

    function testSum() public {
        uint256[] memory nums = new uint256[](3);
        nums[0] = 1; nums[1] = 2; nums[2] = 3;
        assertEq(task.sumAndStore(nums), 6);
        assertEq(task.acc(), 6);
    }
}
