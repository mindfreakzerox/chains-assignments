// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasTask {
    uint256 public acc;

    // TODO: optimize this loop to minimize gas while computing a sum
    function sumAndStore(uint256[] memory nums) public returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < nums.length; i++) {
            total += nums[i];
        }
        acc = total;
        return total;
    }
}
