// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DocumentNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => bool) private _locked;

    constructor(
        address initialOwner
    ) ERC721("DocumentNFT", "DOCNFT") Ownable(initialOwner) {}

    event Locked(uint256 tokenId);

    function locked(uint256 tokenId) external view returns (bool) {
        require(ownerOf(tokenId) != address(0));
        return _locked[tokenId];
    }

    function safeMint(string memory hash) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _locked[tokenId] = true;
        emit Locked(tokenId);
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, hash);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721) returns (address) {
        address from = _ownerOf(tokenId);
        if (from != address(0)) {
            revert("Transfer not allowed"); // Prevent all transfers, making the token soulbound and non-burnable
        }
        return super._update(to, tokenId, auth);
    }

    // Required overrides

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
