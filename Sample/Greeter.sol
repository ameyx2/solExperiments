pragma solidity ^0.4.4;

contract Greeter {

    function Greeter() {

    }

    function sayHello() returns(string) {
        return "hello";
    }
}

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var abiArray = JSON.parse('{"contract_name": "Greeter","abi": [{"constant": false,"inputs": [],"name": "sayHello","outputs": [{"name": "","type": "string"}],"payable": false,"type": "function"},{"inputs": [],"payable": false,"type": "constructor"}],"unlinked_binary": "0x6060604052341561000c57fe5b5b5b5b6101118061001e6000396000f300606060405263ffffffff60e060020a600035041663ef5fb05b81146020575bfe5b3415602757fe5b602d60a9565b6040805160208082528351818301528351919283929083019185019080838382156070575b805182526020831115607057601f1990920191602091820191016052565b505050905090810190601f168015609b5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60af60d3565b50604080518082019091526005815260d860020a6468656c6c6f0260208201525b90565b604080516020810190915260008152905600a165627a7a723058205c8157cef185e2881f9f3c49092242ef4418bb30363100e00c373e157ebb6a540029","networks": {"1496042639874": {"events": {},"links": {},"address": "0xc90f7594a02ecc8fe27dad58023537da569ebbc6","updated_at": 1496042652979}},"schema_version": "0.0.5","updated_at": 1496042652979}');

var MyContract = web3.eth.contract(abiArray);

var contractAddress = '0x03c99a158d7c5f94da4333b044a940c4c3a58582';
var contractInstance = MyContract.at(contractAddress);

console.log(contractInstance);

var result = contractInstance.sayHello().call();
console.log(result);

contract.js:56 Uncaught TypeError: contract.abi.filter is not a function
    at addFunctionsToContract (contract.js:56)
    at ContractFactory.at (contract.js:267)
    at ethereum.js:26

var contractInfo = JSON.parse('{"contract_name": "Greeter","abi": [{"constant": false,"inputs": [],"name": "sayHello","outputs": [{"name": "","type": "string"}],"payable": false,"type": "function"},{"inputs": [],"payable": false,"type": "constructor"}],"unlinked_binary": "0x6060604052341561000c57fe5b5b5b5b6101118061001e6000396000f300606060405263ffffffff60e060020a600035041663ef5fb05b81146020575bfe5b3415602757fe5b602d60a9565b6040805160208082528351818301528351919283929083019185019080838382156070575b805182526020831115607057601f1990920191602091820191016052565b505050905090810190601f168015609b5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60af60d3565b50604080518082019091526005815260d860020a6468656c6c6f0260208201525b90565b604080516020810190915260008152905600a165627a7a723058205c8157cef185e2881f9f3c49092242ef4418bb30363100e00c373e157ebb6a540029","networks": {"1496042639874": {"events": {},"links": {},"address": "0xc90f7594a02ecc8fe27dad58023537da569ebbc6","updated_at": 1496042652979}},"schema_version": "0.0.5","updated_at": 1496042652979}');

var MyContract = web3.eth.contract(contractInfo.abi);
