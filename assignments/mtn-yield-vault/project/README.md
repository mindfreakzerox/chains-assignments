# Yield Vault with Deposit Router (ERC-4626)

Build a small DeFi stack:

- **MTN**: plain ERC20 with `mint()` for the deployer.
- **wMTN**: wrapped token with `MINTER_ROLE` / `BURNER_ROLE` (AccessControl).
- **MTNStaking**: single-token staking that streams MTN rewards (Synthetix-style math).
- **AutoCompoundVault**: ERC-4626 vault over wMTN that can stream newly minted rewards to depositors (`notifyRewardAmount`, `rewardPerToken`, `earned`, `_stake`, `_withdrawInternal`, `harvest/getReward`). Only the deposit contract may start new reward periods.
- **DepositContract**: takes MTN deposits, stakes MTN into the staking contract, mints/burns wMTN 1:1, optionally deposits wMTN into the vault for auto-compounding, and harvests staking rewards back into the vault (mint wMTN to the vault and call `notifyRewardAmount`).

Key behaviors to satisfy:

1. `deposit(uint256 assets, address receiver, bool compound)`
   - Transfer `assets` MTN from `msg.sender`.
   - Stake MTN into `MTNStaking`.
   - If `compound == false`: mint `assets` wMTN to `receiver`.
   - If `compound == true`: mint `assets` wMTN to the vault, then deposit them so `receiver` gets aMTN shares.
2. `redeem(uint256 assets, address receiver)`
   - Burn caller's wMTN, withdraw that much MTN from staking, send MTN to `receiver`.
3. `harvest()`
   - Claim MTN rewards from staking, re-stake them, mint the same amount of wMTN to the vault, and call `notifyRewardAmount()` on the vault.
4. Vault reward math
   - Track `totalStaked` on deposits/withdrawals.
   - `notifyRewardAmount` should treat "new rewards" as the vault's wMTN balance minus the backing for staked deposits and any still-unlocked rewards. Use `REWARDS_DURATION` to set `rewardRate` and update `periodFinish`/`lastUpdateTime`.
   - Implement `earned`, `rewardPerToken`, `lastTimeRewardApplicable`, `getReward`, and helper `_stake` / `_withdrawInternal`.

Use Solidity ^0.8.23 and OpenZeppelin 5.x. The public tests cover basic deposit/redeem/compound flows; hidden tests validate reward streaming, access control, and math edge cases.
