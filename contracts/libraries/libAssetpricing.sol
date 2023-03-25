// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol/";



library Assetpricing {
    


    function addpricefeeed(string memory paymentname, address pricefeedAdddess, address _paymentTokenAddress) internal returns (int price){
        AssetData storage ds = AssetSlot();

        ds.paymentmethods.push(paymentname);
        ds.paymentmethod[paymentname].paymentTokenfeed = pricefeedAdddess;
       AggregatorV3Interface pricefeed = AggregatorV3Interface(pricefeedAdddess);
        int Price = getLatestPrice(pricefeed);

        // token price in usd
        ds.paymentmethod[paymentname].price = Price;
        ds.paymentmethod[paymentname].paymentTokenAddress = _paymentTokenAddress;
        price = Price;

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
    // returns price in usd
        return _price;
}


       function calcPriceInToken(string memory _tokenName, uint256 assetId) view internal returns(int amountToPay){
            AssetData storage ds = AssetSlot();

            int paymentPriceInUsd = getprice(_tokenName);
            // gets eth price in usd
            AggregatorV3Interface ethpricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
            int ethPrice = getLatestPrice(ethpricefeed);
            int256 assetPriceInUsd = int256(ethPrice) * int256(ds.Assetdetail[assetId].AssetPrice);
            //get the price in usd of the token user wants to pay

            address paymentTokenAddress = ds.paymentmethod[_tokenName].paymentTokenAddress;
            uint8 paymentTokenDecimals = IERC20Metadata(paymentTokenAddress).decimals();
            int256 assetPriceInPaymentToken = (assetPriceInUsd * int256(10 ** paymentTokenDecimals)) / int256(paymentPriceInUsd);
            int256 paymentAmount = assetPriceInPaymentToken * paymentPriceInUsd /int256( 10 ** paymentTokenDecimals);
            amountToPay = paymentAmount;

}


     


   function getLatestPrice(AggregatorV3Interface priceFeed) internal view returns (int) {
        ( , int price, , , ) = priceFeed.latestRoundData();
        return price;
    }

     function AssetSlot() internal pure returns(AssetData storage ds) {
        assembly {
            ds.slot := 0
        }
      }
}