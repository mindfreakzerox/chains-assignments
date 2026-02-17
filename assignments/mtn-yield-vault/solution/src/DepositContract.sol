// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

import {MTNStaking} from "./MTNStaking.sol";
import {AutoCompoundVault} from "./AutoCompoundVault.sol";
import {WrappedMTN} from "./WrappedMTN.sol";

/// @notice Deposit contract that stakes MTN, wraps to wMTN, and feeds rewards into the auto-compounding vault.
contract DepositContract is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable mtn;
    WrappedMTN public immutable wMTN;
    MTNStaking public immutable staking;
    AutoCompoundVault public immutable vault;

    event Deposited(address indexed sender, address indexed receiver, uint256 assets, bool compound);
    event Redeemed(address indexed sender, address indexed receiver, uint256 assets);
    event Harvested(uint256 reward);

    constructor(IERC20 _mtn, WrappedMTN _wMTN, MTNStaking _staking, AutoCompoundVault _vault) {
        mtn = _mtn;
        wMTN = _wMTN;
        staking = _staking;
        vault = _vault;
    }

    /// @notice Deposit MTN, stake it, and optionally auto-compound via the vault.
    function deposit(uint256 assets, address receiver, bool compound) external virtual returns (uint256 mintedOrShares) {
        require(assets > 0, "ZERO_ASSETS");

        mtn.safeTransferFrom(msg.sender, address(this), assets);
        mtn.safeIncreaseAllowance(address(staking), assets);
        staking.stake(assets);

        if (compound) {
            wMTN.mint(address(this), assets);
            wMTN.approve(address(vault), assets);
            mintedOrShares = vault.deposit(assets, receiver);
        } else {
            mintedOrShares = assets;
            wMTN.mint(receiver, assets);
        }

        emit Deposited(msg.sender, receiver, assets, compound);
    }

    /// @notice Burn wMTN and withdraw underlying MTN from staking back to the receiver.
    function redeem(uint256 assets, address receiver) external virtual returns (uint256) {
        require(assets > 0, "ZERO_ASSETS");

        wMTN.burnFrom(msg.sender, assets);
        staking.withdraw(assets);
        mtn.safeTransfer(receiver, assets);

        emit Redeemed(msg.sender, receiver, assets);
        return assets;
    }

    /// @notice Claim staking rewards, re-stake them, and stream wMTN into the vault.
    function harvest() public virtual returns (uint256 reward) {
        staking.getReward();
        reward = mtn.balanceOf(address(this));

        if (reward > 0) {
            mtn.safeIncreaseAllowance(address(staking), reward);
            staking.stake(reward);
            wMTN.mint(address(vault), reward);
            vault.notifyRewardAmount();
        }

        emit Harvested(reward);
    }
}
