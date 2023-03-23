// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {libAssetbuyer} from "../libraries/libAssetbuyer.sol";
import {Assetpricing} from "../libraries/libAssetpricing.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Asset {
    constructor() {
        
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

    function addpricefeeed(string memory paymentname, AggregatorV3Interface pricefeedAdddess) external {
        Assetpricing.addpricefeeed(paymentname, pricefeedAdddess);
        
    }
    function getprice(string memory paymentname) external view{
        Assetpricing.getprice(paymentname);
    }

    function priceInUsersToken(string memory _tokenName, uint256 assetId) external view{
        Assetpricing.calcPriceInToken(_tokenName, assetId);
        
    }


    
}