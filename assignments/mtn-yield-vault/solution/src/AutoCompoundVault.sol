// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC4626} from "openzeppelin-contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {Math} from "openzeppelin-contracts/utils/math/Math.sol";

/// @notice ERC-4626 vault for wMTN with streaming rewards controlled by the deposit contract.
contract AutoCompoundVault is ERC4626, Ownable {
    uint256 public constant REWARDS_DURATION = 7 days;

    address public depositor; // deposit contract that can notify rewards

    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    uint256 public periodFinish;
    uint256 public totalStaked;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event RewardAdded(uint256 reward);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(IERC20 asset_, address depositor_) ERC20("Auto Metana", "aMTN") ERC4626(asset_) {
        depositor = depositor_;
    }

    modifier onlyDepositor() {
        require(msg.sender == depositor, "NOT_DEPOSITOR");
        _;
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function setDepositor(address newDepositor) external onlyOwner {
        depositor = newDepositor;
    }

    function notifyRewardAmount() external virtual onlyDepositor updateReward(address(0)) {
        // New rewards = balance - backing for staked assets - still-unlocked rewards
        uint256 balance = IERC20(asset()).balanceOf(address(this));
        uint256 remaining = block.timestamp >= periodFinish ? 0 : (periodFinish - block.timestamp) * rewardRate;
        uint256 backing = totalStaked;
        uint256 available = balance > backing ? balance - backing : 0;
        require(available > remaining, "NO_NEW_REWARD");
        uint256 reward = available - remaining;

        rewardRate = reward / REWARDS_DURATION;
        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp + REWARDS_DURATION;
        emit RewardAdded(reward);
    }

    function getReward() public virtual updateReward(msg.sender) returns (uint256) {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        if (reward > 0) {
            IERC20(asset()).transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
        return reward;
    }

    function rewardPerToken() public view virtual returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18) / totalStaked;
    }

    function earned(address account) public view virtual returns (uint256) {
        return ((balanceOf(account) * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) + rewards[account];
    }

    function lastTimeRewardApplicable() public view virtual returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function _stake(uint256 amount) internal virtual {
        totalStaked += amount;
    }

    function _withdrawInternal(uint256 amount) internal virtual {
        totalStaked -= amount;
    }

    function deposit(uint256 assets, address receiver) public virtual override updateReward(receiver) returns (uint256) {
        _stake(assets);
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public virtual override updateReward(receiver) returns (uint256) {
        uint256 assets = previewMint(shares);
        _stake(assets);
        return super.mint(shares, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner)
        public
        virtual
        override
        updateReward(owner)
        returns (uint256)
    {
        _withdrawInternal(assets);
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner)
        public
        virtual
        override
        updateReward(owner)
        returns (uint256)
    {
        uint256 assets = previewRedeem(shares);
        _withdrawInternal(assets);
        return super.redeem(shares, receiver, owner);
    }
}
