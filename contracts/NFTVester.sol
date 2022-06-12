//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./test/console.sol";
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract NFTVester is Initializable {
  struct Epoch {
    uint index;
    uint nftId;
    uint ftAmount;
    uint isWithdrawn;
  }
  IERC20 ft;
  IERC721 nft;
  mapping(uint=>Epoch) epochs;
  function initialize(address _ft, address _nft, address _owner) initializer public {
    ft = IERC20(_ft);
    nft = IERC721(_nft);
    owner = _owner;
  }
  modifier onlyOwner {
    require(msg.sender == owner, "Not owner");
    _;
  }
  function allocate(address recipient, uint totalFtAmount, uint epochStart, uint epocLen, string metadataURI) onlyOwner public {
    require(ft.allowance(msg.sender,address(this)) >= totalFtAmount, "Allowance is not enough");
    for(uint i; i < epochLen; i++){
      uint currenctEpoch = epochStart+i;
      Epoch storage e = epochs[currenctEpoch];
      require(!e.isWithdrawn, "This epoch is already in use.");
      e.index = currenctEpoch;
      e.nftId = nft.mintItem(recipient);
      e.ftAmount = totalFtAmount / epochLen;
      nft.setTokenURI(metadataURI);
    }
    ft.transferFrom(address(this), totalFtAmount);
  }
  function withdraw(uint epochIndex) public {
    Epoch storage e = epochs[epochIndex];
    require(!e.isWithdrawn, "Already taken.");
    require(epochIndex < block.timestamp/(60*60*24*30), "Too early.");
    require(msg.sender == nft.ownerOf(e.nftId), "Not owner");
    e.isWithdrawn = true;
    nft.burn(e.nftId);
    ft.transfer(msg.sender, e.ftAmount);
  }
}
}