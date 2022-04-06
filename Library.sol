// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./Helpers.sol";

contract Library is Helpers{
    address public owner;

    struct Book {
        uint id;
        string name;
        uint quantity;
        bool exists;
    }

    uint counter;

    Book[] public LibraryArchive;

    mapping(uint => Book) BookIndex;

    mapping(uint => address[]) BookBorrowHistory;

    mapping(address => uint[]) ClientBorrowList;

    modifier onlyOwnable(){
        require(msg.sender == owner, "Current user is not owner!");
        _;
    }

    modifier shouldExist(uint bookId){
        require(BookIndex[bookId].exists,"Book does not exist in library!");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function AddBook(string calldata bookName, uint quantity) public onlyOwnable{
        if(LibraryContainsBook(bookName) || BookIndex[counter].exists){
            revert("This book exists in the library!");
        }
        if(quantity < 1){
            revert("Quantity cannot be less than 1!");
        }

        Book memory newBook;
        newBook.id = counter;
        newBook.name = bookName;
        newBook.quantity = quantity;
        newBook.exists = true;

        BookIndex[counter] = newBook;
        LibraryArchive.push(newBook);

        counter++;
    }

    function BorrowBook(uint bookId) public shouldExist(bookId){    
        if(BookIndex[bookId].quantity==0){
            revert("This book is out of stock currently!");
        }    
        if(intArrContainsValue(bookId, ClientBorrowList[msg.sender])){
            revert("You've already borrowed that book!");
        }

        ClientBorrowList[msg.sender].push(bookId);


        if(!addressArrContainsValue(msg.sender, BookBorrowHistory[bookId])){
            BookBorrowHistory[bookId].push(msg.sender);        
        }

        BookIndex[bookId].quantity --;
        LibraryArchive[bookId].quantity --;
    }

    function ReturnBook(uint bookId) public shouldExist(bookId){
        if(!intArrContainsValue(bookId, ClientBorrowList[msg.sender])){
            revert("You havent borrowed that book!");
        }
  
        //remove book from list of borrowed books for the specific client
        removeIntArrElement(ClientBorrowList[msg.sender], bookId);
        BookIndex[bookId].quantity ++;
        LibraryArchive[bookId].quantity ++;
    }

    function BorrowHistory(uint bookId) public view shouldExist(bookId) returns (address[] memory){
        return BookBorrowHistory[bookId];
    }

    function LibraryContainsBook(string calldata bookName) private view returns (bool){
        for(uint i=0;i<LibraryArchive.length;i++){
            if(compareStrings(LibraryArchive[i].name, bookName)){
                return true;
            }
        }
        return false;
    }

}