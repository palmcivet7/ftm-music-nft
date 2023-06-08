// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicNft is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    event Minted(address indexed _to, uint256 indexed _tokenId, string _tokenURI);

    using Counters for Counters.Counter;

    uint256 public constant MINT_PRICE_FTM = 1 * 10 ** 18; // 1 FTM
    Counters.Counter private _tokenIdTracker;

    // Mapping from token ID to minter address
    mapping(uint256 => address) private _minters;

    constructor() ERC721("Music Minted", "MM") {}

    function mintToken(address _to, string memory _tokenURI) public payable {
        require(bytes(_tokenURI).length > 0, "Token URI cannot be empty");
        require(msg.value >= MINT_PRICE_FTM, "Not enough FTM sent for minting");
        uint256 newTokenId = _tokenIdTracker.current();
        _tokenIdTracker.increment();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        _minters[newTokenId] = msg.sender;
        emit Minted(_to, newTokenId, _tokenURI);
    }

    function burn(uint256 tokenId) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        require(_minters[tokenId] == msg.sender, "Only the original minter can burn the token");

        _burn(tokenId);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable(msg.sender).transfer(balance);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal override(ERC721URIStorage) {
        super._setTokenURI(tokenId, _tokenURI);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        delete _minters[tokenId];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // function minterOf(uint256 tokenId) public view returns (address) {
    //     return _minters[tokenId];
    // }
}
