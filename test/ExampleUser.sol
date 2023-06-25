// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;

import "../src/IntegerETHBank.sol";

contract ExampleUser is IntegerETHBankUser {
    function getDepositAmount() external pure override returns (uint256) {
        return 100;
    }

    function getWithdrawAmount() external pure override returns (uint256) {
        return 100;
    }

    receive() external payable {}
}
