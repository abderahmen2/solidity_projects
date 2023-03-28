pragma solidity ^0.8.11;
contract multisend{
    event transaction_sucess(address  _sender,address payable[] recieve_list, uint mount);
    struct person { 
    address payable addr;
    uint balance ;}
    person public owner;


    constructor ()public payable {
        owner.addr=payable(msg.sender);
        owner.balance=msg.sender.balance;

    }
    function  getbalance ()public returns (uint){
        return address(this).balance;
    }
    modifier enoughether (address payable[] memory  _recievers,uint _amount){
        require(address(this).balance>_amount*_recievers.length);
        _;
    }
    function send (address payable[]  memory  recievers, uint amount) payable public  enoughether(recievers,amount){
        for (uint256 i = 0; i < recievers.length; i++) {
            recievers[i].transfer(amount);
        }
        emit transaction_sucess(owner.addr,recievers,amount);
    

            
        }

    }
    
