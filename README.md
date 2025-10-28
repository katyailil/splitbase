# SplitBase

A minimal and transparent smart contract for **revenue sharing** on the Base L2 network.

## Overview
SplitBase lets you distribute incoming funds among multiple recipients using predefined shares (per-mille system, total = 1000).
It’s simple, gas-efficient, and deployable on Base testnet (Sepolia) or mainnet.

## Features
- Built with **Foundry**
- Includes unit tests (`forge test`)
- Ready for **CI** (GitHub Actions)
- Simple logic — anyone can send funds, recipients withdraw their portion

## Deploy (Base Sepolia)
Example `.env` setup:
```
PRIVATE_KEY=0x...
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org
RECIPIENTS=0x1111...,0x2222...
SHARES=600,400
```

Deploy command:
```
forge script script/Deploy.s.sol:Deploy --rpc-url base_sepolia --private-key $PRIVATE_KEY --broadcast
```

## Security
This contract has no external audit. Use at your own risk.

## License
MIT License © 2025
