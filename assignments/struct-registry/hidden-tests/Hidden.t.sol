// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Registry} from "../project/src/Registry.sol";

contract HiddenTest is Test {
    Registry registry;

    function setUp() public {
        registry = new Registry();
    }

    function testEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Registry.Registered(10, "carol", address(this), 99);
        registry.register(10, "carol", address(this), 99);
    }

    function testZeroAddressAllowedButTracked() public {
        registry.register(11, "zero", address(0), 0);
        (string memory name, address acct, uint256 score) = registry.get(11);
        assertEq(name, "zero");
        assertEq(acct, address(0));
        assertEq(score, 0);
    }

    function testRevertsOnMissing() public {
        vm.expectRevert("NOT_FOUND");
        registry.get(123);
    }
}
