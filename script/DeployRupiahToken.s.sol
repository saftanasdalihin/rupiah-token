// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Script.sol";
import "../src/RupiahToken.sol";

contract DeployRupiahToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new RupiahToken(0x6fB55D4543b98Bc2F04fb608D631c3d3d113Da21);
        vm.stopBroadcast();
    }
}
