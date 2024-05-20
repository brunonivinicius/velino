// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DocumentNFT} from "../src/DocumentNFT.sol";

contract DocumentNFTTest is Test {
    DocumentNFT docnft;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        docnft = new DocumentNFT(owner);
    }

    function testSafeMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        docnft.safeMint(user, uri);
        vm.stopPrank();

        // Check the balance of the owner (should be 1)
        assertEq(docnft.ownerOf(1), user);
    }

    function testURI() public {
        vm.startPrank(owner);
        string memory testHash = "QmHash5678";
        docnft.safeMint(user, testHash);
        vm.stopPrank();

        // Attempt to transfer the token and expect it to revert
        assertEq(docnft.tokenURI(1), testHash);
    }
}
