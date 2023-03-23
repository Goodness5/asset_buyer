// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";
import "./libAssetpricing.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol/";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";

library libAssetbuyer {


    function _stageAsset(
        string memory assetName,
        uint256 assetPrice,
        address assetOwner,
        address assetAddress,
        string memory assetCategory,
        uint256 _nftId
    ) internal {
        AssetData storage assetData = AssetSlot();
        uint256 assetId = assetData.assetId;
        assetData.Assetdetail[assetId] = Assetdetails({
            AssetName: assetName,
            AssetPrice: assetPrice,
            Assetowner: assetOwner,
            AssetAddress: assetAddress,
            Assetpurchased: false,
            buyer: address(0),
            AssetCategory: assetCategory,
            nftId: _nftId
        });
        assetData.assetId++;
    }

    function buyAsset(uint256 _assetid, string memory paymentToken) internal {
        AssetData storage assetData = AssetSlot();
        int price  = Assetpricing.calcPriceInToken(paymentToken, _assetid);
        IERC20 paymentTokenadd = IERC20(assetData.paymentmethod[paymentToken].paymentTokenAddress);
        uint256 balance = paymentTokenadd.balanceOf(msg.sender);
        require(balance >= uint256(price), "Insufficient balance");
        paymentTokenadd.approve(address(this), uint256(price));
        paymentTokenadd.transferFrom(msg.sender, address(this), uint256(price));
        assetData.Assetdetail[_assetid].buyer = msg.sender;
        assetData.Assetdetail[_assetid].Assetpurchased = true;
        string memory assetcategory = assetData.Assetdetail[_assetid].AssetCategory;
       address assetaddress =  assetData.Assetdetail[_assetid].AssetAddress;
       address assetowner =  assetData.Assetdetail[_assetid].Assetowner;
       uint nftid =  assetData.Assetdetail[_assetid].nftId;
        if (keccak256(bytes(assetcategory))==keccak256(bytes("ERC20"))) {
           IERC20(assetaddress).transferFrom(assetowner, msg.sender, uint256(price));
        }
        else if(keccak256(bytes(assetcategory))==keccak256(bytes("ERC721"))) {
           IERC721(assetaddress).transferFrom(assetowner, msg.sender, nftid);
        }


        
    }



 function getAssetDetails(uint256 assetId) public view returns (Assetdetails memory) {
        AssetData storage assetData = AssetSlot();
        require(assetData.Assetdetail[assetId].AssetAddress != address(0), "Asset does not exist");
        return assetData.Assetdetail[assetId];
    }

  function isAssetPurchased(uint256 assetId) public view returns (bool) {
        AssetData storage assetData = AssetSlot();
        require(assetData.Assetdetail[assetId].AssetAddress != address(0), "Asset does not exist");
        return assetData.Assetdetail[assetId].Assetpurchased;
    }


    function AssetSlot() internal pure returns(AssetData storage ds) {
        assembly {
            ds.slot := 0
        }
      }
}