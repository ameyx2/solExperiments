pragma solidity ^0.4.13;

contract Ownable_ {
    address public owner;

    function Ownable() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

}

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
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20_ {
    uint public totalSupply;
    function balanceOf(address who) constant returns (uint);
    function allowance(address owner, address spender) constant returns (uint);

    function transfer(address to, uint value) returns (bool ok);
    function transferFrom(address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract SafeMath_ {
    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }

    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }

    function assert(bool assertion) internal {
        if (!assertion) {
            throw;
        }
    }
}

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract TokenDestructible is Ownable {

  function TokenDestructible() payable { }

  /**
   * @notice Terminate contract and refund to owner
   * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
   refund.
   * @notice The called token contracts could try to re-enter this contract. Only
   supply token contracts you trust.
   */
  function destroy(address[] tokens) onlyOwner public {

    // Transfer tokens to owner
    for(uint256 i = 0; i < tokens.length; i++) {
      ERC20Basic token = ERC20Basic(tokens[i]);
      uint256 balance = token.balanceOf(this);
      token.transfer(owner, balance);
    }

    // Transfer Eth to owner and terminate contract
    selfdestruct(owner);
  }
}

contract VeRentExposure is TokenDestructible {

    //--- Definitions

    using SafeMath for uint;

    struct RentExposure {
        bytes32 id;
        address veriAccount;
        address etherAccount;
        uint256 veriAmount;
        uint256 price;
        uint256 initialValue;
        uint256 finalValue;
        bool veriSettled;
        bool etherSettled;
    }

    uint256 constant public PRICE_100_PERCENT = 1 ether;

    //--- Storage

    VeritaseumToken public veToken;
    VeExposure public veExposure;

    uint256 public minPrice;
    uint256 public maxPrice;

    mapping (bytes32 => RentExposure) exposures;

    //--- Constructor

    function VeRentExposure(
        VeritaseumToken _veToken,
        VeExposure _veExposure,
        uint256 _minPrice,
        uint256 _maxPrice
    ) {
        require(_veToken != address(0));
        require(_veExposure != address(0));
        require(_minPrice <= _maxPrice && _maxPrice <= PRICE_100_PERCENT);

        veToken = _veToken;
        veExposure = _veExposure;
        minPrice = _minPrice;
        maxPrice = _maxPrice;
    }

    //--- Accessors

    function ratio() public constant returns (uint256) {
        return veExposure.ratio();
    }

    function minVeriAmount() public constant returns (uint256) {
        return veExposure.minVeriAmount();
    }

    function maxVeriAmount() public constant returns (uint256) {
        return veExposure.maxVeriAmount();
    }

    function minDuration() constant public returns (uint32) {
        return veExposure.minDuration();
    }

    function maxDuration() constant public returns (uint32) {
        return veExposure.maxDuration();
    }

    function setMinPrice(uint256 _minPrice) public onlyOwner {
        require(_minPrice <= maxPrice);

        minPrice = _minPrice;
    }

    function setMaxPrice(uint256 _maxPrice) public onlyOwner {
        require(_maxPrice >= minPrice && _maxPrice <= PRICE_100_PERCENT);

        maxPrice = _maxPrice;
    }

    //--- Events

    event RentExposureOpened(
        bytes32 indexed id,
        address indexed veriAccount,
        address indexed etherAccount,
        uint256 veriAmount,
        uint256 value,
        uint256 price,
        uint32 duration
    );

    event VeriExposureSettled(
        bytes32 indexed id,
        address indexed account,
        uint256 value
    );

    event EtherExposureSettled(
        bytes32 indexed id,
        address indexed account,
        uint256 value
    );

    //--- Public functions

    function open(
        address veriAccount,
        address etherAccount,
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint256 nonce
    )
        public
        payable
        returns (bytes32)
    {
        require(veriAccount != address(0));
        require(etherAccount != address(0));
        require(price >= minPrice && minPrice <= maxPrice);

        forwardTokens(veriAmount);

        bytes32 id = calculateId({
            veriAmount: veriAmount,
            value: msg.value,
            duration: duration,
            nonce: nonce
        });

        require(!exists(id));
        exposures[id] = RentExposure({
            id: id,
            veriAccount: veriAccount,
            etherAccount: etherAccount,
            veriAmount: veriAmount,
            initialValue: msg.value,
            finalValue: 0,
            price: price,
            veriSettled: false,
            etherSettled: false
        });

        RentExposureOpened({
            id: id,
            veriAccount: veriAccount,
            etherAccount: etherAccount,
            veriAmount: veriAmount,
            value: msg.value,
            price: price,
            duration: duration
        });

        veExposure.open.value(msg.value)({
            veriAmount: veriAmount,
            duration: duration,
            nonce: nonce
        });
    }

    function settle(bytes32 id) public {
        require(exists(id));

        RentExposure storage exposure = exposures[id];
        bool shouldSettleVeri = (msg.sender == exposure.veriAccount && !exposure.veriSettled);
        bool shouldSettleEther = (msg.sender == exposure.etherAccount && !exposure.etherSettled);
        require(shouldSettleVeri || shouldSettleEther);

        if (!exposure.veriSettled && !exposure.etherSettled) {
            exposure.finalValue = veExposure.settle(id);
        }

        if (shouldSettleVeri) {
            settleVeri(exposure);
        }

        if (shouldSettleEther) {
            settleEther(exposure);
        }

        if (exposure.veriSettled && exposure.etherSettled) {
            delete exposures[id];
        }
    }

    //--- Public constant functions

    function exists(bytes32 id) public constant returns (bool) {
        return exposures[id].veriAccount != address(0);
    }

    function calculateId(
        uint256 veriAmount,
        uint256 value,
        uint32 duration,
        uint256 nonce
    )
        public
        constant
        returns (bytes32)
    {
        return veExposure.calculateId({
            veriAmount: veriAmount,
            value: value,
            duration: duration,
            nonce: nonce
        });
    }

    function checkRatio(uint256 veriAmount, uint256 value)
        public
        constant
        returns (bool)
    {
        return veExposure.checkRatio(veriAmount, value);
    }

    //--- Fallback function

    function() public payable {
        // accept Ether deposits
    }

    //--- Private functions

    function settleVeri(RentExposure storage exposure) private {
        assert(msg.sender == exposure.veriAccount && !exposure.veriSettled);

        uint256 transferValue = 0;
        if (exposure.finalValue > exposure.initialValue) {
            // transfer part of profits (price)
            uint256 totalProfit = exposure.finalValue - exposure.initialValue;
            uint256 veriPrice = exposure.price;
            uint256 veriProfit = totalProfit.mul(veriPrice).div(1 ether);
            transferValue = veriProfit;
        }

        exposure.veriSettled = true;
        if (transferValue > 0) {
            exposure.veriAccount.transfer(transferValue);
        }

        VeriExposureSettled({
            id: exposure.id,
            account: msg.sender,
            value: transferValue
        });
    }

    function settleEther(RentExposure storage exposure) private {
        assert(msg.sender == exposure.etherAccount && !exposure.etherSettled);

        uint256 transferValue = 0;
        if (exposure.finalValue > exposure.initialValue) {
            // transfer part of profits (100% - price)
            uint256 totalProfit = exposure.finalValue - exposure.initialValue;
            uint256 etherPrice = PRICE_100_PERCENT.sub(exposure.price);
            uint256 etherProfit = totalProfit.mul(etherPrice).div(1 ether);
            transferValue = exposure.initialValue.add(etherProfit);
        } else {
            // transfer remains
            transferValue = exposure.finalValue;
        }

        exposure.etherSettled = true;
        if (transferValue > 0) {
            exposure.etherAccount.transfer(transferValue);
        }

        EtherExposureSettled({
            id: exposure.id,
            account: msg.sender,
            value: transferValue
        });
    }

    function forwardTokens(uint256 veriAmount) private {
        require(veToken.transferFrom(msg.sender, this, veriAmount));
        require(veToken.approve(veExposure, veriAmount));
    }
}

