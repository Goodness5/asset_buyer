// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


struct Assetdetails {
    string AssetName;
    uint256 AssetPrice;
    address Assetowner;
    address AssetAddress;
    bool Assetpurchased;
    address buyer;
    string AssetCategory;
}

struct AssetData {
    uint256 assetId;
    mapping (uint256 => Assetdetails) Assetdetail;

}