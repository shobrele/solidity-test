// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Helper{
    uint[] public firstArray = [1,2,3,4,5];

    function removeItem(uint i) public{
      delete firstArray[i];
    }

    function getLength() public view returns(uint){
      return firstArray.length;
    }

    //move to helper contract
    function DoesContainElement(string calldata bookName, address client) private view returns(bool){   
        string[] memory borrowedBooksByClient = ClientBorrowerList[client];         
        for (uint i=0; i < borrowedBooksByClient.length; i++) {
            if (compareStrings(bookName, borrowedBooksByClient[i])) {     
                return true;
            }
        }
        return false;
    }

    //move to helper contract
    function compareStrings(string memory a, string memory b) public view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}