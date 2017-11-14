pragma solidity ^0.4.11;

contract Callee {
  uint256 public counter;

  function addOne() {
    counter = counter + 1;
  }

  function addNum(uint256 num) {
    counter = counter + num;
  }
}
