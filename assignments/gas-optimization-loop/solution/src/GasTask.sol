// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasTask {
    uint256 public acc;

    function sumAndStore(uint256[] memory nums) public returns (uint256 total) {
        uint256 len = nums.length;
        for (uint256 i; i < len; ) {
            total += nums[i];
            unchecked {
                i++;
            }
        }
        acc = total;
    }
}
