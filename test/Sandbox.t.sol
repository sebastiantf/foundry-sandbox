// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Sandbox.sol";

contract SandboxTest is Test {
    Sandbox public sandbox;

    function setUp() public {
        sandbox = new Sandbox();
    }

    function testSandbox() public {
        address eoa = address(0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);

        address interim;
        
        assembly {
          interim := shl(144, eoa)
        }
        emit log_named_address("interim", interim);
        
        assembly {
          interim := shr(16, shl(144, eoa))
        }
        emit log_named_address("interim", interim);
    }
}
