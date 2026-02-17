// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    mapping(address => uint256) public balanceOf;

    // TODO: declare events Deposit(address indexed from, uint256 amount) and Withdraw(address indexed to, uint256 amount)

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
        // TODO: emit Deposit
    }

    function withdraw(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "INSUFFICIENT");
        balanceOf[msg.sender] -= amount;
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "PAY_FAIL");
        // TODO: emit Withdraw
    }
}
