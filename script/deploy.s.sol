// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../lib/forge-std/src/Script.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/Assetbuyingfacet.sol";

contract DiamondDeployer is Script, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    Assetbuyingfacet AssetF;


   address deployer =  0xE6e2595f5f910c8A6c4cf42267Ca350c6BA8c054;
    function run() public {
        uint256 key = vm.envUint("private_key");
        vm.startBroadcast(key);
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(deployer, address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        AssetF  = new Assetbuyingfacet();

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](2);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");
        DiamondLoupeFacet(address(diamond)).facetAddresses();
         vm.stopBroadcast();

        console.log(address(dCutFacet));
        console.log(address(diamond));
        console.log(address(dLoupe));
        console.log(address(ownerF));
        console.log(address(AssetF));
    }

    function generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

       function testAssetFacet() public {
        run();
        FacetCut[] memory slice = new FacetCut[](1);

        slice[0] = ( FacetCut({
            facetAddress: address(AssetF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("Assetbuyingfacet")
        }));
        IDiamondCut(address(diamond)).diamondCut(slice, address(0), "");
         DiamondLoupeFacet(address(diamond)).facetAddresses();
    }
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}


}
