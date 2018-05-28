pragma solidity ^0.4.21;

//import "./Random.sol";
import "./strings.sol";
import "./pk10Game.sol";
//import "./OraclizeI.sol";
contract GamePlay {
  using strings for *;
  using pk10Game for *;



//用户投注信息
/*struct userInfo{
  //uint IndexValue;
  string period;//期号
  string betting;//投注信息
  uint256 winPrice;//中奖金额
  string winLevel;//中奖奖等   多笔用逗号分割
}*/


//用户投注信息
//mapping(address => userInfo[]) userBettingInfo;
mapping(address => pk10Game.BettingValue[]) userBettingInfo;
mapping(address => uint)  checkUser;
//用户投注地址集合
address[] userBetAddr = new address[](1);
//奖池
address pooladdr;
//销售金额
address saleaddr;
//开启地址
address owner;
//佣金地址
address commission;
//期号
string period;
//当前期号
string currentPeriod;
//开奖号码
string winCode;

string divisionNameInfo;
//开始时间
uint actionStart;
//结束时间
uint auctionEnd;
//是否算奖
bool isComputerPrize = false;
//开奖号码存储
pk10Game.WinNumValue winNumValue;
//设置合约创建者
function GamePlay() public{
  owner = msg.sender;
}


//设置地址信息
/*
_pooladdr 奖池地址，存储初始值，及追加奖池金额
_saleaddr 销售金额存储地址
_commission 佣金提取地址  暂定义成传入方式
_currentPeriod 当前期号
*/
function setInfo(address _pooladdr,address _saleaddr,
  address _commission,string _currentPeriod) public payable{
    //不是创建合约用户，不能设置地址信息
    require(owner==msg.sender);
    pooladdr = _pooladdr;
    saleaddr = _saleaddr;
    commission = _commission;
    currentPeriod = _currentPeriod;
    auctionEnd = now + 60*5*1000;//pk10游戏间隔5分钟  设置成默认5分钟
}

//奖池增加金额
function addPool(uint256 _poolAmount) public payable{
  //不是创建合约用户，不能设置奖池资金
  require(owner==msg.sender);
  pooladdr.transfer(_poolAmount);
}

//设置开奖号码和开奖期号
function setGamePeriod(string _winCode,string _period) public{
    //不是创建合约用户，不能设置开奖号码和开奖期号
    require(owner==msg.sender);

    period = _period;
    winCode = _winCode;
    var delim0 = "|".toSlice();
    var wagerdataArraystr = _winCode.toSlice();
    var wagerdataArray = new string[](wagerdataArraystr.count(delim0) + 1);
    for(uint aa=0;aa<wagerdataArray.length;aa++){
      wagerdataArray[aa] = wagerdataArraystr.split(delim0).toString();
    }
    winNumValue = pk10Game.WinNumValue(_period,wagerdataArray[0],wagerdataArray[1],
      wagerdataArray[2],wagerdataArray);
}

/*投注信息
_strBet   投注号码格式：“玩法:投注方式:投注号码1*倍数,投注号码2*倍数”
"1,1:1,1:08|03|02|10|06|04|09|07|05|01*5,01|02|03|06|04|10|08|07|09|05*10"
投注号码格式：“玩法|投注方式|倍数|投注号码(10个)|1表示有投注信息，0表示没有”
"1|1|10|01|02|03|06|04|10|08|07|09|05|1"
"4|1|10|00|00|00|00|00|00|00|00|00|00|0"

*/
function userBetting(string _strBet,string _period) public payable{
  require(now < auctionEnd);
  //检查用户是否存在，如不存在，则加入用户地址数组；10表示已经投注过
  if(checkUser[msg.sender]==0){
    checkUser[msg.sender] = 10;
    userBetAddr.push(msg.sender);
  }
  //销售金额累加
  saleaddr.transfer(msg.value);
  //减去投注的金额
  msg.sender.transfer(-msg.value);
  //加入投注信息
  var delim0 = "|".toSlice();
  var wagerdataArraystr = _strBet.toSlice();
  var wagerdataArray = new string[](wagerdataArraystr.count(delim0) + 1);
  for(uint aa=0;aa<wagerdataArray.length;aa++){
    wagerdataArray[aa] = wagerdataArraystr.split(delim0).toString();
  }
  string[] memory tempArray = new string[](10);
  tempArray[0] = wagerdataArray[3];
  tempArray[1] = wagerdataArray[4];
  tempArray[2] = wagerdataArray[5];
  tempArray[3] = wagerdataArray[6];
  tempArray[4] = wagerdataArray[7];
  tempArray[5] = wagerdataArray[8];
  tempArray[6] = wagerdataArray[9];
  tempArray[7] = wagerdataArray[10];
  tempArray[8] = wagerdataArray[11];
  tempArray[9] = wagerdataArray[12];
  //userBettingInfo[msg.sender].push(userInfo(_period,_strBet,0,""));
  userBettingInfo[msg.sender].push(pk10Game.BettingValue(_period,wagerdataArray[0],wagerdataArray[1],
    wagerdataArray[2],wagerdataArray[4],wagerdataArray[5],tempArray,wagerdataArray[13],"0","0"));
}

//算奖
function computerPrize() public payable{

  //false表示没有算过奖
  require(isComputerPrize==false);
  //不是创建合约用户，不能算奖
  require(owner==msg.sender);
  require(now >= auctionEnd);

  //require(gameCode);
  //计算
  //循环投注数组，判断是否中奖
  for(uint m=0;m<userBetAddr.length;m++){
      address tempaddr = userBetAddr[m];
      pk10Game.BettingValue[] memory tempUser = userBettingInfo[tempaddr];
      uint256 award = 0;
      for(uint n=0;n<tempUser.length;n++){
          pk10Game.BettingValue memory tempUserInfo = tempUser[n];
          string memory divisionType = pk10Game.calcPrizeLevelStruct(tempUserInfo,winNumValue);
          string memory prizeLevel = pk10Game.divisionTransfer(divisionType);
          string memory prizeMoney0 = pk10Game.divisionMoney(prizeLevel);

          tempUser[n].level = prizeLevel;
          tempUser[n].money = prizeMoney0;
          uint multiple = pk10Game.parseInt(tempUserInfo.multiple);
          award = award + pk10Game.parseInt(prizeMoney0)*multiple;
      }
      //算奖同时返奖
      if(award == 0){
        tempaddr.transfer(award);
      }
  }

  //算过奖后值为true
  isComputerPrize = true;
}

}
