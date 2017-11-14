pragma solidity ^0.4.4;

contract A {

    function A() {
    }

    function createB(string name) {
        return new B(msg.sender, name);
    }
}

pragma solidity ^0.4.4;

contract B {
    address owner
    string public name;

    function B(address _owner, string _name) {
        owner = _owner;
        name = _name;
    }
}

pragma solidity ^0.4.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/B.sol";

contract TestB {
    B testB;
    A testA;

    function beforeEach() {
        A = A(DeployedAddresses.A());
        B = testA.createB("test");
    }

    function testOwnerIsSet() {
        Assert.equal(address(A), address(B), "Owner's address does not match");
    }
}
