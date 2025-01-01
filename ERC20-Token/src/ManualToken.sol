// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken {

mapping (address => uint256) private s_balances;

function  name() public pure {
 return "Manual Token";
}
 
function symbol() public view returns (string memory) {
    return "$Manual"; 
}

function totalSupply() public pure returns (uint256){
    return 100 ether; //1000000000000000000
}

function decimals() public pure returns (uint8){
    return 18;
}
function balanceOf(address _owner) public view returns (uint256){
    return s_balances[_owner];
}

function transfer(address _to, uint256 amount) public {
    uint256 previousbalances = balanceOf(msg.sender) + balanceOf(_to);
    balanceOf[(msg.sender)] -= amount;
    balanceOf(_to) += amount;
    require(balanceOf(msg.sender) + balanceOf(_to) = previousbalances );
}   


}