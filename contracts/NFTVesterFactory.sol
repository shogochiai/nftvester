//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./test/console.sol";
import "./NFTVester.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./VesterKeyNFT.sol";
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract NFTVesterFactory {
  using Clones for NFTVester;
  IERC721 nft;
  constructor(){
    nft = new VesterKeyNFT("VesterkeyNFT", "vkNFT");   
  }
  function createVester(address _ft) public {
    NFTVester.clone().initialize(_ft, address(nft), msg.sender);
    // Note: Please approve the generated clone to escrow your token.
  }
}
