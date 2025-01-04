// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");
    uint256 public constant  startBalance = 100 ether;

    function setUp()  public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob,startBalance);
    }

   function testBobBalance() view public {   
        assertEq(startBalance, ourToken.balanceOf(bob));
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount); //TransferFrom recquires for the one to approve that transactions as here the transaction is made up on the bob's behalf bob do have to approve it
        
        // ourToken.transfer(alice, transferAmount); // when we use transfer we no need to provide the from as it only requires the receiever and the amount only
        assertEq(ourToken.balanceOf(alice),transferAmount);
        assertEq(ourToken.balanceOf(bob),startBalance-transferAmount);


    } 

}

