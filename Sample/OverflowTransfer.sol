pragma solidity ^0.4.11;

//Contract purpose is to transfer any balance > x to an external address
//Sender:NickMulder.eth
//Receiver:LedgerNanoWallet (address TBD)
//x=40.00000000 ETH

contract OverflowTransfer {
    address x = 0x123; //Receiver Address
    address myAddress = this; //Contract Wallet

    function TransferCall() {
       if (myAddress.balance > 40 ether) x.transfer(myAddress.balance - 40 ether);
    }

}
