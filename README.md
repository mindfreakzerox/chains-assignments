# ChainShot Builder Sample Content (Foundry)

This repo is a minimal sample of how to organize a ChainShot Builder assignment using **Foundry** (`forge`). It includes:

- A single Solidity assignment (`simple-storage`)
- Student-facing project skeleton (Foundry)
- Hidden tests (for evaluator/CI)
- A canonical solution
- A project skeleton mapping file for the Builder
- A `testFixture` script to run the hidden test suite against a solution (handy for CI)

## Repository Layout

```
chains-assignments/
├─ assignments/
│  └─ simple-storage/
│     ├─ assignment.json         # Metadata + skeleton mapping
│     ├─ project/                # Student-facing scaffold (Foundry project)
│     │  ├─ src/
│     │  ├─ test/
│     │  ├─ foundry.toml
│     │  └─ README.md
│     ├─ hidden-tests/           # Private tests not exposed to students
│     └─ solution/               # Reference implementation (src/)
└─ scripts/
   └─ testFixture.js             # Runs public + hidden tests against a solution
```

### Assignment Overview: `simple-storage`
- **Goal:** Implement a basic storage contract with setter/getter and event emission.
- **Tooling:** Foundry (`forge`), `forge-std` test utilities.
- **Tests:**
  - `project/test/Public.t.sol` (visible)
  - `hidden-tests/Hidden.t.sol` (private)
- **ABI validation:** Hidden tests parse the compiled artifact to ensure only the required functions and event exist with correct mutability and types.

### Project Skeleton Mapping
See `assignments/simple-storage/assignment.json` for a concrete mapping of:
- Which files are student-facing
- Where hidden tests live
- Where the canonical solution resides

## Running Locally

```bash
cd assignments/simple-storage/project
forge install        # installs forge-std into ./lib
forge test           # runs visible tests
forge test -vv       # more verbose output (optional)
```

## CI Example (run `testFixture` against the solution)

```yaml
name: ci
on: [push, pull_request]
jobs:
  simple-storage:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: chains-assignments
    steps:
      - uses: actions/checkout@v4
      - uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable
      - name: Run test fixture against solution
        run: node scripts/testFixture.js simple-storage
```

`testFixture.js` will:
1. Copy the student project scaffold to a temp directory
2. Overlay the canonical solution
3. Copy in hidden tests
4. Install dependencies (`forge install`)
5. Execute both public and hidden tests via Foundry

## Notes
- This repo is a sample; extend with more assignments by copying the `simple-storage` layout.
- No WordPress or remote assets are touched — everything stays local to this repository.
