// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

/// @title SplitBaseUpgradeable - UUPS upgradeable revenue splitter for Base
contract SplitBaseUpgradeable is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    address[] private recipients;
    uint256[] private shares; // permille, sum = 1000
    uint256 public constant TOTAL_SHARES = 1000;

    mapping(address => uint256) public released;
    uint256 public totalReceived;

    error InvalidParams();
    error NothingToRelease();

    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentReleased(address indexed to, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address[] memory _recipients, uint256[] memory _shares, address initialOwner) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(initialOwner);

        if (_recipients.length == 0 || _recipients.length != _shares.length) revert InvalidParams();
        uint256 sum;
        for (uint256 i; i < _recipients.length; i++) {
            if (_recipients[i] == address(0) || _shares[i] == 0) revert InvalidParams();
            recipients.push(_recipients[i]);
            shares.push(_shares[i]);
            sum += _shares[i];
        }
        if (sum != TOTAL_SHARES) revert InvalidParams();
    }

    receive() external payable {
        totalReceived += msg.value;
        emit PaymentReceived(msg.sender, msg.value);
    }

    function pending(address account) public view returns (uint256) {
        uint256 idx = _indexOf(account);
        uint256 entitled = (totalReceived * shares[idx]) / TOTAL_SHARES;
        return entitled - released[account];
    }

    function release(address payable account) public {
        uint256 amount = pending(account);
        if (amount == 0) revert NothingToRelease();
        released[account] += amount;
        (bool ok, ) = account.call{value: amount}("");
        require(ok, "Transfer failed");
        emit PaymentReleased(account, amount);
    }

    function getRecipients() external view returns (address[] memory, uint256[] memory) {
        return (recipients, shares);
    }

    function _indexOf(address account) internal view returns (uint256) {
        for (uint256 i; i < recipients.length; i++) {
            if (recipients[i] == account) return i;
        }
        revert("Not a recipient");
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    uint256[50] private __gap;
}
