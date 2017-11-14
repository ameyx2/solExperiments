pragma solidity ^0.4.0;

// This contract is used for making a new opcode via a softfork.
// It works for opcodes that just evaluate an arbitrary function,
// returning y = f(x).
//
// The idea is to create a contract that implements an arbitrary key-value
// mapping, but miners (after the softfork) enforce that the only updates to the
// contract respect the correct function.
//
// To make this easy to enforce, the contract itself enforces that the mappings
// can only be written by a transaction from a user account (but the private
// key for this account is published / well-known).

contract SoftForkNewOpcode {

    // Private key (anyone can spend!):
    //   93e2eb1076b529bb3a51735b2592b647cbec20aa3c0005e5085c1c6ec9a3efe4
    address constant pk = 0x00710a6d61497bc23185ba14ea8130d2f5bd0c5050;

    mapping (bytes32 => bytes32) public data;

    function set(bytes32 k, bytes32 v) {
        // This function can only be called by the account above
        require(msg.sender == pk);
        data[k] = v;
    }

}
