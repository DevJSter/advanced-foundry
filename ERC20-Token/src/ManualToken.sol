// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken {

    mapping (address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }
 
    function symbol() public pure returns (string memory) {
        return "$Manual"; 
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100 * 10^18
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= amount;
        s_balances[_to] += amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances, "Transfer failed");
    }
}
