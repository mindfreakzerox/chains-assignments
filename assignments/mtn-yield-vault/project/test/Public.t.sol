// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {MTN} from "../src/MTN.sol";
import {WrappedMTN} from "../src/WrappedMTN.sol";
import {MTNStaking} from "../src/MTNStaking.sol";
import {AutoCompoundVault} from "../src/AutoCompoundVault.sol";
import {DepositContract} from "../src/DepositContract.sol";

contract PublicTest is Test {
    MTN mtn;
    WrappedMTN wMTN;
    MTNStaking staking;
    AutoCompoundVault vault;
    DepositContract depositor;

    address user = address(0xBEEF);

    function setUp() public {
        mtn = new MTN();
        wMTN = new WrappedMTN();
        staking = new MTNStaking(mtn);
        vault = new AutoCompoundVault(wMTN, address(this));
        depositor = new DepositContract(mtn, wMTN, staking, vault);
        vault.setDepositor(address(depositor));

        // wire roles
        wMTN.grantRole(wMTN.MINTER_ROLE(), address(depositor));
        wMTN.grantRole(wMTN.BURNER_ROLE(), address(depositor));

        // fund user
        mtn.mint(user, 1_000 ether);
        vm.prank(user);
        mtn.approve(address(depositor), type(uint256).max);
    }

    function test_DepositMintsWrapped() public {
        vm.prank(user);
        depositor.deposit(100 ether, user, false);

        assertEq(wMTN.balanceOf(user), 100 ether, "wMTN minted");
        assertEq(staking.balanceOf(address(depositor)), 100 ether, "staked on deposit");
    }

    function test_RedeemBurnsWrapped() public {
        vm.startPrank(user);
        depositor.deposit(200 ether, user, false);
        depositor.redeem(120 ether, user);
        vm.stopPrank();

        assertEq(wMTN.balanceOf(user), 80 ether, "remaining wrapped");
        assertEq(mtn.balanceOf(user), 920 ether, "underlying returned");
    }

    function test_CompoundMintsVaultShares() public {
        vm.prank(user);
        uint256 shares = depositor.deposit(250 ether, user, true);

        assertGt(shares, 0, "vault shares minted");
        assertEq(vault.totalAssets(), 250 ether, "vault holds assets");
    }
}
