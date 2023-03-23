// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";

library libAssetbuyer {
    

      function _stageAsset(
        string memory assetName,
        uint256 _AssetPrice,
        address _Assetowner,
        address _AssetAddress,
        bool _Assetpurchased,
        address _buyer,
        string memory  _AssetCategory
      ) internal {
        AssetData storage ds =AssetSlot();
        uint id = ds.assetId;
        ds.Assetdetail[id];
      } 


    function getLatestPrice (AggregatorV3Interface pricefeed) public view returns (uint80 roundID, int price,
        uint  startedAt,uint timeStamp,uint80 answeredInRound) {
        (roundID, price,startedAt,timeStamp,answeredInRound) = pricefeed.latestRoundData();
    } 

    function AssetSlot() internal pure returns(AssetData storage ds) {
        assembly {
            ds.slot := 0
        }
      }
}