// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {PermitToken} from "../project/src/PermitToken.sol";

contract HiddenTest is Test {
    PermitToken token;
    uint256 privateKey = 0xB0B;
    address owner = vm.addr(privateKey);
    address spender = address(0xFEED);

    function setUp() public {
        token = new PermitToken();
        token.mint(owner, 100 ether);
    }

    function testReplayFails() public {
        uint256 deadline = block.timestamp + 1 days;
        uint256 nonce = token.nonces(owner);
        (uint8 v, bytes32 r, bytes32 s) = _sign(owner, spender, 10 ether, nonce, deadline);
        token.permit(owner, spender, 10 ether, deadline, v, r, s);
        // replay same signature should revert due to nonce mismatch
        vm.expectRevert();
        token.permit(owner, spender, 10 ether, deadline, v, r, s);
    }

    function testDeadlineEnforced() public {
        uint256 deadline = block.timestamp - 1;
        (uint8 v, bytes32 r, bytes32 s) = _sign(owner, spender, 5 ether, token.nonces(owner), deadline);
        vm.expectRevert();
        token.permit(owner, spender, 5 ether, deadline, v, r, s);
    }

    function _sign(address _owner, address _spender, uint256 _value, uint256 _nonce, uint256 _deadline)
        internal
        view
        returns (uint8, bytes32, bytes32)
    {
        bytes32 digest = token.getPermitDigest(_owner, _spender, _value, _nonce, _deadline);
        return vm.sign(privateKey, digest);
    }
}
