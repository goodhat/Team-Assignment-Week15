// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.7.4;

// This is an insecure token contract.
// Your goal is buy as much as possible IST with least Ether,
// so then everytime an user buys IST, you can drain this contract's Ether as you wish.

contract InsecureToken {
    mapping(address => uint256) public balanceOf;

    uint256 public constant TOKEN_PRICE = 1 ether; // fixed ETH-IST ratio to 1:1
    bool public isSellPhase = false;
    string public constant name = "Insecure Token";
    string public constant symbol = "IST";
    uint8 public constant decimals = 0;

    function buy(uint256 _buyAmount) external payable {
        require(
            msg.value == User(msg.sender).getBuyAmount(_buyAmount) * TOKEN_PRICE,
            "Ether received and buying amount mismatch"
        );
        balanceOf[msg.sender] += User(msg.sender).getBuyAmount(_buyAmount);
    }

    function sell(uint256 _sellAmount) external {
        require(balanceOf[msg.sender] >= User(msg.sender).getSellAmount(_sellAmount), "Insufficient balance");
        require(isSellPhase == false, "Reentrancy detected");

        isSellPhase = true;
        balanceOf[msg.sender] -= User(msg.sender).getSellAmount(_sellAmount);
        isSellPhase = false;

        (bool success,) = msg.sender.call{value: User(msg.sender).getSellAmount(_sellAmount) * TOKEN_PRICE}("");
        require(success, "Failed to send Ether");
    }
}

interface User {
    function getBuyAmount(uint256 _buyAmount) external view returns (uint256);
    function getSellAmount(uint256 _sellAmount) external view returns (uint256);
}
