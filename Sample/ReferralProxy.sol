pragma solidity ^0.4.13;

contract Ownable {
  address public owner;

  function Ownable() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

contract ReferralProxyHandler is Ownable{

    // Proxy is a contract throught which referral investors buy tokens
    address public proxy;
    // amount of tokens sold through proxy
    uint256 public fundedProxy = 0;

    modifier onlyProxy { require(msg.sender == proxy); _; }

    function setProxy(address _proxy)
        onlyOwner
    {
        proxy = _proxy;
    }

    function buyThroughProxy(address _buyer) payable;

}

contract ReferralProxy {

    ReferralProxyHandler public presaleContract;

    function ReferralProxy(address _presaleContract) {
        presaleContract = ReferralProxyHandler(_presaleContract);
    }

    function () payable {
        presaleContract.buyThroughProxy(msg.sender);
    }

    function buyTokens(address _buyer) payable {
        presaleContract.buyThroughProxy(_buyer);
    }

}
