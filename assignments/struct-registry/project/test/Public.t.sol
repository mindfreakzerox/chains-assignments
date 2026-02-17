// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Registry} from "../src/Registry.sol";

contract PublicTest is Test {
    Registry registry;

    function setUp() public {
        registry = new Registry();
    }

    function testRegisterAndGet() public {
        registry.register(1, "alice", address(0xBEEF), 42);
        (string memory name, address acct, uint256 score) = registry.get(1);
        assertEq(name, "alice");
        assertEq(acct, address(0xBEEF));
        assertEq(score, 42);
    }

    function testCannotOverwrite() public {
        registry.register(2, "bob", address(0xCAFE), 5);
        vm.expectRevert();
        registry.register(2, "bob", address(0xCAFE), 6);
    }
}
