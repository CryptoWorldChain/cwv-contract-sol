pragma solidity ^0.4.22;

contract RandomApple{

uint256 seedNum = 1000;
uint256 rand_seed = 249075560159305;

uint256[] randomNum = new uint256[](1);
address owner;
address[] userAddrArray = new address[](1);


struct RandomUser{
    //address userAddr;
    string fingerprint;
    uint256 minergold;
    bool isUse;
}

mapping(address => RandomUser) randomInfo;
event newRandomNumber_uint(uint);
constructor() public{
  owner = msg.sender;
}


function fingerprintInfo(string result) public {
  require(!userAddrArray[msg.sender]);
  userAddrArray.push(msg.sender);
  randomInfo[msg.sender] = RandomUser(result,0,false);
}

function computerRandomNumber(){
  require(owner == msg.sender);
  string userfingerprint;
  for(uint i=0;i<100;i++){
    address tempUserAddr = userAddrArray[i];
    RandomUser tempUser = randomInfo[tempUserAddr];

    userfingerprint = tempUser.fingerprint;
    rand_seed = autoRandom(userfingerprint);

    for(uint k=0;k<seedNum;k++){
        randomNum[k] = autoRandomSeed();
    }

  }


}
function getFixedRange(uint256 startNum,uint256 endNum) public returns (uint256){
  uint numRand = randomNum[0];
  delete(randomNum[0]);
  randomNum.length--;

  return numRand;
}

function nextInt(uint256 n) internal pure returns(uint256){

    require(n>0,"1");

    if ((n & -n) == n)  // i.e., n is a power of 2
        return (uint256)((n * (uint256)next(31)) >> 31);

    int bits, val;
    do {
        bits = next(31);
        val = bits % n;
    } while (bits - val + (n-1) < 0);
    return val;
}
uint256 multiplier = 25214903917;
uint256 addend = 11;
uint256 mask = 281474976710655;
function next(int bits) internal pure returns (uint256) {
    uint256 oldseed, nextseed;
    
    oldseed = rand_seed;
    nextseed = (oldseed * multiplier + addend) & mask;
    return (int)(nextseed >>> (48 - bits));
}
function getRandmon() public returns (uint256){
  uint numRand = randomNum[0];
  delete(randomNum[0]);
  randomNum.length--;
  return numRand;
}
function initSeed(uint256 seed) internal pure returns (uint256){
  return (seed ^  multiplier) & mask;
}


function autoRandom(string _fingerprint) internal pure returns (uint){
    uint256 randomNumber = uint256(sha256(_fingerprint));
    emit newRandomNumber_uint(randomNumber);
    return randomNumber;
}

function autoRandomSeed() internal pure returns(uint){
    rand_seed = rand_seed * 1103515245 + 12345;
    uint256 maxRange = 2**(8*7);
    uint256 randomNumber = rand_seed % maxRange;
    return randomNumber;
}

function withdrawalfzunds(address _addr,uint _price) public {
    delete randomUser[_addr];
    _addr.transfer(_price);
}

//字符串连接
function strConcat(string _a, string _b) internal pure returns (string){
  bytes memory _ba = bytes(_a);
  bytes memory _bb = bytes(_b);

  string memory abcde = new string(_ba.length + _bb.length);
  bytes memory babcde = bytes(abcde);
  uint k = 0;
  for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
  for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];

  return string(babcde);
}



}
