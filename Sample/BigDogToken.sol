pragma solidity ^0.4.15;

contract BigDogToken {
    /* this creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    string public name;
    string public symbol;
    uint8 public decimals;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function BigDogToken(uint256 initialSupply,
                         string tokenName,
                         string tokenSymbol,
                         uint8 decimalUnits) {
        balanceOf[msg.sender] = initialSupply;
        name = tokenName; // set the name for display purposes
        symbol = tokenSymbol; // set the symbol for display purposes
        decimals = decimalUnits; // Amount of decimals for display purposes
    }

    /* Send Coins */
    function transfer(address _to, uint256 _value) {
        /* check if sender has balance and for overflows */
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        /* notify anyone listening that this transfer took place */
        Transfer(msg.sender, _to, _value);
    }


}
