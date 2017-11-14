pragma solidity ^0.4.4;
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract TutorialToken is StandardToken {
    string public name = 'TutorialToken';
    string public symbol = 'TT';
    uint public decimals = 2;
    uint public INITIAL_SUPPLY = 12000;

    function TotorialToken() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}

TutorialToken.deployed().then(c => c.balanceOf('<0th account addr>').then(b => console.log(b)))

{ [String: '0'] s: 1, e: 0, c: [ 0 ] }

address owner;

function TutorialToken() {
    owner = msg.sender;
    ...
}

pragma solidity ^0.4.8;
contract myContract  {

    address public owner;

    function myContract() {
        owner = msg.sender;
    }
}
