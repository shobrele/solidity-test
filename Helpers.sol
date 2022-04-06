// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Helpers{
    function intArrContainsValue(uint value, uint[] memory array) internal pure returns(bool){   
        for (uint i=0; i < array.length; i++) {
            if (value == array[i]) {     
                return true;
            }
        }
        return false;
    }

    function addressArrContainsValue(address value, address[] memory array) internal pure returns(bool){   
        for (uint i=0; i < array.length; i++) {
            if (value == array[i]) {     
                return true;
            }
        }
        return false;
    }

    function removeIntArrElement(uint[] storage array, uint id) internal{
         for (uint i=0; i < array.length; i++) {
            if (id == array[i]) {
                array[i] = array[array.length - 1];
                array.pop();
            }
        }
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}