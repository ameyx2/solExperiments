pragma solidity ^0.4.9;

contract Media{
    function() payable { }

    address owner;

    function Media(){
        owner = msg.sender;
    }



    function withdraw(uint value){
        if(owner != msg.sender) throw;

        if(!owner.send(value)) throw;
    }

    function getBalance() public constant returns (uint){
        return this.balance;
    }
}
