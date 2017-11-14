pragma solidity ^0.4.11;

import 'zeppelin-solidity/token/SimpleToken.sol';
import 'zeppelin-solidity/token/Pausable.sol';

contract GustavoCoin is SimpleToken, Pausable {
  string constant name = "GUSTAVO COIN";
  string constant symbol = "GUS";
}
