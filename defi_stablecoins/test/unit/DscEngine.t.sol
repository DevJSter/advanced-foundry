// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { } from "../../script/Deploy.s.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStablecoin.sol";
import { DSCEngine } from "../../src/DSCEngine.sol";
import { HelperCConfig }  from "../../script/HelperCConfig.s.sol";

contract DSCEngineTest is Test {
    // Test functions go here


    Deploy deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dscEngine; 
    HelperCConfig helperConfig;
    addres ethUsdPriceFeed;
    address weth;


    function setUp public {
     deployer = new Deploy();
     (dsc, dscEngine, ) = deployer.run();
     (ethUsdPriceFeed, , weth, , ) = config.activateNetWorkConfig();
    }
     //////////
     // Price Test //
     //////////

     function testGetUsdValue() {
       uint256 ethAmount = 15e18; // 15 ETH
       // Assuming the price feed returns 2000 USD per ETH
       // This is a mock value, in a real scenario you would get this from the price feed contract
       uint256 expectedUsd = 30000e18; // 2000
      uint256 usdValue = dscEngine.getUsdValue(weth, ethAmount);
       assertEq(usdValue, expectedUsd, "USD value should be 30000 USD for 15 ETH at 2000 USD per ETH");
      
     }
    
}