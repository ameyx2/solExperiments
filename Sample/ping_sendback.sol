pragma solidity ^0.4.11;

contract ping_sendback {

    address public deployer;
    uint public total;

    /* Constructor */
    function ping_sendback() {
        deployer = msg.sender;
    }

    function ping() payable {
        total += msg.value;
        msg.sender.transfer(msg.value);
    }

    function () {
        log0("fallback function");
    }

}
