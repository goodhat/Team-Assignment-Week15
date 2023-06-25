// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;

import "../src/InsecureToken.sol";

contract ExampleUser is User {
    address public insecureTokenAddr;

    constructor(address _insecureTokenAddr) public {
        insecureTokenAddr = _insecureTokenAddr;
    }

    function getBuyAmount(uint256 _buyAmount) external view override returns (uint256) {
        return _buyAmount;
    }

    function getSellAmount(uint256 _sellAmount) external view override returns (uint256) {
        return _sellAmount;
    }

    receive() external payable {}
}
