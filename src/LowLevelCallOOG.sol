// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

/// @title LowLevelCallOOG
/// @notice A contract that tests low level calls that fail with an OOG error
contract LowLevelCallOOG {
    bool public success = false;
    bool[] public successes = new bool[](5);
    bool public complete = false;
    uint256 public counter;

    function lowLevelCallOOG(address _to, uint256 _amount) external {
        (bool _success, ) = _to.call{value: _amount}("");
        success = _success;
        complete = true;
    }

    function lowLevelCallLoopOOG(
        address[] calldata _to,
        uint256 _amount
    ) external {
        for (uint256 i = 0; i < _to.length; i++) {
            (bool _success, ) = _to[i].call{value: _amount}("");
            if (_success) {
                successes[i] = _success;
                counter = i;
            }
        }
        complete = true;
    }

    function transferOOG(address _to, uint256 _amount) external {
        payable(_to).transfer(_amount);
        success = true;
        complete = true;
    }
}

contract LowLevelCallOOGHack {
    receive() external payable {
        // Just use up all the gas to cause a OOG error
        while (true) {}
    }
}
