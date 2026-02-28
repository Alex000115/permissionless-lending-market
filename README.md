# Permissionless Lending Market

This repository contains the core smart contracts for a decentralized lending protocol. It operates on a peer-to-pool basis, allowing for continuous liquidity and automated interest rate discovery.

## Protocol Mechanics
* **Supplying:** Users deposit supported ERC-20 tokens into the pool and receive yield-bearing "mTokens."
* **Borrowing:** Users can withdraw a different asset up to their "Loan-to-Value" (LTV) limit, provided they have sufficient collateral.
* **Interest Rate Model:** Rates adjust dynamically based on the utilization ratio ($U$). When demand is high, interest rates rise to encourage deposits.
* **Liquidations:** If a borrower's health factor drops below 1, their collateral is eligible for liquidation by third parties at a discount.



## Core Features
* **Non-Custodial:** Users maintain full control over their funds through smart contract logic.
* **Variable Interest Rates:** Optimized for capital efficiency using a kinked interest rate curve.
* **Price Oracle Integration:** Uses Chainlink oracles to fetch real-time asset prices for health factor calculations.

## Getting Started
1. Deploy the `LendingPool.sol` contract.
2. Register supported assets via the `Governance` role.
3. Configure LTV and Liquidation Thresholds for each asset.
