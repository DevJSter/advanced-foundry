### Topics

✅

🤔

### Curve

- [ ] AMM
  - [ ] Curve v1
    - [ ] Math
    - [ ] Swap
    - [ ] Add / remove liquidity
    - [ ] TWAP🤔
  - [ ] Curve v2🤔
    - [ ] Math
  - [ ] dy / dx = dfdx / dfdy 🤔
  - [ ] Summary

### Curve resources

- [Curve](https://resources.curve.fi/)

### TODOs

- [ ] MEV
  - [ ] Front run, back run and sandwich examples
  - [ ] Flashbots RPC example
  - [ ] MEV sandwicsh uni v2 🤔
  - [ ] Summary
- [ ] Price oracle ✅
  - [ ] Chainlink
- [ ] Stablecoin ✅
  - [ ] DAI
    - [ ] Overview
    - [ ] CDP and vaults
    - [ ] Math (wad, ray, rad)
    - [ ] Debt math
    - [ ] Contract overview
    - [ ] Add collateral
    - [ ] Borrow
    - [ ] Repay
    - [ ] Liquidation, math and auction
    - [ ] Debt auction
    - [ ] Surplus auction
    - [ ] DSR (math)
    - [ ] PSM
    - [ ] Flash
    - [ ] Flash mint DAI -> Sell DAI for USDC on Uniswap -> Sell USDC to PSM -> Repay flash loan
    - [ ] What can we do with DAI and Maker protocol?🤔
    - [ ] Leverage🤔
    - [ ] Endgame? 🤔
    - [ ] OSM? 🤔
    - [ ] RWA?
    - [ ] SKY?
    - [ ] Summary
- [ ] Lending
  - [ ] AAVE 🚧
    - [ ] supply
    - [ ] borrow
    - [ ] repay
    - [ ] withdraw
    - [ ] flash loan
    - [ ] liquidation
    - [ ] GHO 🤔
    - [ ] portal 🤔
    - [ ] stake AAVE 🤔
    - [ ] govenance 🤔
    - [ ] apps -> flash loan, farm gov tokens, leverage, short 🤔
  - [ ] Compound 🤔
  - [ ] Flash loan
  - [ ] Rebase tokens
  - [ ] Summary
- [ ] Liquid staking 🚧
  - [ ]Lido
  - [ ]Rocket pool 🤔

## TODOs 🤔

- [ ] Compound
- [ ] TWAMM
- [ ] AAVE GHO
- [ ] Curve stablecoin
- [ ] Curve VE gauge🤔 (liquidity -> better price for users -> more trade -> more fee -> more liquidity)?
- [ ] RAI
- [ ] Dex aggregator (CowSwap, ParaSwap)

- How to cover theses topics?
  - Algorithms used in DeFi
    - AMM
    - Vault
    - Staking rewards (discrete and time based)
    - DAI interest rate
    - Dutch auction
    - English and Dutch auction
- DEX agg - cow swap, paraswap?

#### Aave

- [Aave](https://aave.com/)
- [Aave Unleashed](https://calnix.gitbook.io/aave-unleashed/)
- [Aave V3 Made Crystal Clear](https://www.youtube.com/watch?v=UzuZp3Q3xg0)

### Foundry

```shell
forge init --no-commit
forge build
forge test --fork-url $FORK_URL \
--match-path test/path/to/Fork.t.sol \
--match-test name_of_test \
-vvv
```
