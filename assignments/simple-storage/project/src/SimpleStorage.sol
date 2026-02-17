// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleStorage
/// @notice Store and retrieve a single unsigned integer value.
/// Requirements:
/// - Store an initial value of 0
/// - `store(uint256 newValue)` updates storage and emits `ValueChanged(newValue)`
/// - `retrieve()` returns the last stored value
/// - Keep the ABI minimal: only `store`, `retrieve`, and the `ValueChanged` event
contract SimpleStorage {
    // TODO: add a private uint256 state variable to hold the stored value

    /// @dev Emitted whenever a new value is stored.
    event ValueChanged(uint256 newValue);

    /// @notice Write a new value to storage.
    /// @param newValue The value to store.
    function store(uint256 newValue) external {
        // TODO: update storage and emit ValueChanged
    }

    /// @notice Read the last stored value.
    /// @return The currently stored value.
    function retrieve() external view returns (uint256) {
        // TODO: return the stored value
        return 0;
    }
}
