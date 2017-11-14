pragma solidity ^0.4.0;

contract HHH {
    struct Participant
    {
        address addr;
        uint value;
    }

    Participant[] participants;
    uint32 head;

    function participate() payable {
        participants.push(Participant({addr: msg.sender, value: uint64(msg.value * 2)}));

        while (head < participants.length && this.balance > participants[head].value) {
            participants[head].addr.transfer(participants[head].value);
            head++;
        }
    }
}
