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

    modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    modifier onlyOperator() {
        if (!operators[msg.sender]) revert NotOperator();
        _;
    }

    function setOperator(address op, bool allowed) external onlyAdmin {
        operators[op] = allowed;
    }

    uint256 public value;
    function setValue(uint256 newValue) external onlyOperator {
        value = newValue;
    }
}
