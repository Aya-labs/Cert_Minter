// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import {MerkleProof} from '../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol';


contract AyaCert is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string public certURI;
    bytes32 public merkleRoot;
    mapping(address => bool) public isAllowed;
    mapping(address => bool) public certClaimed;
  uint256 public immutable maxSupply;

    constructor(bytes32 _merkleRoot, uint _maxSupply, string memory _certURI) ERC721("AyaCert", "AYCT") {
        merkleRoot = _merkleRoot;
        maxSupply = _maxSupply;

        certURI = _certURI;

    }
//  if ypou make use of normal whitelist
    function certMint() external  {
        require(isAllowed[msg.sender], "You are not allowed to mint");
        require(certClaimed[msg.sender] == false, "You have already claimed your certificate");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        certClaimed[msg.sender] = true;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, certURI);
    }
    // use this to go the merkle route
    function mintCert (bytes32[] calldata  merkleProof) public {
        require(certClaimed[msg.sender] == false, "You have already claimed your certificate");
        certClaimed[msg.sender] = true;
        require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not allowed to mint");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

    }

    function allowToMint(address _address) public onlyOwner {
        isAllowed[_address] = true;
    }
    function allowToMint(address[] memory _address) public onlyOwner {
        for (uint i = 0; i < _address.length; i++) {
            isAllowed[_address[i]] = true;
        }
    }
    function updateMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function updateCertURI(string memory _certURI) public onlyOwner {
        certURI = _certURI;
    }
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
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