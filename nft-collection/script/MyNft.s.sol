// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {MyNft} from "../src/MyNft.sol";
contract DeployMyNFT is Script {
    function deploy() external returns(MyNft){
        vm.startBroadcast();
        MyNft mynft = new MyNft();
        vm.stopBroadcast();
        return mynft;
    }
}