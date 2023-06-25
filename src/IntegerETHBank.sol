// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.7.4;

contract IntegerETHBank {
    string public constant name = "Integer ETH";
    string public constant symbol = "INTETH";
    uint8 public constant decimals = 0;

    bool public guard = false;
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        require(
            msg.value == IntegerETHBankUser(msg.sender).getDepositAmount() * 1e18,
            "Ether received and buying amount mismatch"
        );
        balanceOf[msg.sender] += IntegerETHBankUser(msg.sender).getDepositAmount();
    }

    function withdraw() external {
        require(balanceOf[msg.sender] >= IntegerETHBankUser(msg.sender).getWithdrawAmount(), "Insufficient balance");
        require(guard == false, "Reentrancy detected");

        guard = true;
        balanceOf[msg.sender] -= IntegerETHBankUser(msg.sender).getWithdrawAmount();
        guard = false;

        (bool success,) = msg.sender.call{value: IntegerETHBankUser(msg.sender).getWithdrawAmount() * 1e18}("");
        require(success, "Failed to send Ether");
    }
}

interface IntegerETHBankUser {
    function getDepositAmount() external view returns (uint256);
    function getWithdrawAmount() external view returns (uint256);
}
