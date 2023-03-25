// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {libAssetbuyer} from "../libraries/libAssetbuyer.sol";

import { AssetData, Assetdetails } from "../libraries/libAssetData.sol";
import "../libraries/libAssetpricing.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol/";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";

import "../libraries/LibDiamond.sol";
import {Assetpricing} from "../libraries/libAssetpricing.sol";
import {OwnershipFacet} from "./OwnershipFacet.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../libraries/libAssetData.sol";

contract Assetbuyingfacet {
    AssetData  ds;

    constructor() {
        Assetpricing.addpricefeeed("usdc", 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
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