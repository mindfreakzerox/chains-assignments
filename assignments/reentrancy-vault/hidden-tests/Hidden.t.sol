// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Vault} from "../project/src/Vault.sol";

contract Attacker {
    Vault public vault;
    bool public attacking;

    constructor(Vault _vault) payable {
        vault = _vault;
    }

    function attack() external {
        attacking = true;
        vault.deposit{value: 0.1 ether}();
        vault.withdraw();
    }

    receive() external payable {
        if (attacking && address(vault).balance >= 0.05 ether) {
            vault.withdraw();
        }
    }
}

contract HiddenTest is Test {
    Vault vault;
    Attacker attacker;

    function setUp() public {
        vault = new Vault();
        vm.deal(address(vault), 0.5 ether);
        attacker = new Attacker(vault);
        vm.deal(address(attacker), 0.2 ether);
    }

    function testReentrancyPatched() public {
        vm.expectRevert();
        attacker.attack();
    }
}
