// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {libAssetbuyer} from "../libraries/libAssetbuyer.sol";
import "../libraries/LibDiamond.sol";
import {Assetpricing} from "../libraries/libAssetpricing.sol";
import {OwnershipFacet} from "./OwnershipFacet.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract AssetFacet {
    constructor() {
        Assetpricing.addpricefeeed("usdt", 0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c, 0xdAC17F958D2ee523a2206206994597C13D831ec7);
        }
    function stageAsset(
        string memory assetName,
        uint256 assetPrice,
        address assetOwner,
        address assetAddress,
        bool isNFT,
        uint erc20value,
        uint256 _nftId
    ) external {
        libAssetbuyer._stageAsset(
            assetName,assetPrice,assetOwner,assetAddress,isNFT, erc20value,_nftId
        );
    }

    function buyAsset(uint256 _assetid, string memory paymentToken) external{
        libAssetbuyer.buyAsset(_assetid, paymentToken);
    }

    function getAssetDetails(uint256 assetId) external view {
        libAssetbuyer.getAssetDetails(assetId);
    }

    function isAssetPurchased(uint256 assetId) external view{
        libAssetbuyer.isAssetPurchased(assetId);
    }

    function addpricefeeed(string memory paymentname, address pricefeedAdddess, address tokenaddr)  external returns(int price){
        // LibDiamond.enforceIsContractOwner();
        Assetpricing.addpricefeeed(paymentname, pricefeedAdddess, tokenaddr);
        return price;
        
    }
    function getprice(string memory paymentname) external view returns(int price){
        Assetpricing.getprice(paymentname);
        return price;
    }

    function priceInUsersToken(string memory _tokenName, uint256 assetId) external view{
        Assetpricing.calcPriceInToken(_tokenName, assetId);
        
    }
     function withdrawERC20token(address _tokenaddress) external{
        LibDiamond.enforceIsContractOwner();
        libAssetbuyer.withdrawERC20token(_tokenaddress);
        
    }
     function withdrawERC721token(address _tokenaddress, uint _tokenid) external {
        LibDiamond.enforceIsContractOwner();
        libAssetbuyer.withdrawERC721token(_tokenaddress, _tokenid);
        
    }
     function withdraweth(uint _tokenid) external {
        LibDiamond.enforceIsContractOwner();
        libAssetbuyer.withdraweth(_tokenid);
        
    }


    
}