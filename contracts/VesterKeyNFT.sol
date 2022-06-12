//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./test/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VesterKeyNFT is ERC721 {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(address => uint256[]) public userOwnedTokens;
  mapping(uint256 => int256) public tokenIsAtIndex;

  constructor(string memory name, string memory ticker) public ERC721(name, ticker) {
    _setBaseURI("https://ipfs.io/ipfs/");
  }

  function mintItem(address to, string memory tokenURI)
      public
      onlyOwner
      returns (uint256)
  {
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(to, id);
      _setTokenURI(id, tokenURI);

      userOwnedTokens[msg.sender].push(id);
      uint256 arrayLength = userOwnedTokens[msg.sender].length;
      tokenIsAtIndex[id] = arrayLength;

      return id;
  }

  function 

}