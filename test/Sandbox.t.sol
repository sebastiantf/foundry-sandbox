// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Sandbox.sol";

contract SandboxTest is Test {
    Sandbox public sandbox;
    address eoa = address(0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);

    function setUp() public {
        sandbox = new Sandbox();
    }

    function testSandbox() public {
        bytes8 _gateKey;

        // 30 bytes = 240 bits
        // 8 - 2 = 6 bytes = 48 bits
        // 0x11 will be in 32 bytes with leading zeroes
        // we need that in the 4th byte: 32 - 4 = 28 bytes = 224 bits
        // so left shift 0x11 to 224 bits will place 0x11 in the right place
        assembly {
            _gateKey := shr(48, shl(240, sload(eoa.slot)))
            _gateKey := or(shl(224, 0x11), _gateKey)
        }
        console.logBytes8(_gateKey);
        assertTrue(_gateKey == bytes8(0x0000001100006045));
    }
}
