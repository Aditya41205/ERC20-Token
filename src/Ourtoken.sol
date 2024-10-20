// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Ourtoken is ERC20{
    
     constructor(uint256 Initialsupply) ERC20("Ourtoken","OT"){
        _mint(msg.sender,Initialsupply);
     }
}