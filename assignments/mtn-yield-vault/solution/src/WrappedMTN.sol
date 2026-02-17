// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";

/// @notice Wrapped MTN token controlled by the deposit contract.
contract WrappedMTN is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("Wrapped Metana", "wMTN") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }
}
