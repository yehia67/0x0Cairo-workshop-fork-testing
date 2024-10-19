# Uniswap Forking Tests - 0xCairo Workshop

This project demonstrates how to perform forking tests on Uniswap's deployed contracts using Foundry. The main focus is on testing factory contract and router interactions on the Ethereum mainnet.

## Overview

This project is part of the 0xCairo workshop series, specifically focusing on understanding and implementing forking tests in Foundry. We interact with deployed Uniswap contracts to perform various test cases against the live protocol.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)
- Basic understanding of Solidity and Uniswap V3
- Ethereum RPC endpoint (using publicnode.com in this example)

## Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

2. Install dependencies:
```bash
forge install Uniswap/v3-periphery 
forge install Uniswap/v3-core                                                          
forge install OpenZeppelin/openzeppelin-contracts
```

## Project Structure

```
├── src/
│   └── (your contract files)
├── test/
│   └── (your test files)
├── lib/
│   ├── v3-periphery/
│   ├── v3-core/
│   └── openzeppelin-contracts/
└── ...
```

## Running Tests

To run the forking tests, use the following command:

```bash
forge test --fork-url https://ethereum-rpc.publicnode.com --fork-block-number 20979202
```

This command:
- Creates a fork of Ethereum mainnet at block 20979202
- Uses publicnode.com as the RPC provider
- Runs all test cases against the forked state

## Test Cases

The test suite includes various scenarios for interacting with Uniswap's:
- Factory Contract
- Router Contract

## Important Contracts

Key Uniswap V3 contracts that we interact with:
- Factory: [0x1F98431c8aD98523631AE4a59f267346ea31F984](https://etherscan.io/address/0x1F98431c8aD98523631AE4a59f267346ea31F984)
- Router: [0xE592427A0AEce92De3Edee1F18E0157C05861564](https://etherscan.io/address/0xE592427A0AEce92De3Edee1F18E0157C05861564)

