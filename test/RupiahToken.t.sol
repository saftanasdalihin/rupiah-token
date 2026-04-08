// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/RupiahToken.sol";

contract RupiahTokenTest is Test {
    RupiahToken public idrt;
    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    // Set up the test environment
    function setUp() public {
        vm.prank(owner); // Set the owner for the token
        idrt = new RupiahToken(owner);
        console.log("Saldo user1 SEBELUM mint:", idrt.balanceOf(user1));

        vm.prank(owner);
        idrt.mint(user1, 1000 ether); // Mint 1000 IDRT to user1
        console.log("Saldo user1 SETELAH mint:", idrt.balanceOf(user1));
    }

    // Test minting functionality
    function testMinting() public view {
        assertEq(idrt.balanceOf(user1), 1000 ether);
    }

    // Test transfer with tax
    function testTransferWithTax() public {
        uint256 amountToTransfer = 1000 ether;
        uint256 expectedTax = (amountToTransfer * 5) / 10000; // 0.5 IDRT
        uint256 expectedReceived = amountToTransfer - expectedTax; // 999.5 IDRT

        vm.prank(user1);
        idrt.transfer(user2, amountToTransfer);

        assertEq(idrt.balanceOf(user2), expectedReceived);
        assertEq(idrt.balanceOf(owner), expectedTax);
    }

    // Test blacklisting cannot transfer
    function testBlacklisting() public {
        vm.prank(owner);
        idrt.blacklist(user1);

        vm.expectRevert();

        vm.prank(user1);
        idrt.transfer(user2, 100 ether);
    }
}
