# SplitBase (UUPS Upgradeable)

A minimal, upgradeable revenue splitter for the **Base** network (L2, Coinbase).  
Recipients withdraw their share on demand; shares are set in permille (sum = 1000).

---

## Deployed Contracts

### Base Mainnet
- Implementation: `0x9fad7fe258a4a14b043fcd8a9febc3fd071aa529`
- Proxy (use this address): `0xd59d94632381bb206667d1cc594db412193e27b1`
- Explorer: https://basescan.org/address/0xd59d94632381bb206667d1cc594db412193e27b1

### Base Sepolia (testnet)
- Implementation: `0x9fad7fe258a4a14b043fcd8a9febc3fd071aa529`
- Proxy (use this address): `0xd59d94632381bb206667d1cc594db412193e27b1`
- Explorer: https://sepolia.basescan.org/address/0xd59d94632381bb206667d1cc594db412193e27b1

---

## How it works

Anyone can send ETH to the proxy (the contract receives funds).  
Recipients withdraw using `release(<address>)`, which transfers their accrued share.

- Shares are in **permille** (e.g., `600,400` = 60%/40%).  
- The sum of all `SHARES` must be exactly **1000**.

## Security Notes

No third-party audit. Use at your own risk.
For production, set the proxy owner to a Gnosis Safe (multisig).
Preserve storage layout for upgrades.

##License
MIT © 2025
