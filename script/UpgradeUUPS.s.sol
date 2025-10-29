// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {SplitBaseUpgradeable} from "../src/SplitBaseUpgradeable.sol";

interface IUUPS {
    function upgradeTo(address newImplementation) external;
}

contract UpgradeUUPS is Script {
    function run() external {
        address proxy = vm.envAddress("PROXY_ADDRESS");

        vm.startBroadcast();
        // 1) Deploy new implementation (could be a V2 contract)
        SplitBaseUpgradeable newImpl = new SplitBaseUpgradeable();
        // 2) Call upgrade on the proxy (owner required)
        IUUPS(proxy).upgradeTo(address(newImpl));
        vm.stopBroadcast();

        console2.log("New implementation:", address(newImpl));
        console2.log("Upgraded proxy:", proxy);
    }
}
