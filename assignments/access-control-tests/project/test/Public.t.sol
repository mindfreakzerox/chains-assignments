// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Controlled} from "../src/Controlled.sol";

contract PublicTest is Test {
    Controlled ctrl;

    function setUp() public {
        ctrl = new Controlled();
    }

    function testAdminIsDeployer() public {
        assertEq(ctrl.admin(), address(this));
    }
}
