pragma solidity ^0.4.14;

contract workerTest {
    //Taking into account "key" refers to address, doesn't really matter
    address firstPos;
    address secondPos;
    mapping(address => uint256) workers;
    function workerTest(address firstWorker, address secondWorker, address thirdWorker) {
        //Such a smart contract would need to check any new additions against the top 2 positions
        //For simplicity we will use your values and 3 workers
        firstPos = secondWorker;
        secondPos = thirdWorker;
        workers[firstWorker] = 100;
        workers[secondWorker] = 500;
        workers[thirdWorker] = 460;
    }
    //Added in case you want to test in a local testnet f.e. testrpc
    function addWorker(uint256 startingBalance) {
        workers[msg.sender] = startingBalance;
        if (startingBalance > workers[secondPos]) {
            if (startingBalance > workers[firstPos]) {
                secondPos = firstPos;
                firstPos = msg.sender;
            } else {
                secondPos = msg.sender;
            }
        }
    }
    function mine() {
        //The first position can't mine from someone.
        require(msg.sender != firstPos);
        //Let's say a static 5% is taken each time
        workers[msg.sender] = workers[firstPos]*5/100;
        workers[firstPos] = workers[firstPos] - workers[firstPos]*5/100;
        //First check if the first one has fallen lower than the second one
        if (workers[firstPos] < workers[secondPos]) {
            address temp = firstPos;
            firstPos = secondPos;
            secondPos = temp;
        }
        //Then check if our miner got past any of the two positions
        if (workers[msg.sender] > workers[secondPos]) {
            if (workers[msg.sender] > workers[firstPos]) {
                secondPos = firstPos;
                firstPos = msg.sender;
            } else {
                secondPos = msg.sender;
            }
        }
    }
}
