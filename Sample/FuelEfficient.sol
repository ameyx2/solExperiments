pragma solidity ^0.4.8;

//Allows for decentralized incentivization of initilizing storage
//to pay lower fees overall.

contract FuelEfficient {
    uint maxGasPrice;
    address contractAdd;

    function FuelEfficient(uint _maxGasPrice, address add) {
        maxGasPrice = _maxGasPrice;
        contractAdd = add;
    }

    function poke() {
        if (tx.gasprice > maxGasPrice) throw;
        if (msg.gas * tx.gasprice < this.balance / 2) throw;
        contractAdd.call(bytes4(sha3("poke()")));
        msg.sender.send(this.balance);
    }

    function deposit() payable {}
}
