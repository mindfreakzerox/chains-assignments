// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Controlled} from "../project/src/Controlled.sol";

contract HiddenTest is Test {
    Controlled ctrl;
    address operator = address(0xBEEF);
    address stranger = address(0xCAFE);

    function setUp() public {
        ctrl = new Controlled();
    }

    function testOnlyAdminCanGrant() public {
        vm.prank(stranger);
        vm.expectRevert(Controlled.NotAdmin.selector);
        ctrl.setOperator(operator, true);
    }

    function testOperatorGate() public {
        ctrl.setOperator(operator, true);
        vm.prank(operator);
        ctrl.setValue(99);
        assertEq(ctrl.value(), 99);

        vm.prank(stranger);
        vm.expectRevert(Controlled.NotOperator.selector);
        ctrl.setValue(1);
    }

    function testRevoke() public {
        ctrl.setOperator(operator, true);
        ctrl.setOperator(operator, false);
        vm.prank(operator);
        vm.expectRevert(Controlled.NotOperator.selector);
        ctrl.setValue(5);
    }
}
