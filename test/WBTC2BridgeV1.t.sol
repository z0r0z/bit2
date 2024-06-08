// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {WBTC2BridgeV1} from "../src/WBTC2BridgeV1.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract WBTC2BridgeV1Test is Test {
    WBTC2BridgeV1 internal bridge;

    address constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function setUp() public payable {
        vm.createSelectFork(vm.rpcUrl("main")); // Ethereum mainnet fork.
        bridge = new WBTC2BridgeV1();
    }

    function testDeploy() public payable {
        new WBTC2BridgeV1();
    }
}
