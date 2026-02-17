// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Bank} from "../project/src/Bank.sol";

contract HiddenTest is Test {
    Bank bank;

    function setUp() public {
        bank = new Bank();
        vm.deal(address(this), 2 ether);
        bank.deposit{value: 1 ether}();
    }

    function testWithdrawEventIndexed() public {
        vm.recordLogs();
        bank.withdraw(0.4 ether);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bool saw;
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics.length > 0 && entries[i].topics[0] == keccak256("Withdraw(address,uint256)")) {
                // topic1 should be indexed address
                assertEq(address(uint160(uint256(entries[i].topics[1]))), address(this));
                saw = true;
            }
        }
        assertTrue(saw, "missing Withdraw event");
    }
}
