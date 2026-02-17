// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {PermitToken} from "../src/PermitToken.sol";

contract PublicTest is Test {
    PermitToken token;
    uint256 privateKey = 0xA11CE;
    address owner = vm.addr(privateKey);
    address spender = address(this);

    function setUp() public {
        token = new PermitToken();
        token.mint(owner, 100 ether);
    }

    function testPermitSetsAllowance() public {
        uint256 deadline = block.timestamp + 1 days;
        (uint8 v, bytes32 r, bytes32 s) = _sign(owner, spender, 50 ether, token.nonces(owner), deadline);
        token.permit(owner, spender, 50 ether, deadline, v, r, s);
        assertEq(token.allowance(owner, spender), 50 ether);
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
