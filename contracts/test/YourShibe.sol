// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "./console.sol";

contract YourShibe is ERC20 {
  constructor(uint256 initialSupply, address[] memory testers) ERC20("Your Shibe", "urSHIB") {
    uint256 len = testers.length;
    for(uint256 i=0; i < len;) {
      _mint(testers[i], initialSupply * (10 ** decimals()) / len);
      unchecked { ++i; }
    }
  }

}