# AlphaSkills Tutor → ChainShot Builder mapping

Assignments sourced from Tutor course revisions (IDs b1–a3 from the bootcamp track). Each Builder stage uses Foundry grading with a student scaffold, canonical solution, and hidden tests.

| Tutor ID | Tutor prompt | Builder stage slug | Notes |
| --- | --- | --- | --- |
| b1 | Draw the transaction lifecycle from EOA to state change. | _Gap_ | Non-code visualization assignment; not converted (needs manual review or alternate rubric). |
| b2 | Write a struct-based registry with add/get functions. | `struct-registry` | Beginner storage+events implementation. |
| b3 | Refactor a function to use calldata for inputs. | `calldata-refactor` | Measures gas usage to encourage calldata and minimal copies. |
| i1 | Patch a vulnerable withdraw function using CEI. | `reentrancy-vault` | Reentrancy-safe withdraw with nonReentrant guard. |
| i2 | Add indexed events to a token transfer function. | `indexed-events` | Deposit/withdraw events with indexed topics. |
| i3 | Write a Foundry test for access control on a function. | `access-control-tests` | Role-based access + revert-tested permissions. |
| a1 | Implement a UUPS upgradeable contract with initializer. | `uups-upgrade` | Owner-gated upgrades, storage preserved across versions. |
| a2 | Add permit() to an ERC20 and test replay protection. | `erc20-permit` | EIP-2612 permit with nonce/deadline enforcement. |
| a3 | Optimize a loop and compare gas before/after. | `gas-optimization-loop` | Gas threshold checks on loop implementation. |

Each stage lives under `assignments/<slug>/` with `assignment.json`, `project/` scaffold, `hidden-tests/`, and `solution/`.
