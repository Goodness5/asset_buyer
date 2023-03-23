// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


struct Assetdetails {
    string AssetName;
    uint256 AssetPrice;
    address Assetowner;
    address AssetAddress;
    bool Assetpurchased;
}

struct AssetData {
    mapping (uint256 => Assetdetails) Assetdetail;
}