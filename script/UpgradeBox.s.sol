// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        // HARDCODE YOUR PROXY ADDRESS
        address proxyAddress = 0xC5328C51034c5Ff35BE146eA6F62298C82FE5533;
        console.log("Using proxy address:", proxyAddress);

        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        address newImplementation = address(newBox);
        console.log("New implementation address:", newImplementation);
        vm.stopBroadcast();
        
        // Perform upgrade with low-level call
        vm.startBroadcast();
        bytes memory callData = abi.encodeWithSignature("upgradeTo(address)", newImplementation);
        (bool success, ) = proxyAddress.call(callData);
        require(success, "Upgrade failed");
        vm.stopBroadcast();
        
        console.log("Upgrade completed!");
        return proxyAddress;
    }
}