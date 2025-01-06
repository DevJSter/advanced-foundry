// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract  MyNft is ERC721 {
    uint256 private s_tokencounter;

    mapping (uint256 => string) private s_tokenIdToURi;
    constructor() ERC721("Doggie","DOG"){
        s_tokencounter = 5;
    }
    //Mint function here would increase the number of holders of the Nft
    function mintNft(string memory tokenURI) public {
        s_tokenIdToURi[s_tokencounter] = tokenURI; // here s_tokencounter is mapped to tokenid that on which tokenid which user is the owner of it 
        _safeMint(msg.sender, s_tokencounter);
        s_tokencounter++;
    }
    function tokenURI(uint256 tokenID) public view override returns(string memory){
        return s_tokenIdToURi[tokenID]; // it will return that nft which has the id of tokenid
    }
}