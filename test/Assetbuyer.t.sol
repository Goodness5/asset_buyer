// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../Mock/NFT.sol";
import "../contracts/facets/Assetbuyingfacet.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract AssetbuyerTest is Test {
        Asset asset;
        NFT nft;

        address tester1 = mkaddr("tester1");
        address assetowner = mkaddr("assetowner");
   function setUp() public {
        asset = new Asset();
        vm.prank(tester1);
        nft = new NFT();

   }

//    function testAddFeed() public{
//     vm.startPrank(tester1);
//     vm.deal(tester1, 1000 ether);
//     asset.addpricefeeed("usdt", AggregatorV3Interface(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D));
//     vm.stopPrank();

//    }


   function testStageAsset() public{
    vm.startPrank(assetowner);
    vm.deal(assetowner, 1000 ether);
    asset.stageAsset("test", 1 ether, assetowner, address(nft), true, 0, 1);
    vm.stopPrank();

   }


    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
