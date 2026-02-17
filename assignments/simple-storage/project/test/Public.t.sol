// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract PublicSimpleStorageTest is Test {
    SimpleStorage internal simpleStorage;

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testStartsAtZero() public {
        uint256 current = simpleStorage.retrieve();
        assertEq(current, 0, "initial value should be zero");
    }

    function testStoresValue() public {
        simpleStorage.store(7);
        uint256 current = simpleStorage.retrieve();
        assertEq(current, 7, "stored value should be retrievable");
    }
}
