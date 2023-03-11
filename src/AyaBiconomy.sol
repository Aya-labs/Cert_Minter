// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import "../lib/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol";
contract AyaCertBiconomy is ERC721, ERC2771Context,ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string public certURI;

    mapping(address => bool) public isAllowed;
    mapping(address => bool) public certClaimed;
    uint256 public immutable maxSupply;

    constructor(string memory _certURI, uint256 _maxSupply, address trustedForwarder) ERC721("AyaCert", "AYCT") ERC2771Context(address(trustedForwarder)) {
        maxSupply = _maxSupply;

        certURI = _certURI;
    }
    //  if ypou make use of normal whitelist

    function certMint() external {
        require(isAllowed[ _msgSender()], "You are not allowed to mint");
        require(certClaimed[ _msgSender()] == false, "You have already claimed your certificate");
        require(_tokenIdCounter.current() < maxSupply, "Max supply reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        certClaimed[ _msgSender()] = true;
        _safeMint (_msgSender(), tokenId);
        _setTokenURI(tokenId, certURI);
    }

    function allowToMint(address _address) public onlyOwner {
        isAllowed[_address] = true;
    }

    function allowToMints(address[] memory _address) public onlyOwner {
        for (uint256 i = 0; i < _address.length; i++) {
            isAllowed[_address[i]] = true;
        }
    }

    function updateCertURI(string memory _certURI) public onlyOwner {
        certURI = _certURI;
    }
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        require(from == address(0), "Err: token transfer is BLOCKED"); // only minting allowed
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    function _msgSender() internal view override(Context, ERC2771Context)
      returns (address sender) {
      sender = ERC2771Context._msgSender();
  }

  function _msgData() internal view override(Context, ERC2771Context)
      returns (bytes calldata) {
      return ERC2771Context._msgData();
  }
}
