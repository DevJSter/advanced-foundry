// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { DecentralizedStablecoin } from "../src/DecentralizedStablecoin.sol";
import { ReentrancyGuard } from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/*
    * @title Decentralized Stablecoin  
    *@author 0xShubham
    * The sysytem is designed to be as minimal as possinle, and jhave tokens maintain a dollar 1 == $1.00 
    * - Exogenous collateral 
    * Dollar pegged (Dependent upon the collateral of dollar)
    * Algorithimically stabolized 
    * It is similar to DAi had no governance and mp gees amd was only backed by wEth(wrapped Eth)
    * @notice Thiis contract is a core of the DSC sytem , handles all the logic 
    * @notice 
    * Our DSc system should be always be "Overcollayeralized" . At no point should the value of all collateral <=
    the $ backed by value of DSC
*/

abstract contract DSCEngine is ReentrancyGuard, IERC20 {
    //////////
    // Errors//
    //////////
    error DSCENGINE_TOkenAddressesAndPriceFeedAddressShouldBeSameLength();
    error DSCENGINE_MustbeMoreThanZero();
    error DSCEngine_TokenNotAllowed();
    error DSCEngine_TransferFailed();

    //////////////
    // State Variables //
    //////////////

    mapping(address token => address pricefeed) private s_priceFeeds; //tokentoPRiceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    DecentralizedStablecoin private immutable i_dsc; // DSC Token

    ///////////////
    // Events ////
    //////////////

    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    //////////////
    // Modifiers //
    //////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCENGINE_MustbeMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address tokenAddress) {
        if (s_priceFeeds[tokenAddress] == address(0)) {
            revert DSCEngine_TokenNotAllowed();
        }
        _;
    }

    /////////////
    // FUnctions//
    /////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        // USD PRice Feeds
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCENGINE_TOkenAddressesAndPriceFeedAddressShouldBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DecentralizedStablecoin(dscAddress);
    }

    //////////////////////
    // External FUnctions//
    //////////////////////

    function depositAndMintCollateralDSC() external {
        // Deposit collateral and mint DSC
        /*
            * @notice  : follows CET - Checks Effects Interaction
            * @param tokenCollateralAddress : Address of the token to be deposited
            * @param _amount : Amount of the token to be deposited
            * @param _mintAmount : Amount of DSC to be minted
            * @param _mintTo : Address to mint DSC to 
        */
    }

    function depositCollateral(
        address tokenCollateralAddress,
        uint256 _amount
    )
        external
        moreThanZero(_amount)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += _amount;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, _amount);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender , address(this),_amount);
        if (!success) {
            revert DSCEngine_TransferFailed();
        }
    }

    function redeemCollateralDSC() external { }

    function mintDSC() external { }
    function redeemCollateralAndDSC() external {
        // Redeem DSC and burn
    }
    // THreshold lets say 150%

    function burnDSC() external {
        // Burn DSC
    }

    function liquidateDSC() external {
        // Liquidate DSC
    }

    function gethealthFactor() external view {}
}
