pragma solidity ^0.4.4;
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract AudioToken is StandardToken {
  string public name = 'Audio';
  string public symbol = 'AUD';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 1200000;

  function AudioToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}
