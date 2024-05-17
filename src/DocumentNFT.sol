// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DocumentNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    mapping(uint256 => string) private _documentHashes;

    constructor() ERC721("DocumentNFT", "DOCNFT") {}

    function mintDocumentNFT(string memory documentHash) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter += 1;

        _mint(msg.sender, tokenId);
        _documentHashes[tokenId] = documentHash;
    }

    function getDocumentHash(
        uint256 tokenId
    ) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _documentHashes[tokenId];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(from == address(0), "This token is non-transferable");
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
