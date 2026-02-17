// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract HiddenSimpleStorageTest is Test {
    SimpleStorage internal simpleStorage;

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testAbiMatchesRequirements() public {
        string memory artifactPath = string.concat(vm.projectRoot(), "/out/SimpleStorage.sol/SimpleStorage.json");
        string memory json = vm.readFile(artifactPath);

        // Ensure only the expected function and event entries exist
        assertEq(_countOccurrences(json, '"type":"function"'), 2, "only two functions expected");
        assertEq(_countOccurrences(json, '"type":"event"'), 1, "only one event expected");

        _assertContains(json, '"name":"store"', "store function missing");
        _assertContains(json, '"name":"retrieve"', "retrieve function missing");
        _assertContains(json, '"name":"ValueChanged"', "ValueChanged event missing");

        _assertContains(json, '"stateMutability":"nonpayable"', "store must be nonpayable");
        _assertContains(json, '"stateMutability":"view"', "retrieve must be view");
        _assertContains(json, '"outputs":[{"internalType":"uint256"', "retrieve output must be uint256");
    }

    function testEmitsEventAndStoresValue() public {
        vm.expectEmit();
        emit SimpleStorage.ValueChanged(42);
        simpleStorage.store(42);
        assertEq(simpleStorage.retrieve(), 42, "value should update and be retrievable");
    }

    function testOverwritesStoredValue() public {
        simpleStorage.store(1);
        simpleStorage.store(999);
        assertEq(simpleStorage.retrieve(), 999, "value should be overwritable");
    }

    function _countOccurrences(string memory haystack, string memory needle) internal pure returns (uint256 count) {
        bytes memory h = bytes(haystack);
        bytes memory n = bytes(needle);
        if (n.length == 0 || h.length < n.length) return 0;

        for (uint256 i = 0; i <= h.length - n.length; i++) {
            bool matchAll = true;
            for (uint256 j = 0; j < n.length; j++) {
                if (h[i + j] != n[j]) {
                    matchAll = false;
                    break;
                }
            }
            if (matchAll) {
                count++;
            }
        }
    }

    function _assertContains(string memory haystack, string memory needle, string memory err) internal pure {
        require(_countOccurrences(haystack, needle) > 0, err);
    }
}
