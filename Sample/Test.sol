sm = require("solc-mock");

var contract = sm.mock(`
  pragma solidity ^0.4.11;
  contract Test {
    function add(uint x, uint y) constant returns (uint) {
      return x + y;
    }
  }
`);

console.log(contract.add("0x1", "0x2")); // output: 0x3
// also contract.add.send for txs
