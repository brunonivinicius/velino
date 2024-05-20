// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DocumentNFT} from "../src/DocumentNFT.sol";

contract DocumentNFTTest is Test {
    DocumentNFT docnft;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        // Deploy the DocumentNFT contract
        docnft = new DocumentNFT(owner);
        // Transfer ownership to the designated owner address
        docnft.transferOwnership(owner);
    }

    function testSafeMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        docnft.safeMint(uri);
        vm.stopPrank();

        // Check the balance of the owner (should be 1)
        assertEq(
            docnft.balanceOf(owner),
            1,
            "Balance should be 1 after minting"
        );
        // Check the owner of the minted token (should be the contract owner)
        assertEq(docnft.ownerOf(0), owner, "Owner should own the minted token");
        // Check the token URI
        assertEq(
            docnft.tokenURI(0),
            uri,
            "Token URI should match the provided URI"
        );
    }

    function testLockingAfterMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        docnft.safeMint(uri);
        vm.stopPrank();

        // Check if the token is locked
        bool isLocked = docnft.locked(0);
        assertTrue(isLocked, "Token should be locked after minting");
    }

    function testTransferNotAllowed() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        docnft.safeMint(uri);
        vm.stopPrank();

        // Attempt to transfer the token and expect it to revert
        vm.expectRevert("Transfer not allowed");
        docnft.safeTransferFrom(owner, user, 0);
    }
}
