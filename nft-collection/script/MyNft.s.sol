// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {BasicNft} from "../src/MyNft.sol";
contract s_DeployMyNFT is Script {
    function run() external returns(BasicNft){
        vm.startBroadcast();
        BasicNft d_basicNft = new BasicNft();
        vm.stopBroadcast();
        return d_basicNft;

    }
}