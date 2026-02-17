// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {GasTask} from "../project/src/GasTask.sol";

contract HiddenTest is Test {
    GasTask task;

    function setUp() public {
        task = new GasTask();
    }

    function testGasBelowThreshold() public {
        uint256[] memory nums = new uint256[](50);
        for (uint256 i = 0; i < nums.length; i++) {
            nums[i] = i + 1;
        }
        uint256 before = gasleft();
        uint256 total = task.sumAndStore(nums);
        uint256 used = before - gasleft();
        assertEq(total, 1275);
        // Encourage unchecked increment + cache length + memory reads
        assertLt(used, 15000);
    }
}
