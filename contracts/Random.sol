pragma solidity ^0.4.21;


import "./strings.sol";

library IterableMapping
{
  struct itmap
  {
    mapping(uint => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex; address value; }
  struct KeyFlag { uint key; bool deleted; }
  function insert(itmap storage self, uint key, address value) returns (bool replaced)
  {
    uint keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  function remove(itmap storage self, uint key) returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
  }
  function contains(itmap storage self, uint key) returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self) returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex) returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex) returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex) returns (uint key, address value)
  {
    key = self.keys[keyIndex].key;
    value = self.data[key].value;
  }
}

contract RandomUtil {
    
    using strings for *;
    
    string result;
    address onwer;
    uint userNum;
    uint seedNum;
    uint numsign = 0;
   
    IterableMapping.itmap data;

    
    struct RandomUser{
        address onwerUser;
        bool isWithdrawal;
        string result;
        string[] split;
        uint  Withdrawalfzund;
    }
    mapping(address => RandomUser)  randomUser;
    mapping(address => bool) Withdrawalfzund;
    //mapping(address => string) CollectInfo;
    
    //随机数
    uint[] randomNum;// = new uint[](10000);
    
    event newRandomNumber_uint(uint);
    //检查用户是否存在 
    modifier checkIsExits(address _newAddr) {
        require(!Withdrawalfzund[_newAddr]);
        _;
    }
    
    function RandomUtil(uint _userNum,uint _seedNum) public{
        userNum = _userNum;
        seedNum = _seedNum;
        randomNum = new uint[](seedNum);
        onwer = msg.sender;
    }
    
    //接收指纹
    function setResult (address _newAddr,string _result) public checkIsExits(_newAddr){
        result = _result;
        strings.slice memory test = result.toSlice();
        strings.slice memory strFix = ';'.toSlice();
        var strResult = new string[](test.count(strFix)+1);
        for(uint i = 0; i < strResult.length; i++) {
            strResult[i] = test.split(strFix).toString();
        }
        IterableMapping.insert(data,numsign,_newAddr);
        numsign += 1;
        randomUser[_newAddr] = RandomUser(_newAddr,false,_result,strResult,0);
        Withdrawalfzund[_newAddr] = false;
    }
    
   
    //获取随机数
    function getRandmon() public returns (uint){
        //uint len = randomNum.length-1;
        uint numRand = randomNum[0];
        delete(randomNum[0]);
        randomNum.length--;
        return numRand;
    }
    modifier checkUserNum(){
        require(data.size<userNum);
        _;
    }
    //生成随机种子
    function combination() public checkUserNum{
        log0('');
    }
    //生成随机数
    function autoRandom(string _fingerprint) public payable returns (uint){
        uint maxRange = 2**(8* 7);
        uint randomNumber = uint(sha256(_fingerprint)) % maxRange;
        emit newRandomNumber_uint(randomNumber);
        return randomNumber;
    }
    
    //激励
    function withdrawalfzunds(address _addr,uint _price) public {
        delete randomUser[_addr];
        _addr.transfer(_price);
        onwer.transfer(-_price);
    }
}