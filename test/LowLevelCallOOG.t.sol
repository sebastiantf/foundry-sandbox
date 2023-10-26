// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LowLevelCallOOG.sol";

contract LowLevelCallOOGTest is Test {
    LowLevelCallOOG public lowLevelCallOOG;
    LowLevelCallOOGHack public lowLevelCallOOGHack;

    function setUp() public {
        lowLevelCallOOG = new LowLevelCallOOG();
        lowLevelCallOOGHack = new LowLevelCallOOGHack();
    }

    function testLowLevelCallOOG() public {
        vm.deal(address(lowLevelCallOOG), 100 ether);

        lowLevelCallOOG.lowLevelCallOOG(address(lowLevelCallOOGHack), 1 ether);

        // The low level call will fail with an OOG error
        assertEq(lowLevelCallOOG.success(), false);
        // But the transaction will continue and be marked as complete
        assertEq(lowLevelCallOOG.complete(), true);
    }

    function testLowLevelCallLoopOOG() public {
        vm.deal(address(lowLevelCallOOG), 100 ether);

        address[] memory to = new address[](5);
        to[0] = address(lowLevelCallOOGHack);
        to[1] = address(0x01);
        to[2] = address(0x02);
        to[3] = address(0x03);
        to[4] = address(0x04);

        lowLevelCallOOG.lowLevelCallLoopOOG(to, 1 ether);

        // The first low level call will fail with an OOG error
        assertEq(lowLevelCallOOG.successes(0), false);
        // But txn will continue and all others will succeed
        assertEq(lowLevelCallOOG.successes(1), true);
        assertEq(lowLevelCallOOG.successes(2), true);
        assertEq(lowLevelCallOOG.successes(3), true);
        assertEq(lowLevelCallOOG.successes(4), true);
        // But txn will continue and be marked as complete completing the loop
        assertEq(lowLevelCallOOG.counter(), 4);
        assertEq(lowLevelCallOOG.complete(), true);
    }

    function testTransferOOG() public {
        vm.deal(address(lowLevelCallOOG), 100 ether);

        vm.expectRevert();
        lowLevelCallOOG.transferOOG(address(lowLevelCallOOGHack), 1 ether);

        // The transfer will fail with an OOG error
        assertEq(lowLevelCallOOG.success(), false);
    }
}
