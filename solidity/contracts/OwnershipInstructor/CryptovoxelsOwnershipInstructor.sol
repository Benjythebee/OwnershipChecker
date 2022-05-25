//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IOwnershipInstructor.sol";


interface ICryptovoxelsContract {
    function ownerOf(uint256 _tokenId) external view returns (address _owner);
}

/**
 * Ownership Instructor Wrapper that wraps around the Voxels (cryptovoxels) contract,
 *
 * This is because cryptovoxels does not support the ERC721 interface.
 */
contract VoxelsOwnershipInstructor is IERC165,IOwnershipInstructor,Ownable{
    address cvAddress = 0x79986aF15539de2db9A5086382daEdA917A9CF0C;
    constructor(){
    }
    /**
     * @dev NOT AN EXAMPLE
     * @dev We know the Voxels contract address will change in the future.
     * This lets us change the address without redeploying a new contract.
     * Normally an OwnershipInstructor contract should be immutable.
     * @param _impl address of Voxels
     */
    function setVoxelsAddress(address _impl) external onlyOwner {
        cvAddress = _impl;
    }

    /**
    * Checks if the given contract is the voxels address
    * It should obtain an address as input and should return a boolean value;
    * @dev Contains a set of instructions to check the given _impl is the voxels contract
    * @param _impl address we want to check.
    * @return bool
    * 
    */
    function isValidInterface (address _impl) public view override returns (bool){
        return _impl == cvAddress;
    }

    /**
    * See {OwnershipInstructor.sol}
    * It should obtain a uint256 token Id as input and the address of the implementation 
    * It should return an address (or address zero is no owner);
    *
    * @param _tokenId token id we want to grab the owner of.
    * @param _impl Address of the NFT contract
    * @param _potentialOwner (OPTIONAL) A potential owner, set address zero if no potentialOwner;
    * @return address
    * 
    */
    function ownerOfTokenOnImplementation(address _impl,uint256 _tokenId,address _potentialOwner) public view override returns (address){
        require(isValidInterface(_impl),"Invalid interface");
        return ICryptovoxelsContract(_impl).ownerOf(_tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return interfaceId == type(IOwnershipInstructor).interfaceId || interfaceId == type(IERC165).interfaceId;
    }
}