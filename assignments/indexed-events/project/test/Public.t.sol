// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract PublicTest is Test {
    Bank bank;

    function setUp() public {
        bank = new Bank();
        vm.deal(address(this), 1 ether);
    }

    function testDepositEvent() public {
        vm.expectEmit(true, false, false, true);
        emit Bank.Deposit(address(this), 0.1 ether);
        bank.deposit{value: 0.1 ether}();
    }
}
