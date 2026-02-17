// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Permit.sol";

contract PermitToken is ERC20, ERC20Permit {
    constructor() ERC20("PermitToken", "PERMIT") ERC20Permit("PermitToken") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function getPermitDigest(
        address owner,
        address spender,
        uint256 value,
        uint256 nonce,
        uint256 deadline
    ) external view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, nonce, deadline)));
    }
}
