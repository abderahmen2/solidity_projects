pragma solidity ^0.8.11;
contract etherwallet{
    address payable public  owner;
    uint public balance;
    constructor (){
        owner=payable(msg.sender);
    }
    function recieve ()external payable returns(uint) {
       
        return msg.value;

    }
    function getbalance ()public returns(uint){
        balance=address(this).balance;
        return balance;}
    modifier enough (uint _amount){
        require(balance>_amount,"you dont have enought eth");
        _;

    }
    modifier owneronly (){
        require (payable(msg.sender)==owner,"you are not allowed to withdraw");
        _;
    }

    function withdraw(address reciever ,uint amount)public payable owneronly enough(amount){
        (bool sent ,bytes memory data )=reciever.call{value:amount}("");
       require(sent);
       balance-=amount;

    }
    
}