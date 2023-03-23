// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";



library Assetpricing {
    


    function addpricefeeed(string memory paymentname, AggregatorV3Interface pricefeedAdddess) internal {
        AssetData storage ds = AssetSlot();

        ds.paymentmethods.push(paymentname);
        ds.paymentmethod[paymentname].paymentToken = pricefeedAdddess;
       AggregatorV3Interface pricefeed = AggregatorV3Interface(pricefeedAdddess);
        (, int Price, , , ) = getLatestPrice(pricefeed);
        Price = ds.paymentmethod[paymentname].price;

    }
   function getprice(string memory _paymentname) internal view returns (int _price) {
    AssetData storage ds = AssetSlot();
    string[] memory names = ds.paymentmethods;
    for (uint i = 0; i < names.length; i++) {
         string memory name = names[i];
        if (keccak256(bytes(name))==keccak256(bytes(_paymentname))) {
            _price = ds.paymentmethod[_paymentname].price;
        }else{
            revert("payment method not found");
        }
    }
        return _price;
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