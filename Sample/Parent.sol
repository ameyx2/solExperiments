pragma solidity ^0.4.10;

contract Parent
{

    uint value;

    function isValueOne() public constant returns (bool) {
        return value == 1;
    }

}


contract Child is Parent
{

    uint public value;

    function test() public {
        value = 1;
    }

    function verify() {
        require(isValueOne());
    }
}

pragma solidity ^0.4.10;

contract Parent
{

    uint public value;

    function isValueOne() public constant returns (bool) {
        return (value == 1);
    }

}


contract Child is Parent
{

    function test() public {
        value = 1;
    }

    function verify() constant returns (bool) {
        require(isValueOne());
        return true;
    }
}
