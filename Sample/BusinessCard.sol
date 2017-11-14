pragma solidity ^0.4.13;
contract BusinessCard {
    mapping (bytes32 => string) data;

    function setData(string key, string value) {
        data[sha3(key)] = value;
    }

    function getData(string key) constant returns(string) {
        return data[sha3(key)];
    }
}

pragma solidity ^0.4.13;
contract BusinessCard {
    mapping (bytes32 => string) data;

    function setData(string key, string value) {
        data[sha3(key)] = value;
    }

    function getData(string key) constant returns(string) {
        return data[sha3(key)];
    }

    function setPhone(string key, string value) {
        data[sha3(key)] = value;
    }

    function getPhone(string key) constant returns(string) {
        return data[sha3(key)];
    }
}

pragma solidity ^0.4.13;
contract BusinessCard {

    mapping (bytes32 => string) data;
    mapping (bytes32 => string) dataphone;

    function setData(string key, string value) {
        data[sha3(key)] = value;
    }

    function getData(string key) constant returns(string) {
        return data[sha3(key)];
    }

    function setPhone(string key, string value) {
        datadataphone[sha3(key)] = value;
    }

    function getPhone(string key) constant returns(string) {
        return datadataphone[sha3(key)];
    }
}