contract StandardToken_ is ERC20_, SafeMath_ {

    mapping(address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    function transfer(address _to, uint _value) returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        var _allowance = allowed[_from][msg.sender];

        // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
        // if (_value > _allowance) throw;

        balances[_to] = safeAdd(balances[_to], _value);
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

}

contract VeritaseumToken is Ownable_, StandardToken_ {

    string public name = "Veritaseum";          // name of the token
    string public symbol = "VERI";              // ERC20 compliant 4 digit token code
    uint public decimals = 18;                  // token has 18 digit precision

    uint public totalSupply = 100000000 ether;  // total supply of 100 Million Tokens

    /// @notice Initializes the contract and allocates all initial tokens to the owner
    function VeritaseumToken() {
        balances[msg.sender] = totalSupply;
    }

    //////////////// owner only functions below

    /// @notice To transfer token contract ownership
    /// @param _newOwner The address of the new owner of this contract
    function transferOwnership(address _newOwner) onlyOwner {
        balances[_newOwner] = balances[owner];
        balances[owner] = 0;
        Ownable_.transferOwnership(_newOwner);
    }
}

contract VeRent is TokenDestructible {

    //--- Definitions

    using SafeMath for uint256;

    struct VeriOffer {
        address account;
        uint256 veriAmount;
        uint256 price;
        uint32 duration;
        uint64 expiration;
    }

    struct EtherOffer {
        address account;
        uint256 veriAmount;
        uint256 value;
        uint256 price;
        uint32 duration;
        uint64 expiration;
    }

    struct VeriIndex {
        mapping (bytes32 => VeriBucket) buckets;
    }

    struct EtherIndex {
        mapping (bytes32 => EtherBucket) buckets;
    }

    struct VeriBucket {
        bytes32[] ids;
    }

    struct EtherBucket {
        bytes32[] ids;
    }

    //--- Storage

    VeritaseumToken public veToken;
    VeRentExposure public veRentExposure;

    mapping (bytes32 => VeriOffer) public veriOffers;
    mapping (bytes32 => EtherOffer) public etherOffers;

    EtherIndex private etherIndex;
    VeriIndex private veriIndex;

    //--- Constructor

    function VeRent(VeritaseumToken _veToken, VeRentExposure _veRentExposure) {
        require(_veToken != address(0));
        require(_veRentExposure != address(0));

        veToken = _veToken;
        veRentExposure = _veRentExposure;
    }

    //--- Accessors

    function ratio() public constant returns (uint256) {
        return veRentExposure.ratio();
    }

    function minVeriAmount() public constant returns (uint256) {
        return veRentExposure.minVeriAmount();
    }

    function maxVeriAmount() public constant returns (uint256) {
        return veRentExposure.maxVeriAmount();
    }

    function minDuration() public constant returns (uint32) {
        return veRentExposure.minDuration();
    }

    function maxDuration() public constant returns (uint32) {
        return veRentExposure.maxDuration();
    }

    function minPrice() public constant returns (uint256) {
        return veRentExposure.minPrice();
    }

    function maxPrice() public constant returns (uint256) {
        return veRentExposure.maxPrice();
    }

    //--- Events

    event VeriOfferAdded(
        bytes32 indexed id,
        address indexed account,
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint64 expiration
    );

    event EtherOfferAdded(
        bytes32 indexed id,
        address indexed account,
        uint256 veriAmount,
        uint256 value,
        uint256 price,
        uint32 duration,
        uint64 expiration
    );

    event DealMade(
        bytes32 id,
        bytes32 veriId,
        bytes32 etherId,
        address indexed veriAccount,
        address indexed etherAccount,
        uint256 veriAmount,
        uint256 value,
        uint256 price,
        uint32 duration
    );

    event VeriOfferCancelled(bytes32 indexed id);
    event EtherOfferCancelled(bytes32 indexed id);

    //--- Public functions

    function addVeriOffer(
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint64 expiration,
        uint256 nonce
    )
        public
    {
        require(veriAmount >= minVeriAmount() && veriAmount <= maxVeriAmount());
        require(price >= minPrice() && price <= maxPrice());
        require(duration >= minDuration() && duration <= maxDuration());
        require(isDefaultOrFuture(expiration));

        // remember to call approve(...) on Veritaseum Token before calling this function
        require(veToken.transferFrom(msg.sender, this, veriAmount));

        bytes32 veriId = calculateOfferId({
            veriAmount: veriAmount,
            value: 0,
            price: price,
            duration: duration,
            expiration: expiration,
            nonce: nonce
        });

        require(!veriOfferExists(veriId));

        VeriOfferAdded({
            id: veriId,
            account: msg.sender,
            veriAmount: veriAmount,
            price: price,
            duration: duration,
            expiration: expiration
        });

        bytes32 bucketKey = calculateBucketKey({
            veriAmount: veriAmount,
            price: price,
            duration: duration
        });

        if (!matchEtherOffer(bucketKey, veriId, nonce)) {
            saveVeriOffer({
                bucketKey: bucketKey,
                veriId: veriId,
                veriAmount: veriAmount,
                price: price,
                duration: duration,
                expiration: expiration
            });
        }
    }

    function addEtherOffer(
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint64 expiration,
        uint256 nonce
    )
        public
        payable
    {
        require(price >= minPrice() && price <= maxPrice());
        require(duration >= minDuration() && duration <= maxDuration());
        require(isDefaultOrFuture(expiration));
        require(checkRatio(veriAmount, msg.value));

        bytes32 etherId = calculateOfferId({
            veriAmount: veriAmount,
            value: msg.value,
            price: price,
            duration: duration,
            expiration: expiration,
            nonce: nonce
        });

        require(!etherOfferExists(etherId));

        EtherOfferAdded({
            id: etherId,
            account: msg.sender,
            veriAmount: veriAmount,
            value: msg.value,
            price: price,
            duration: duration,
            expiration: expiration
        });

        bytes32 bucketKey = calculateBucketKey({
            veriAmount: veriAmount,
            price: price,
            duration: duration
        });

        if (!matchVeriOffer(bucketKey, etherId, nonce)) {
            saveEtherOffer({
                bucketKey: bucketKey,
                etherId: etherId,
                veriAmount: veriAmount,
                price: price,
                duration: duration,
                expiration: expiration
            });
        }
    }

    function cancelVeriOffer(bytes32 veriId) public {
        VeriOffer storage offer = veriOffers[veriId];
        require(msg.sender == offer.account || msg.sender == owner);

        bytes32 bucketKey = calculateBucketKey({
            veriAmount: offer.veriAmount,
            price: offer.price,
            duration: offer.duration
        });
        VeriBucket storage veriBucket = veriIndex.buckets[bucketKey];

        // copy before deletion
        uint256 veriAmount = offer.veriAmount;
        address veriAccount = offer.account;

        removeVeriOffer(veriBucket, veriId);
        paybackTokens(veriAccount, veriAmount);

        VeriOfferCancelled(veriId);
    }

    function cancelEtherOffer(bytes32 etherId) public {
        EtherOffer storage offer = etherOffers[etherId];
        require(msg.sender == offer.account || msg.sender == owner);

        bytes32 bucketKey = calculateBucketKey({
            veriAmount: offer.veriAmount,
            price: offer.price,
            duration: offer.duration
        });
        EtherBucket storage etherBucket = etherIndex.buckets[bucketKey];

        // copy before deletion
        uint256 value = offer.value;
        address etherAccount = offer.account;

        removeEtherOffer(etherBucket, etherId);
        paybackEther(etherAccount, value);

        EtherOfferCancelled(etherId);
    }

    //--- Public constant functions

    function checkRatio(uint256 veriAmount, uint256 value)
        public
        constant
        returns (bool)
    {
        return veRentExposure.checkRatio(veriAmount, value);
    }

    function veriOfferExists(bytes32 veriId)
        public
        constant
        returns (bool)
    {
        return veriOffers[veriId].account != address(0);
    }

    function etherOfferExists(bytes32 etherId)
        public
        constant
        returns (bool)
    {
        return etherOffers[etherId].account != address(0);
    }

    //--- Fallback function

    function() {
        // prevent accidental sending Ether
        revert();
    }

    //--- Private functions

    function matchVeriOffer(bytes32 bucketKey, bytes32 etherId, uint256 nonce)
        private
        returns (bool)
    {
        VeriBucket storage veriBucket = veriIndex.buckets[bucketKey];

        for (uint256 i = 0; i < veriBucket.ids.length; i++) {
            bytes32 matchingVeriId = veriBucket.ids[i];

            VeriOffer storage matchingOffer = veriOffers[matchingVeriId];
            if (isDefaultOrFuture(matchingOffer.expiration)) {
                openRentExposure({
                    veriId: matchingVeriId,
                    etherId: etherId,
                    veriAccount: matchingOffer.account,
                    etherAccount: msg.sender,
                    veriAmount: matchingOffer.veriAmount,
                    value: msg.value,
                    price: matchingOffer.price,
                    duration: matchingOffer.duration,
                    nonce: nonce
                });

                removeVeriOffer(veriBucket, matchingVeriId);
                return true;
            }
        }
        return false;
    }

    function matchEtherOffer(bytes32 bucketKey, bytes32 veriId, uint256 nonce)
        private
        returns (bool)
    {
        EtherBucket storage etherBucket = etherIndex.buckets[bucketKey];

        for (uint256 i = 0; i < etherBucket.ids.length; i++) {
            bytes32 matchingEtherId = etherBucket.ids[i];

            EtherOffer storage matchingOffer = etherOffers[matchingEtherId];
            if (isDefaultOrFuture(matchingOffer.expiration)) {
                openRentExposure({
                    veriId: veriId,
                    etherId: matchingEtherId,
                    veriAccount: msg.sender,
                    etherAccount: matchingOffer.account,
                    veriAmount: matchingOffer.veriAmount,
                    value: matchingOffer.value,
                    price: matchingOffer.price,
                    duration: matchingOffer.duration,
                    nonce: nonce
                });

                removeEtherOffer(etherBucket, matchingEtherId);
                return true;
            }
        }
        return false;
    }

    function saveVeriOffer(
        bytes32 bucketKey,
        bytes32 veriId,
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint64 expiration
    )
        private
    {
        VeriBucket storage veriBucket = veriIndex.buckets[bucketKey];
        veriBucket.ids.push(veriId);

        veriOffers[veriId] = VeriOffer({
            account: msg.sender,
            veriAmount: veriAmount,
            price: price,
            duration: duration,
            expiration: expiration
        });
    }

    function saveEtherOffer(
        bytes32 bucketKey,
        bytes32 etherId,
        uint256 veriAmount,
        uint256 price,
        uint32 duration,
        uint64 expiration
    )
        private
    {
        EtherBucket storage etherBucket = etherIndex.buckets[bucketKey];
        etherBucket.ids.push(etherId);

        etherOffers[etherId] = EtherOffer({
            account: msg.sender,
            veriAmount: veriAmount,
            value: msg.value,
            price: price,
            duration: duration,
            expiration: expiration
        });
    }

    function openRentExposure(
        bytes32 veriId,
        bytes32 etherId,
        address veriAccount,
        address etherAccount,
        uint256 veriAmount,
        uint256 value,
        uint256 price,
        uint32 duration,
        uint256 nonce
    )
        private
    {
        require(veToken.approve(veRentExposure, veriAmount));

        bytes32 id = veRentExposure.calculateId({
            veriAmount: veriAmount,
            value: value,
            duration: duration,
            nonce: nonce
        });

        DealMade({
            id: id,
            veriId: veriId,
            etherId: etherId,
            veriAccount: veriAccount,
            etherAccount: etherAccount,
            veriAmount: veriAmount,
            value: value,
            price: price,
            duration: duration
        });

        veRentExposure.open.value(value)({
            veriAccount: veriAccount,
            etherAccount: etherAccount,
            veriAmount: veriAmount,
            price: price,
            duration: duration,
            nonce: nonce
        });
    }

    function removeVeriOffer(VeriBucket storage veriBucket, bytes32 veriId) private {
        uint256 index = getIndex(veriBucket.ids, veriId);
        removeByIndex(veriBucket.ids, index);

        delete veriOffers[veriId];
    }

    function removeEtherOffer(EtherBucket storage etherBucket, bytes32 etherId) private {
        uint256 index = getIndex(etherBucket.ids, etherId);
        removeByIndex(etherBucket.ids, index);

        delete etherOffers[etherId];
    }

    function paybackTokens(address account, uint256 veriAmount) private {
        require(veToken.transfer(account, veriAmount));
    }

    function paybackEther(address account, uint256 value) private {
        account.transfer(value);
    }

    function removeByIndex(bytes32[] storage array, uint256 i) private {
        array[i] = array[array.length - 1];
        array.length--;
    }

    //--- Private constant functions

    function calculateOfferId(
        uint256 veriAmount,
        uint256 value,
        uint256 price,
        uint32 duration,
        uint64 expiration,
        uint256 nonce
    )
        private
        constant
        returns (bytes32)
    {
        return sha256(
            this,
            msg.sender,
            value,
            veriAmount,
            price,
            duration,
            expiration,
            nonce
        );
    }

    function calculateBucketKey(
        uint256 veriAmount,
        uint256 price,
        uint32 duration
    )
        private
        constant
        returns (bytes32)
    {
        return sha256(veriAmount, price, duration);
    }

    function getIndex(bytes32[] storage ids, bytes32 id)
        private
        constant
        returns (uint256)
    {
        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] == id) {
                return i;
            }
        }
        assert(false);
    }

    function isDefaultOrFuture(uint64 time) private constant returns (bool) {
        return time == 0 || time > block.timestamp;
    }
}

