// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.6.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

// Custom Errors
error AccountIsBlacklisted(address account);

contract RupiahToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    mapping(address => bool) public isBlacklisted;

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);

    constructor(address initialOwner) ERC20("RupiahToken", "IDRT") Ownable(initialOwner) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        // Check if the sender is blacklisted
        if (isBlacklisted[from]) {
            revert AccountIsBlacklisted(from);
        }

        // Check if the recipient is blacklisted
        if (isBlacklisted[to]) {
            revert AccountIsBlacklisted(to);
        }

        // If both sender and recipient are valid, apply the tax
        if (from != address(0) && to != address(0)) {
            uint256 tax = (value * 5) / 10000; // 0.05% tax
            uint256 amountAfterTax = value - tax;

            super._update(from, owner(), tax); // Send tax to owner
            super._update(from, to, amountAfterTax); // Send remaining to recipient
        } else {
            // For minting or burning, just call the parent function without tax
            super._update(from, to, value);
        }

        super._update(from, to, value);
    }

    function blacklist(address account) public onlyOwner {
        isBlacklisted[account] = true;
        emit Blacklisted(account);
    }

    function unBlacklist(address account) public onlyOwner {
        isBlacklisted[account] = false;
        emit UnBlacklisted(account);
    }
}
