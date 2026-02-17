// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {MTN} from "../project/src/MTN.sol";
import {WrappedMTN} from "../project/src/WrappedMTN.sol";
import {MTNStaking} from "../project/src/MTNStaking.sol";
import {AutoCompoundVault} from "../project/src/AutoCompoundVault.sol";
import {DepositContract} from "../project/src/DepositContract.sol";

contract HiddenTest is Test {
    MTN mtn;
    WrappedMTN wMTN;
    MTNStaking staking;
    AutoCompoundVault vault;
    DepositContract depositor;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        mtn = new MTN();
        wMTN = new WrappedMTN();
        staking = new MTNStaking(mtn);
        vault = new AutoCompoundVault(wMTN, address(this));
        depositor = new DepositContract(mtn, wMTN, staking, vault);
        vault.setDepositor(address(depositor));

        wMTN.grantRole(wMTN.MINTER_ROLE(), address(depositor));
        wMTN.grantRole(wMTN.BURNER_ROLE(), address(depositor));

        mtn.mint(alice, 2_000 ether);
        vm.prank(alice);
        mtn.approve(address(depositor), type(uint256).max);
    }

    function _fundStakingRewards(uint256 reward) internal {
        mtn.mint(address(this), reward);
        mtn.approve(address(staking), reward);
        staking.notifyRewardAmount(reward);
    }

    function testHarvestStreamsVaultRewards() public {
        // Alice compounds 100 MTN
        vm.prank(alice);
        depositor.deposit(100 ether, alice, true);

        // Seed staking rewards and accrue for a day
        _fundStakingRewards(500 ether);
        vm.warp(block.timestamp + 1 days);

        // Harvest pushes rewards into vault and restakes
        depositor.harvest();

        // Vault should now have reward streaming configured
        assertGt(vault.rewardRate(), 0, "reward rate set");
        assertGt(wMTN.balanceOf(address(vault)), 100 ether, "reward minted to vault");

        vm.warp(block.timestamp + 1 days);
        uint256 before = wMTN.balanceOf(alice);
        vm.prank(alice);
        uint256 paid = vault.getReward();

        assertGt(paid, 0, "reward paid out");
        assertEq(wMTN.balanceOf(alice) - before, paid, "transfer matches reward");
    }

    function testNotifyRewardAmountUsesFreshBalance() public {
        vm.prank(alice);
        depositor.deposit(200 ether, alice, true);

        // mint additional wMTN directly to the vault to simulate new yield
        wMTN.grantRole(wMTN.MINTER_ROLE(), address(this));
        wMTN.mint(address(vault), 60 ether);

        depositor.harvest(); // should ignore if no staking rewards, but notify is allowed only for depositor
        
        // Manually trigger notify via depositor privileges
        vm.prank(address(depositor));
        vault.notifyRewardAmount();

        uint256 expectedRate = 60 ether / vault.REWARDS_DURATION();
        assertEq(vault.rewardRate(), expectedRate, "rate matches available rewards");

        vm.warp(block.timestamp + 1 days);
        uint256 rpt = vault.rewardPerToken();
        assertGt(rpt, 0, "rewardPerToken accrues");
    }

    function testUnauthorizedNotifyReverts() public {
        vm.prank(alice);
        depositor.deposit(50 ether, alice, true);

        vm.expectRevert();
        vault.notifyRewardAmount();
    }

    function testRedeemDrawsFromStaking() public {
        vm.prank(alice);
        depositor.deposit(150 ether, alice, false);

        vm.prank(alice);
        depositor.redeem(80 ether, bob);

        assertEq(staking.balanceOf(address(depositor)), 70 ether, "staking reduced");
        assertEq(mtn.balanceOf(bob), 80 ether, "bob received underlying");
    }
}
