// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

/// @notice Single-token staking contract that pays rewards in the same token.
/// Synthetix-style reward math.
contract MTNStaking is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable stakingToken;

    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    uint256 public periodFinish;
    uint256 public constant REWARDS_DURATION = 7 days;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardAdded(uint256 reward);

    constructor(IERC20 _stakingToken) {
        stakingToken = _stakingToken;
    }

    // --- core logic to implement ---

    function stake(uint256 amount) public virtual {
        revert("TODO");
    }

    function withdraw(uint256 amount) public virtual {
        revert("TODO");
    }

    function getReward() public virtual {
        revert("TODO");
    }

    function exit() external virtual {
        // optional helper: withdraw + getReward
        revert("TODO");
    }

    function earned(address account) public view virtual returns (uint256) {
        account; // silence warning
        return 0;
    }

    function notifyRewardAmount(uint256 reward) external virtual {
        reward; // silence warning
        revert("TODO");
    }

    function lastTimeRewardApplicable() public view virtual returns (uint256) {
        return block.timestamp;
    }

    function rewardPerToken() public view virtual returns (uint256) {
        return rewardPerTokenStored;
    }
}
