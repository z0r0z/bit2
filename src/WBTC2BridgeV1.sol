// ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @dev Bridge contract.
/// @custom:coauthor z0r0z
/// @custom:coauthor 0xf4d3
contract WBTC2BridgeV1 {
    event Deposited(address depositor, uint256 amount);
    event Withdrawn(address depositor, uint256 amount);

    IERC20 constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);

    uint256 constant LOCK_TIME = 4 weeks;

    error UnlockPending();

    mapping(address => Deposit) public deposits;

    struct Deposit {
        uint128 amount;
        uint128 unlock;
    }

    function bridge(uint256 amount) public {
        WBTC.transferFrom(msg.sender, address(this), amount);
        unchecked {
            deposits[msg.sender].amount += uint128(amount);
            deposits[msg.sender].unlock = uint128(block.timestamp + LOCK_TIME);
        }
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        Deposit storage slip = deposits[msg.sender];
        if (block.timestamp < slip.unlock) revert UnlockPending();
        slip.amount -= uint128(amount);
        WBTC.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }
}

interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}
