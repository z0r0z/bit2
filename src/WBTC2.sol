// ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘ ⌘
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice WBTC for L2 execution contexts.
contract WBTC2 {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed from, address indexed to);

    string public constant name = "Wrapped BTC2";
    string public constant symbol = "WBTC2";
    uint256 public constant decimals = 18;
    uint256 public totalSupply;
    address public owner;

    error Unauthorized();

    constructor() payable {
        owner = tx.origin;
    }
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address to, uint256 amount) public payable returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public payable returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public payable returns (bool) {
        if (msg.sender != from)
            if (allowance[from][msg.sender] != type(uint256).max)
                allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) public payable onlyOwner {
        totalSupply += amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) public payable onlyOwner {
        balanceOf[from] -= amount;
        unchecked { totalSupply -= amount; }
        emit Transfer(from, address(0), amount);
    }

    function transferOwnership(address to) public payable onlyOwner {
        emit OwnershipTransferred(msg.sender, owner = to);
    }

    modifier onlyOwner {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }
}
