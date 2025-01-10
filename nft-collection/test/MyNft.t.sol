// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import {s_DeployMyNFT} from "../script/MyNft.s.sol";
import {BasicNft} from "../src/MyNft.sol";
contract testMyNft is Test{
     string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";
    BasicNft public s_basicNft;
    s_DeployMyNFT public deployer;
    address public deployerAddress;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public constant USER = address(1);

    function setUp() public {
            deployer = new s_DeployMyNFT();
            s_basicNft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(s_basicNft.name())) == keccak256(abi.encodePacked((NFT_NAME))));
        assert(keccak256(abi.encodePacked(s_basicNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        s_basicNft.mintNft(PUG_URI);

        assert(s_basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        s_basicNft.mintNft(PUG_URI);

        assert(keccak256(abi.encodePacked(s_basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI)));
    }

    }
    
