// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CalldataTask {
    uint256[] internal store;

    function sum(uint256[] calldata values) external pure returns (uint256 total) {
        for (uint256 i = 0; i < values.length; i++) {
            total += values[i];
        }
    }

    function pushMany(uint256[] calldata values) external {
        for (uint256 i = 0; i < values.length; i++) {
            store.push(values[i]);
        }
    }
}
