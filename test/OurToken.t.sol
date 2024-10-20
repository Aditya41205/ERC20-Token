// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {Ourtoken} from "../src/Ourtoken.sol";
import {Deploy} from "../script/DeployOurtoken.s.sol";

contract test is Test{
    Ourtoken public ourToken;
    Deploy public deployer;

    address Alice=makeAddr("Alice");
    address Bob=makeAddr("Bob");


    function setUp() public{
     deployer= new Deploy();
     ourToken= deployer.run();

     vm.prank(msg.sender);
     ourToken.transfer(Bob,100 ether);
     
    }

    function testbobbalance() public{
        assertEq(100 ether, ourToken.balanceOf(Bob));
    }
}