// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {UpgradableBox} from "../project/src/UpgradableBox.sol";
import {ERC1967Proxy} from "openzeppelin-contracts-upgradeable/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradableBoxV2 is UpgradableBox {
    uint256 public extra;

    function setExtra(uint256 _extra) external {
        extra = _extra;
    }
}

contract HiddenTest is Test {
    UpgradableBox impl;
    UpgradableBox proxyBox;

    function setUp() public {
        impl = new UpgradableBox();
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), abi.encodeCall(UpgradableBox.initialize, (123)));
        proxyBox = UpgradableBox(address(proxy));
    }

    function testOnlyOwnerCanUpgrade() public {
        UpgradableBoxV2 v2 = new UpgradableBoxV2();
        vm.prank(address(0xBEEF));
        vm.expectRevert();
        proxyBox.upgradeTo(address(v2));
    }

    function testUpgradeKeepsStorage() public {
        UpgradableBoxV2 v2 = new UpgradableBoxV2();
        proxyBox.setValue(555);
        proxyBox.upgradeTo(address(v2));
        UpgradableBoxV2 proxyV2 = UpgradableBoxV2(address(proxyBox));
        assertEq(proxyV2.value(), 555, "storage not preserved");
        proxyV2.setExtra(7);
        assertEq(proxyV2.extra(), 7);
    }
}
