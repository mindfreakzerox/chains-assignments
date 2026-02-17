// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {
    struct Record {
        string name;
        address account;
        uint256 score;
    }

    mapping(uint256 => Record) private records;
    mapping(uint256 => bool) private exists;

    event Registered(uint256 indexed id, string name, address indexed account, uint256 score);

    // TODO: implement register and getters per the tests
}
