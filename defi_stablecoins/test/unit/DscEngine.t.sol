// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { Deploy } from "../../script/Deploy.s.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { DSCEngine } from "../../src/DSCEngine.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { ERC20Mock } from "../mocks/ERC20.sol";

contract DSCEngineTest is Test {
    // Test functions go here

    Deploy deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dscEngine;
    HelperConfig helperConfig;
    address ethUsdPriceFeed;
    address weth;
    address btcUsdPriceFeed;

    // Constants
    address[] public tokenaddresses;
    address[] public priceFeedAddresses;
    address constant USER = address(1);
    uint256 amountCollateral = 10 ether;
    uint256 amountToMint = 100 ether;

    function setUp() public {
        deployer = new Deploy();
        (dsc, dscEngine, helperConfig) = deployer.run();
        (ethUsdPriceFeed,btcUsdPriceFeed, weth,,) = helperConfig.activeNetworkConfig();
    }
    
    //////////
    // Price Test //
    //////////

    function testGetUsdValue() public {
        uint256 ethAmount = 15e18; // 15 ETH
        // Assuming the price feed returns 2000 USD per ETH
        // This is a mock value, in a real scenario you would get this from the price feed contract
        uint256 expectedUsd = 30_000e18; // 2000
        uint256 usdValue = dscEngine.getUsdValue(weth, ethAmount);
        assertEq(usdValue, expectedUsd, "USD value should be 30000 USD for 15 ETH at 2000 USD per ETH");
    }

    
    function testRevertsIfTokenLengthDoesntMatchPriceFeeds() public {
        tokenaddresses.push(weth);
        priceFeedAddresses.push(ethUsdPriceFeed);
        priceFeedAddresses.push(btcUsdPriceFeed);

        vm.expectRevert(DSCEngine.DSCEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch.selector );
        new DSCEngine(tokenaddresses, priceFeedAddresses, address(dsc));

    }
    

    // Oracle Tests
    function testGetTokenAmountFromUsd() public {
        uint256 usdAmount = 100 ether;
        uint expectedWeth = 0.05 ether;
        uint256 actualWeth = dscEngine.getTokenAmountFromUsd(weth,usdAmount);
        assertEq(expectedWeth,  actualWeth);
    }


    // depositCollateral Tests
    function testRevertsIfCollateralIsZero() public {
        vm.startPrank(USER);
        ERC20Mock(weth).
        approve(address(dscEngine), amountCollateral);

        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        dscEngine.depositCollateral(weth, 0);
        vm.stopPrank();

    }


    function testRevertsIfCollateralIsAllowed() public {
        ERC20Mock meowToken = new ERC20Mock("MeowToken", "meow", USER, 1234567);
        vm.startPrank(USER);
        // assertEq(meowToken == )
        vm.expectRevert(DSCEngine.DSCEngine__TokenNotAllowed.selector);
        dscEngine.depositCollateral(address(meowToken),1234567);
        vm.stopPrank();
        

    }
}
