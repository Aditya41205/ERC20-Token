// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;


import {Script} from "forge-std/Script.sol";
import {Ourtoken} from "../src/Ourtoken.sol";

contract Deploy is Script{

    function run() external returns(Ourtoken){
        vm.startBroadcast();
       Ourtoken ot= new Ourtoken(1000 ether);
        vm.stopBroadcast();
        return ot;
    }
}