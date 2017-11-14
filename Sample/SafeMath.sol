pragma solidity ^0.4.13;

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 value) returns (bool);

  // KYBER-NOTE! code changed to comply with ERC20 standard
  event Transfer(address indexed _from, address indexed _to, uint _value);
  //event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
   * @dev transfer token for a specified address
   * @param _to The address to transfer to.
   * @param _value The amount to be transferred.
   */
  function transfer(address _to, uint256 _value) returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Gets the balance of the specified address.
   * @param _owner The address to query the the balance of.
   * @return An uint256 representing the amount owned by the passed address.
   */
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) returns (bool);
  function approve(address spender, uint256 value) returns (bool);

  event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract DistributeEth {

  using SafeMath for uint;

  address[] public listAddress;

  address owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

	function DistributeEth() {
    owner = msg.sender;
  }

  function nAddresses () constant returns (uint) {
    return listAddress.length;
  }

  function addAddresses (address[] _addrs) payable onlyOwner{
    uint i = 0;
    for (i = 0; i < _addrs.length; i++) {
      listAddress.push(_addrs[i]);
    }
  }

  function withdraw(ERC20 anyToken) onlyOwner returns(bool){
    if( this.balance > 0 ) {
      require(owner.send(this.balance));
    }

    if( anyToken != address(0x0) ) {
      assert( anyToken.transfer(owner, anyToken.balanceOf(this)) );
    }

    return true;
  }

	function () onlyOwner payable {
    uint i = 0;
    var value = msg.value.div(listAddress.length);
		for (i = 0; i < listAddress.length; i++) {
      require(listAddress[i].send(value));
    }
	}
}
