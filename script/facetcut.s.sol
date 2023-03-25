// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "../lib/forge-std/src/Script.sol";
import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/facets/Assetbuyingfacet.sol";
import "../contracts/Diamond.sol";

contract Addfacet is Script, IDiamondCut {
  
  address deployer =  0xE6e2595f5f910c8A6c4cf42267Ca350c6BA8c054;
   address DiamondAddr = 0xD391c0Cf4d914dd4B1b957163ca2764c9a8387f9;
   address diamondcut = 0x12D77B8ea61863E478Aa6B766f489Af5F7a95aa7;
   address Assetbuyeraddr = 0x206a0b20f28290D0dAC891996b9B4C71baD549E9;

    function run() public {
        // uint256 key = vm.envUint("private_key");
        // vm.startBroadcast(key);
        FacetCut[] memory slice = new FacetCut[](1);

        slice[0] = ( FacetCut({
            facetAddress: Assetbuyeraddr,
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("Assetbuyingfacet")
        }));

        uint256 key = vm.envUint("private_key");
        vm.startBroadcast(key);
        
        IDiamondCut (DiamondAddr).diamondCut(slice, address(0), "");
        IDiamondLoupe(DiamondAddr).facetAddresses();
        vm.stopBroadcast();


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
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}
 
