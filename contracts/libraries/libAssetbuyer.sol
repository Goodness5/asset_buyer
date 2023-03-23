// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";

library libAssetbuyer {


    function _stageAsset(
        string memory assetName,
        uint256 assetPrice,
        address assetOwner,
        address assetAddress,
        string memory assetCategory
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
            AssetCategory: assetCategory
        });
        assetData.assetId++;
    }



    function AssetSlot() internal pure returns(AssetData storage ds) {
        assembly {
            ds.slot := 0
        }
      }
}