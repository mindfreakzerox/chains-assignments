// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {UpgradableBox} from "../src/UpgradableBox.sol";
import {ERC1967Proxy} from "openzeppelin-contracts-upgradeable/proxy/ERC1967/ERC1967Proxy.sol";

contract PublicTest is Test {
    UpgradableBox impl;
    UpgradableBox proxyBox;

    function setUp() public {
        impl = new UpgradableBox();
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), abi.encodeCall(UpgradableBox.initialize, (1)));
        proxyBox = UpgradableBox(address(proxy));
    }

    function testInitialized() public {
        assertEq(proxyBox.value(), 1);
    }
}
