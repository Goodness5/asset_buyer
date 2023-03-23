// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AssetData, Assetdetails } from "./libAssetData.sol";

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol/";

library libAssetbuyer {
    
    function AssetSlot() internal pure returns(AssetData storage ds) {
        assembly {
            ds.slot := 0
        }
      }

      function _stageAsset() internal {
        AssetData storage ds =AssetSlot();
        ds.assetId +=1;
      }
}