// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SmartContract is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";

  uint256 public cost = 0.08 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 10;

  bool public paused = false;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI
  ) ERC721(_name, _symbol) {
    baseURI = _initBaseURI;
  }

  function mint(uint256 _mintAmount) external payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    require(msg.value >= cost * _mintAmount);
    // removed check here for less gas on user side

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function mintByOwner(uint256 _mintAmount) external onlyOwner {
    uint256 supply = totalSupply();

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function setCost(uint256 _newCost) external onlyOwner {
    cost = _newCost;
  }

  function setMaxMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
    maxMintAmount = _newMaxMintAmount;
  }

  /// @dev just set new base uri when reveal happens
  function setBaseURI(string memory _newBaseURI) external onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) external onlyOwner {
    paused = _state;
  }

  function withdraw() external payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{ value: address(this).balance }("");
    require(success);
  }

  // view and pure go last
  function walletOfOwner(address _owner) external view returns (uint256[] memory) {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
}