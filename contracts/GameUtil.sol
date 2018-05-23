pragma solidity ^0.4.21;

library IterableMapping
{
  struct itmap
  {
    mapping(uint => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex;string value; }
  struct KeyFlag { uint key; bool deleted; }
  function insert(itmap storage self, uint key, string value) public returns (bool replaced)
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
  function remove(itmap storage self, uint key)public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
  }
  function contains(itmap storage self, uint key)public returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self)public returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex)public returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex)public returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex)public returns (uint key, string value)
  {
    key = self.keys[keyIndex].key;
    value = self.data[key].value;
  }
}

library IterableAddrMapping
{
  struct itmap
  {
    mapping(uint => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex; address value; }
  struct KeyFlag { uint key; bool deleted; }
  function insert(itmap storage self, uint key, address value) public returns (bool replaced)
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
  function remove(itmap storage self, uint key)public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
  }
  function contains(itmap storage self, uint key)public returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self)public returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex)public returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex)public returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex)public returns (uint key, address value)
  {
    key = self.keys[keyIndex].key;
    value = self.data[key].value;
  }
}
contract GameUtil{
    //using computerPrize for *;
    address onwer;
    //当前奖池
    uint256 prizePool;
    //是否从官方获取开奖号码 false不从官方获取；true从官方获取
    bool isOfficial = false;
    //存储用户地址
    IterableAddrMapping.itmap data;
    //用户选择号码
    mapping(address => IterableMapping.itmap) UserNumber;
    //账户返奖
    mapping(address => IterableMapping.itmap) FundsPrice;
    //开奖号码码
    string winningNumber;


    //算奖
    function computerPrizeInfo() public{

        if(!isOfficial){
            winningNumber = getRandomNumber();
        }

        //
    }
    //设置奖池信息  _poolFunds 表示奖池资金
    function setPoolInfo(uint256 _poolFunds) public {
      onwer = msg.sender;
      prizePool = _poolFunds;
      //扣除奖池资金
      msg.sender.transfer(-prizePool);
    }

    //用户选择游戏号码
    function userSelectNumber(address _userAdd,string _lotteryNumber) public{

        UserNumber[_userAdd] = _lotteryNumber;
    }

    //设置从官方获取开奖号码
    function setOfficialNumber(string _winningNumber) public {
        winningNumber = _winningNumber;
    }

    //是否从官方获取开奖号码
    function setIsOfficial(bool _isOfficial) public {
        isOfficial = _isOfficial;
    }
    //从随机合约中获取中奖号码
    function getRandomNumber()public returns (string){
        log0('');
    }


}
