// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC4626} from "openzeppelin-contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

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

    // --- hooks to implement ---

    function setDepositor(address newDepositor) external onlyOwner {
        depositor = newDepositor;
    }

    function notifyRewardAmount() external virtual {
        revert("TODO");
    }

    function getReward() public virtual returns (uint256) {
        revert("TODO");
    }

    function rewardPerToken() public view virtual returns (uint256) {
        return rewardPerTokenStored;
    }

    function earned(address account) public view virtual returns (uint256) {
        account; // silence warning
        return 0;
    }

    function lastTimeRewardApplicable() public view virtual returns (uint256) {
        return block.timestamp < periodFinish ? block.timestamp : periodFinish;
    }

    function _stake(uint256 amount) internal virtual {
        amount; // silence warning
        // track totalStaked on deposit
    }

    function _withdrawInternal(uint256 amount) internal virtual {
        amount; // silence warning
        // track totalStaked on withdraw
    }

    // Override to hook stake accounting + reward updates as needed
    function deposit(uint256 assets, address receiver) public virtual override returns (uint256) {
        assets; receiver; // silence warnings
        revert("TODO");
    }

    function withdraw(uint256 assets, address receiver, address owner) public virtual override returns (uint256) {
        assets; receiver; owner; // silence warnings
        revert("TODO");
    }

    function redeem(uint256 shares, address receiver, address owner) public virtual override returns (uint256) {
        shares; receiver; owner; // silence warnings
        revert("TODO");
    }

    function mint(uint256 shares, address receiver) public virtual override returns (uint256) {
        shares; receiver; // silence warnings
        revert("TODO");
    }
}
