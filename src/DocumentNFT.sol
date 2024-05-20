// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DocumentNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId = 1;

    constructor(
        address initialOwner
    ) ERC721("DocumentNFT", "DOCNFT") Ownable(initialOwner) {}

    function safeMint(address to, string memory hash) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, hash);
    }

    function ownerTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable onlyOwner {
        //onlyowner????
        require(msg.value == 1 ether, "1 MATIC transfer fee required");
        _safeTransfer(from, to, tokenId, "");

        // Emit an event to track fee collection (optional)
        emit TransferFeeCollected(msg.value, from);
    }

    // Optional event to record fee collection
    event TransferFeeCollected(uint256 amount, address payer);

    function withdrawFees() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function burn(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }

    function balanceToken(address user) public view returns (uint256) {
        return balanceOf(user);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
