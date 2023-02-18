// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AyaCert.sol";

contract AyaCertTest is Test {
    AyaCert public ayacert;
    address minter1 = mkaddr("minter1");
    address minter2 = mkaddr("minter2");
    address receiver1 = mkaddr("receiver1");
    address own;
    

    function setUp() public {
        ayacert = new AyaCert("0xng7asjfndo35",10, "uri");
        vm.label(address(this), "owner");
        
    }
    function testMint() public {
        vm.prank(address(this));
        ayacert.allowToMint(minter1);
        vm.startPrank(minter1);
        ayacert.certMint();
        assertEq(ayacert.balanceOf(minter1), 1);
        // ayacert.certMint();

    }
    function afterb() public {
        vm.startPrank(minter1);
        ayacert.balanceOf(minter1);
        ayacert.transferFrom(msg.sender, receiver1,0);
        vm.stopPrank();
        vm.startPrank(minter2);
        ayacert.transferFrom(msg.sender, receiver1,0);


    }
    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
