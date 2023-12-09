
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
 
// @openzeppelin/contracts/token/ERC721/ERC721.sol contains the implementation of the ERC-721 token standard
// which our NFT smart contract will inherit.
// To be a valid NFT, the smart contract must implement all of the methods of the ERC-721 standard
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
 
//@openzeppelin/contracts/access/Ownable.sol sets up access control on the smart contract,
//so that only the owner of the smart contract can mint NFTs
import "@openzeppelin/contracts/access/Ownable.sol";
 
//@openzeppelin/contracts/utils/Counters.sol provides counters that can only be incremented or decremented by one
// The smart contract uses a counter to keep track of the total number of NFTs minted
// and sets the unique ID on our new NFT.
// Each NFT minted using a smart contract must be assigned a unique ID -- here our unique ID is determined by the total
// number of NFTs in existence. For example, the first NFT we mint with our smart contract has an ID of "1", second "2", etc.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
 
contract nftMint is ERC721, Ownable, ERC721Enumerable, ERC721URIStorage {
    using Strings for uint256;
    using SafeMath for uint256;
    using Counters for Counters.Counter;
 
    Counters.Counter private _tokenIds;
 
    string public baseTokenURI;
    string public baseExtension = ".json";
 
    uint256 public constant maxSupply = 1000;
    uint256 public cost = 0.001 ether;
    uint256 public maxPerMint = 5;
 
    bool public isSaleActive;
    mapping(address => bool) public whitelisted;
 
    constructor(string memory baseURI) ERC721("ATH", "ATHIKA") {
        setBaseURI(baseURI);
    }
 
    function mintNFTs(uint256 _count) public payable {
        uint totalMinted = _tokenIds.current();
        require(
            totalMinted.add(_count) <= maxSupply,
            "Not enough NFTs remaining to mint."
        );
        require(
            _count > 0 && _count <= maxPerMint,
            "Cannot mint specified number of NFTs."
        );
        require(
            msg.value >= cost.mul(_count),
            "Not enough Ether in wallet to purchase NFTs."
        );
 
        if (msg.sender != owner()) {
            if (whitelisted[msg.sender] != true) {
                require(msg.value >= cost * _count);
            }
        }
        for (uint256 i = 0; i < _count; i++) {
            uint256 newTokenID = _tokenIds.current();
            _safeMint(msg.sender, newTokenID);
            _tokenIds.increment();
        }
    }
 
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
 
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }
 
    function walletOfOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
 
    // string memory tokenURI is a string that should resolve to a JSON document that describes the NFT's metadata.
    // An NFT's metadata allows the NFT to have configurable properties, such as a name, description, image and other attributes.
 
    function tokenURI(
        uint256 tokenId
    )
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
 
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0 //? string(abi.encodePacked(currentBaseURI,tokenId.toString(),baseExtension))
                ? string(abi.encodePacked(currentBaseURI))
                : "";
    }
 
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }
 
    function setmaxMintAmount(uint256 _newmaxPerMint) public onlyOwner {
        maxPerMint = _newmaxPerMint;
    }
 
    function setBaseExtension(
        string memory _newBaseExtension
    ) public onlyOwner {
        baseExtension = _newBaseExtension;
    }
 
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }
 
    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }
 
    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }
 
    function withdraw() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
 
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
 
    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
 
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}