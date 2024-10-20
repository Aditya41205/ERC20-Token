// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Deploy} from "../script/DeployOurtoken.s.sol";
import {Ourtoken} from "../src/Ourtoken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    Ourtoken public ourToken;
    Deploy public deployer;

    address public alice = address(0x1);
    address public bob = address(0x2);
    uint256 public initialSupply = 1000 * 1e18; // Example initial supply in wei

    function setUp() public {
        deployer = new Deploy();
        ourToken = deployer.run();
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    function testTransfer() public {
        // Test transfer from deployer (msg.sender) to Alice
        vm.prank(deployer.owner()); // Assuming deployer is the owner and has the initial supply
        ourToken.transfer(alice, 100 ether);
        assertEq(ourToken.balanceOf(alice), 100 ether);
        assertEq(ourToken.balanceOf(deployer.owner()), initialSupply - 100 ether);
    }

    function testTransferFailsWithInsufficientBalance() public {
        // Attempt to transfer more than Bob's balance
        vm.prank(deployer.owner());
        ourToken.transfer(alice, 100 ether);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        vm.prank(alice);
        ourToken.transfer(bob, 200 ether); // Bob has 0 balance
    }

    function testTransferEvent() public {
        vm.prank(deployer.owner());
        vm.expectEmit(true, true, true, true);
        emit Transfer(deployer.owner(), alice, 100 ether);
        ourToken.transfer(alice, 100 ether);
    }

    function testAllowance() public {
        // Allowance should be set correctly
        vm.prank(deployer.owner());
        ourToken.approve(bob, 50 ether);
        assertEq(ourToken.allowance(deployer.owner(), bob), 50 ether);
    }

    function testTransferFrom() public {
        // Set up an allowance and then transferFrom
        vm.prank(deployer.owner());
        ourToken.approve(bob, 100 ether);

        // Bob transfers from the owner to Alice
        vm.prank(bob);
        ourToken.transferFrom(deployer.owner(), alice, 50 ether);

        assertEq(ourToken.balanceOf(alice), 50 ether);
        assertEq(ourToken.allowance(deployer.owner(), bob), 50 ether); // Remaining allowance
    }

    function testTransferFromExceedsAllowance() public {
        vm.prank(deployer.owner());
        ourToken.approve(bob, 50 ether);

        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        vm.prank(bob);
        ourToken.transferFrom(deployer.owner(), alice, 100 ether); // Exceeds allowance
    }

    function testTransferFromInsufficientBalance() public {
        // Attempt to transfer more than the owner's balance
        vm.prank(deployer.owner());
        ourToken.approve(bob, 100 ether);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        vm.prank(bob);
        ourToken.transferFrom(deployer.owner(), alice, initialSupply + 1); // Exceeds owner's balance
    }

    function testZeroTransfer() public {
        vm.prank(deployer.owner());
        ourToken.transfer(alice, 0);
        assertEq(ourToken.balanceOf(alice), 0); // Should still be zero
    }
}
