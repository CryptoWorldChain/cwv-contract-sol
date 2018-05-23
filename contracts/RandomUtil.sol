pragma solidity ^0.4.21;



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

contract RandomUtil {

    struct RandomUser{
        address onwerUser;
        bool isWithdrawal;
        string result;
        uint  withdrawalfzund;
    }

    uint userNum;
    uint seedNum;
    uint numsign = 0;
    uint rand_seed = 10;


    uint[] mathNum = new uint[](100);


    IterableMapping.itmap data;
    mapping(address => RandomUser)  randomUser;
    mapping(address => bool) Withdrawalfzund;



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
        for(uint i=10;i<=20;i++){
            mathNum[i] = i;
        }
    }

    //接收指纹
    function setResult (address _newAddr,string _result) public checkIsExits(_newAddr){

        IterableMapping.insert(data,numsign,_newAddr);
        numsign += 1;
        //3.1709792
        randomUser[_newAddr] = RandomUser(_newAddr,false,_result,3);
        Withdrawalfzund[_newAddr] = true;
    }

   function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory abcde = new string(_ba.length + _bb.length );
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        return string(babcde);
    }

    //获取随机数
    function getRandmon() public returns (uint){
        //uint len = randomNum.length-1;
        uint numRand = randomNum[0];
        delete(randomNum[0]);
        randomNum.length--;
        return numRand;
    }
    /*modifier checkUserNum(){
        require(data.size == userNum);
        _;
    }*/

    //生成随机
    function combination() public {
        uint signNum = 0;
        string memory fingerprint;

        for (var i = IterableMapping.iterate_start(data);
        IterableMapping.iterate_valid(data, i); i = IterableMapping.iterate_next(data, i))
    {
        var (key, value) = IterableMapping.iterate_get(data, i);
        fingerprint = strConcat(fingerprint,randomUser[value].result);

        withdrawalfzunds(value,randomUser[value].withdrawalfzund);

        signNum++;
        if(signNum==20){
            break;
        }
    }

        rand_seed = autoRandom(fingerprint);
        for(uint k=0;k<seedNum;k++){
            randomNum[k] = autoRandomSeed();
        }

        //delete address
        for(uint j=1;j<=signNum;j++){
            IterableMapping.remove(data,IterableMapping.iterate_start(data));
        }



    }

    function autoRandom(string _fingerprint) public payable returns (uint){
        uint randomNumber = uint(sha256(_fingerprint));
        emit newRandomNumber_uint(randomNumber);
        return randomNumber;
    }

    function autoRandomSeed() public payable returns(uint){
        rand_seed = rand_seed * 1103515245 + 12345;
        uint maxRange = 2**(8*7);
        uint randomNumber = rand_seed % maxRange;
        return randomNumber;
    }

    //激励
    function withdrawalfzunds(address _addr,uint _price) public {
        delete randomUser[_addr];
        _addr.transfer(_price);
    }
}
