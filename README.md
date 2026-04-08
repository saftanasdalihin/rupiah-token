# IDRT - Rupiah Token (ERC-20)

A professional-grade, secure, and gas-optimized Rupiah-pegged stablecoin implementation. Built with **Solidity 0.8.27** and the **Foundry** development framework.

## 🚀 Features

- **ERC-20 Standard**: Full compatibility with the standard Ethereum token interface.
- **OpenZeppelin Integration**: Leverages industry-standard libraries for `Ownable`, `Pausable`, `ERC20Burnable`, and `ERC20Pausable`.
- **Transaction Tax (Revenue Model)**: Automatic **0.05%** service fee redirected to the owner for every peer-to-peer transfer.
- **Security Blacklisting**: Ability for the owner to freeze specific addresses to prevent illicit activities.
- **Gas Optimized**: Implementation of **Custom Errors** instead of string-based `require` to significantly reduce gas costs during reverts.

## 🛠 Tech Stack

- **Language**: Solidity ^0.8.27
- **Framework**: [Foundry](https://book.getfoundry.sh/) (Forge)
- **Library**: [OpenZeppelin Contracts v5.x](https://openzeppelin.com/contracts/)

## 📈 Design Choices

### 1. Gas Efficiency
Instead of using standard `require("Error Message")`, this contract utilizes `error AccountIsBlacklisted(address account)`. This reduces the bytecode size and deployment costs while saving gas for the end-user.

### 2. Tax Logic Implementation
The tax is calculated using **Fixed Point Math** `(value * 5 / 10000)` to handle percentages without floating-point numbers. The logic is hooked into the internal `_update` function to ensure it captures all transfer types (excluding Mint and Burn).

## 🧪 Testing

This project follows a strict **Test-Driven Development (TDD)** approach. The test suite covers minting logic, blacklist enforcement, and tax calculation accuracy.

### Run Tests

To execute the test suite, ensure you have Foundry installed, then run:

```bash
forge test -vv
```

### Test Results

- `testMinting()`: ✅ Passed
- `testTaxOnTransfer()`: ✅ Passed
- `testBlacklisting()`: ✅ Passed

## 📜 License

Distributed under the MIT License.