contract VeExposure is TokenDestructible {

    //--- Definitions

    using SafeMath for uint256;

    enum State { None, Open, Collected, Closing, Closed }

    struct Exposure {
        address account;
        uint256 veriAmount;
        uint256 initialValue;
        uint256 finalValue;
        uint64 creationTime;
        uint64 closingTime;
        State state;
    }

    //--- Storage

    VeritaseumToken public veToken;
    address public portfolio;

    uint256 public ratio;
    uint32 public minDuration;
    uint32 public maxDuration;
    uint256 public minVeriAmount;
    uint256 public maxVeriAmount;

    mapping (bytes32 => Exposure) exposures;

    //--- Constructor

    function VeExposure(
        VeritaseumToken _veToken,
        uint256 _ratio,
        uint32 _minDuration,
        uint32 _maxDuration,
        uint256 _minVeriAmount,
        uint256 _maxVeriAmount
    ) {
        require(_veToken != address(0));
        require(_minDuration > 0 && _minDuration <= _maxDuration);
        require(_minVeriAmount > 0 && _minVeriAmount <= _maxVeriAmount);

        veToken = _veToken;
        ratio = _ratio;
        minDuration = _minDuration;
        maxDuration = _maxDuration;
        minVeriAmount = _minVeriAmount;
        maxVeriAmount = _maxVeriAmount;
    }

    //--- Modifiers
    modifier onlyPortfolio {
        require(msg.sender == portfolio);
        _;
    }

    //--- Accessors

    function setPortfolio(address _portfolio) public onlyOwner {
        require(_portfolio != address(0));

        portfolio = _portfolio;
    }

    function setMinDuration(uint32 _minDuration) public onlyOwner {
        require(_minDuration > 0 && _minDuration <= maxDuration);

        minDuration = _minDuration;
    }

    function setMaxDuration(uint32 _maxDuration) public onlyOwner {
        require(_maxDuration >= minDuration);

        maxDuration = _maxDuration;
    }

    function setMinVeriAmount(uint32 _minVeriAmount) public onlyOwner {
        require(_minVeriAmount > 0 && _minVeriAmount <= maxVeriAmount);

        minVeriAmount = _minVeriAmount;
    }

    function setMaxVeriAmount(uint32 _maxVeriAmount) public onlyOwner {
        require(_maxVeriAmount >= minVeriAmount);

        maxVeriAmount = _maxVeriAmount;
    }

    //--- Events

    event ExposureOpened(
        bytes32 indexed id,
        address indexed account,
        uint256 veriAmount,
        uint256 value,
        uint64 creationTime,
        uint64 closingTime
    );

    event ExposureCollected(
        bytes32 indexed id,
        address indexed account,
        uint256 value
    );

    event ExposureClosed(
        bytes32 indexed id,
        address indexed account,
        uint256 initialValue,
        uint256 finalValue
    );

    event ExposureSettled(
        bytes32 indexed id,
        address indexed account,
        uint256 value
    );

    //--- Public functions

    function open(uint256 veriAmount, uint32 duration, uint256 nonce) public payable {
        require(veriAmount >= minVeriAmount && veriAmount <= maxVeriAmount);
        require(duration >= minDuration && duration <= maxDuration);
        require(checkRatio(veriAmount, msg.value));

        bytes32 id = calculateId({
            veriAmount: veriAmount,
            value: msg.value,
            duration: duration,
            nonce: nonce
        });
        require(!exists(id));

        openExposure(id, veriAmount, duration);
        forwardTokens(veriAmount);
    }

    function collect(bytes32 id) public onlyPortfolio returns (uint256 value) {
        Exposure storage exposure = exposures[id];
        require(exposure.state == State.Open);

        value = exposure.initialValue;

        exposure.state = State.Collected;
        msg.sender.transfer(value);

        ExposureCollected({
            id: id,
            account: exposure.account,
            value: value
        });
    }

    function close(bytes32 id) public payable onlyPortfolio {
        Exposure storage exposure = exposures[id];
        require(exposure.state == State.Collected);
        require(hasPassed(exposure.closingTime));

        exposure.state = State.Closed;
        exposure.finalValue = msg.value;

        ExposureClosed({
            id: id,
            account: exposure.account,
            initialValue: exposure.initialValue,
            finalValue: exposure.finalValue
        });
    }

    function settle(bytes32 id) public returns (uint256 finalValue) {
        Exposure storage exposure = exposures[id];
        require(msg.sender == exposure.account);
        require(exposure.state == State.Closed);

        finalValue = exposure.finalValue;
        delete exposures[id];

        msg.sender.transfer(finalValue);

        ExposureSettled({
            id: id,
            account: msg.sender,
            value: finalValue
        });
    }

    //--- Public constant functions

    function status(bytes32 id)
        public
        constant
        returns (uint8 state)
    {
        Exposure storage exposure = exposures[id];
        state = uint8(exposure.state);

        if (exposure.state == State.Collected && hasPassed(exposure.closingTime)) {
            state = uint8(State.Closing);
        }
    }

    function exists(bytes32 id) public constant returns (bool) {
        return exposures[id].creationTime > 0;
    }

    function checkRatio(uint256 veriAmount, uint256 value)
        public
        constant
        returns (bool)
    {
        uint256 expectedValue = ratio.mul(veriAmount).div(1 ether);
        return value == expectedValue;
    }

    function calculateId(
        uint256 veriAmount,
        uint256 value,
        uint32 duration,
        uint256 nonce
    )
        public
        constant
        returns (bytes32)
    {
        return sha256(
            this,
            msg.sender,
            value,
            veriAmount,
            duration,
            nonce
        );
    }

    //--- Fallback function

    function() public payable {
        // accept Ether deposits
    }

    //--- Private functions

    function forwardTokens(uint256 veriAmount) private {
        require(veToken.transferFrom(msg.sender, this, veriAmount));
        require(veToken.approve(portfolio, veriAmount));
    }

    function openExposure(bytes32 id, uint256 veriAmount, uint32 duration) private constant {
        uint64 creationTime = uint64(block.timestamp);
        uint64 closingTime = uint64(block.timestamp.add(duration));

        exposures[id] = Exposure({
            account: msg.sender,
            veriAmount: veriAmount,
            initialValue: msg.value,
            finalValue: 0,
            creationTime: creationTime,
            closingTime: closingTime,
            state: State.Open
        });

        ExposureOpened({
            id: id,
            account: msg.sender,
            creationTime: creationTime,
            closingTime: closingTime,
            veriAmount: veriAmount,
            value: msg.value
        });
    }

    //--- Private constant functions

    function hasPassed(uint64 time)
        private
        constant
        returns (bool)
    {
        return block.timestamp >= time;
    }
}
