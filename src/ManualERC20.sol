// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;


contract Manualtoken{


    mapping(address=>uint256) private s_balances;


    function name() public pure returns (string memory ){
     return "Manual token";
    }

    function totalSupply() public pure returns (uint256){
        return 100 ether;
    }

    function decimals() public pure returns (uint8){
        return 18;
    }
     
     function balanceOf(address _owner) public view returns (uint256){
       return s_balances[_owner];
     }

     function transfer(address _to, uint256 _amt) public {
        uint256 previousBalances=balanceOf(msg.sender)+balanceOf(_to);
        require(balanceOf(msg.sender)+balanceOf(_to)==previousBalances);
     }
}