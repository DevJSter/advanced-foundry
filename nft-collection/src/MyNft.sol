// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract  MyNft is ERC721 {
    uint256 private s_tokencounter;
    constructor() ERC721("Doggie","DOG"){
        s_tokencounter = 5;
    }

    function _mint() public {

    }
    function tokenURI(uint256 tokenID) public view override returns(string memory){
        return "https://ipfs.io/ipfs/QmaTPRN6V5zrfTUDbmRcBQYBriXHqHxHT97eSrt8SZGW93"

    }
}