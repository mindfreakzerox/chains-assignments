// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vault {
    mapping(address => uint256) public balanceOf;
    bool internal locked;

    modifier nonReentrant() {
        require(!locked, "REENTRANT");
        locked = true;
        _;
        locked = false;
    }

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // TODO: make this withdraw safe against reentrancy (see tests)
    function withdraw() external virtual {
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "NO_FUNDS");
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "PAY_FAIL");
        balanceOf[msg.sender] = 0;
    }
}
