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
import {AggregatorV3Interface} from "@chainlink/contracts/src/v.0.8/interfaces/AggregatorV3Interface.sol";   
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

contract DSCEngine is ReentrancyGuard, IERC20 {
    //////////
    // Errors//
    //////////
    error DSCENGINE_TOkenAddressesAndPriceFeedAddressShouldBeSameLength();
    error DSCENGINE_MustbeMoreThanZero();
    error DSCEngine_TokenNotAllowed();
    error DSCEngine_TransferFailed();
    error DSCEngine_BreaksHealthFactor(uint256 healthFactor);
    error DSCEngine_MintFailed();

    //////////////
    // State Variables //
    //////////////
    uint256 private constant PRECISION = 1e18;
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant LIQUIDATION_THRESHOLD = 50; // 200%  overcollateralized   
    uint256 private constant LIQUIDATION_PRECISON = 100;
    uint256 private constant minHealthFactor = 1; // 1.5



    mapping(address token => address pricefeed) private s_priceFeeds; //tokentoPRiceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    DecentralizedStablecoin private immutable i_dsc; // DSC Token
    mapping(address user => uint256 amountTobeMinted) private DSC_minted;
    address[] private s_collateralTokens;

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
    // External FUnctions//
    /////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        // USD PRice Feeds
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCENGINE_TOkenAddressesAndPriceFeedAddressShouldBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
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
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), _amount);
        if (!success) {
            revert DSCEngine_TransferFailed();
        }
    }

    function redeemCollateralDSC() external { }

    /*
        * @notice : Mint DSC
        * @notice : follows CEI - Checks Effects Interaction
        * @param to : Address to mint DSC to
        * @param mintAmount : they must have enough collateral of dsc to mint in pool
        *  
    */
    function mintDSC(address to, uint256 mintAmount) external moreThanZero(mintAmount) nonReentrant {
        DSC_minted[msg.sender] += mintAmount;
        // cif they have minted too much ($150DSC , $100ETH)
        // 150% collateral
        _revertHealhFactorISBRoken(msg.sender);
        bool minted = i_dsc.mint(to, mintAmount);
        if(!minted){
            revert DSCEngine_MintFailed();
        }
    }

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

    function gethealthFactor() external view { }

    //////////////
    // Private and Internal view Functions //
    //////////////

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totaldscminted, uint256 collateralValueinUSD)
    {
        // total dsc minted
        // total collateral value
        totaldscminted = DSC_minted[user];
        // total collateral value
        collateralValueinUSD = getAccountCollateralValueinUSD(user);
    }
    /*
        * Returns how close to liquidation user is 
        * if a user goes belwo a 1, then they can get liquidated
    */

    function _healthfactor(address user) private view returns (uint256) {
        // total dsc minted
        // total collateral value
        (uint256 totaldscminted, uint256 collateralValueinUSD) = _getAccountInformation(user);
        // GET THE RETIO OF THESE TWO
        uint256 collateralAdjustForThreshold  = (collateralValueinUSD * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISON; // 150        
        return (collateralAdjustForThreshold * PRECISION) / totaldscminted; //(150/100)
        // 1 ETH = 1000 USD
        // The returned value from Chainlink will be 1000 * 1e8
        // Most USD pairs have 8 decimals, so we will just pretend they all do
        // We want to have everything in terms of WEI, so we add 10 zeros at the end
        // 1 ETH = 1000 * 1e8 * 1e10 = 1e18
    }

    function _revertHealhFactorISBRoken(address user) internal view {
        // If health factor is (do they have emnough collateral)
        // if they dont revert
        uint256 userhealthfactor = _healthfactor(user);

        if(userhealthfactor < minHealthFactor){
            revert DSCEngine_BreaksHealthFactor(userhealthfactor);
        }
    }
    
        //////////////////////////
        // Public External and View Functions //
        //////////////////////////

        function getAccountCollateralValueinUSD(address user) public view returns (uint256 totalCollateralValueInUSd) {  
            // loop through all the collateral and get the value of the collateral    
            for (uint256 i = 0 ;i<s_collateralTokens.length; i++){
                // get the price of the token
                // get the amount of the token
                // multiply the price of the token with the amount of the token
                address tokem = s_collateralTokens[i];
                uint256 amount = s_collateralDeposited[user][token];
                totalCollateralValueInUSd = getUsdValue(token , amount);
            }
            return totalCollateralValueInUSd;
        }

        function getUsdValue(address token , uint256 amount) public view returns(uint256){
            // get the price of the token
            // get the amount of the token
            // multiply the price of the token with the amount of the token
            AggregatorV3Interface pricefeed = AggregatorV3Interface(s_priceFeeds[token]);
            (, int256 price ,,,) = pricefeed.latestRoundData();
            // 1 . ETH = $1000 
            // 1 ETH = 1000 * 10e8
            return (uint256(price * ADDITIONAL_FEED_PRECISION ) * amount) / PRECISION; // because it will return something inb powers of 8 but we know we beed something
            // in power of 18 so we multiply it by 10^10 which is 1e10  

        }
}
