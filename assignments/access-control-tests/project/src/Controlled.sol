// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Controlled {
    address public admin;
    mapping(address => bool) public operators;

    error NotAdmin();
    error NotOperator();

    constructor() {
        admin = msg.sender;
    }

    // TODO: allow admin to grant/revoke operators and protect setValue with operator-only access
    uint256 public value;
    function setValue(uint256 newValue) external {
        value = newValue;
    }
}
