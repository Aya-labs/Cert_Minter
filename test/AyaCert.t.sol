// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AyaCert.sol";

contract AyaCertTest is Test {
    AyaCert public ayacert;
    address minter1 = mkaddr("minter1");
    address minter2 = mkaddr("minter2");
    address minter3 = mkaddr("minter3");
    address minter4 = mkaddr("minter4");
    address receiver1 = mkaddr("receiver1");
    address own;
    

    function setUp() public {
        ayacert = new AyaCert( "uri", 10);
        vm.label(address(this), "owner");
        
    }
    function testMint() public {
        vm.prank(address(this));
        address[] memory minters = new address[](3);
        minters[0] = minter1;
        minters[1] = minter2  ;
        minters[2] = minter3;
        AyaCert(ayacert).allowToMints(minters);
        // ayacert.allowToMint(minters);

        // ayacert.allowToMint([minter1);
        vm.startPrank(minter1);
        ayacert.certMint();
        assertEq(ayacert.balanceOf(minter1), 1);
        vm.stopPrank();
        vm.prank(minter2);
        ayacert.certMint();
        vm.prank(minter3);
        ayacert.certMint();

    }
    function testTfterb() public {
        vm.startPrank(minter1);
        ayacert.balanceOf(minter1);
        ayacert.transferFrom(minter1, receiver1, 0);
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
