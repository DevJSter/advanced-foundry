// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { DecentralizedStablecoin } from "../src/DecentralizedStablecoin.sol";
import { DSCEngine } from "../src/DSCEngine.sol";
import { Script } from "forge-std/Script.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        DecentralizedStablecoin dsc = new DecentralizedStablecoin();
        // DSCEngine dscEngine = new DSCEngine(dsc);
        vm.stopBroadcast();
    }
    
}