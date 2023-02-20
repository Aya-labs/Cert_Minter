// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";

contract AyaCert is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string public certURI;
    
    mapping(address => bool) public isAllowed;
    mapping(address => bool) public certClaimed;
  uint256 public immutable maxSupply;

    constructor( string memory _certURI,uint _maxSupply) ERC721("AyaCert", "AYCT") {
        maxSupply = _maxSupply;

        certURI = _certURI;

    }
//  if ypou make use of normal whitelist
    function certMint() external  {
        require(isAllowed[msg.sender], "You are not allowed to mint");
        require(certClaimed[msg.sender] == false, "You have already claimed your certificate");
        require(_tokenIdCounter.current() < maxSupply, "Max supply reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        certClaimed[msg.sender] = true;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, certURI);
    }

    function allowToMint(address _address) public onlyOwner {
        isAllowed[_address] = true;
    }
    function allowToMints(address[] memory _address) public onlyOwner {
        for (uint i = 0; i < _address.length; i++) {
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

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}