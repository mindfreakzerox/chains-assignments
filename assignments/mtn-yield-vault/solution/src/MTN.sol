// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

/// @notice Simple mintable token used as the underlying asset.
contract MTN is ERC20, Ownable {
    constructor() ERC20("Metana", "MTN") {}

    /// @notice Owner-only mint helper for tests.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
