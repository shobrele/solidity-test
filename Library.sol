// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./Helper.sol";

contract Library {
    address public owner;

    struct Book {
        string name;
        uint quantity;
        bool exists;
    }

    mapping(string => Book) BookList;

    mapping(string => address[]) BookBorrowerList;

    mapping(address => string[]) ClientBorrowerList;

    modifier onlyOwnable(){
        require(msg.sender == owner, "Current user is not owner!");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function AddBook(Book calldata newBook) public onlyOwnable{
        if(BookList[newBook.name].exists){
            revert("Book already exists in the Library!");
        }

        BookList[newBook.name] = newBook;
        BookList[newBook.name].exists = true;
    }

    function BorrowBook(string calldata bookName) public{
        if(DoesContainElement(bookName, msg.sender)){
            revert("Book already exists in the Library!");
        }
        if(BookList[bookName].quantity==0){
            revert("Book is out of stock currently!");
        }

        ClientBorrowerList[msg.sender];
        BookBorrowerList[bookName].push(msg.sender);
        BookList[bookName].quantity --;
    }

    function ReturnBook(string calldata bookName) public {
        if(!DoesContainElement(bookName, msg.sender)){
            revert("Book does not exists in the Library!");
        }
        //if(BookBorrowerList[bookName])

        ClientBorrowerList[msg.sender] += bookName;
        BookBorrowerList[bookName] -= msg.sender;
        BookList[bookName].quantity ++;
    }
}