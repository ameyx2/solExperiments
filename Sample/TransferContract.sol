pragma solidity ^0.4.4;

contract TransferContract {
  address owner;

  address[] public receivers = [
    0x6aebda91307743b691b57ce664cdbf24beb02b61,
    0x002d364882703584a059c4160961f4231f1c2597,
    0xbd7a48c8989e8c215630617c5b8bcd24d35e1977
  ];

  uint lastBalance = 0;

  event AllocateLog(address indexed receiver, uint amount);

  modifier onlyOwner() {
    if (owner != msg.sender) throw;
    _;
  }

  function TransferContract() {
    owner = msg.sender;
  }

  function getBalance() returns(uint balance) {
    return this.balance;
  }

  function sendBalanceToOwner() onlyOwner returns(bool success) {
    if (!owner.send(this.balance)) {
      throw;
    }
    return true;
  }

  function allocate() payable onlyOwner returns (bool success, uint val) {
    // this.balance 已经加过了 msg.value
    uint avgAmount = (msg.value + lastBalance) / receivers.length;
    for (uint8 i = 0; i < receivers.length; i++) {
      if (!receivers[i].send(avgAmount)) {
        throw;
      }

      AllocateLog(receivers[i], avgAmount);
    }

    lastBalance = this.balance;
    return (true, avgAmount);
  }
}
