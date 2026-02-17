// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract PublicTest is Test {
    Vault vault;

    function setUp() public {
        vault = new Vault();
        vm.deal(address(this), 1 ether);
    }

    function testDepositWithdraw() public {
        vault.deposit{value: 0.25 ether}();
        assertEq(vault.balanceOf(address(this)), 0.25 ether);
        vault.withdraw();
        assertEq(vault.balanceOf(address(this)), 0);
    }
}
