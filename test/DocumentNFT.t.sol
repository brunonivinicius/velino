// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DocumentNFT.sol";

contract DocumentNFTTest is Test {
    DocumentNFT private nft;

    function setUp() public {
        nft = new DocumentNFT();
    }

    function testMinting() public {
        nft.mintDocumentNFT("hash-do-documento");

        assertEq(nft.ownerOf(0), address(this));
        assertEq(nft.getDocumentHash(0), "hash-do-documento");
    }
}
