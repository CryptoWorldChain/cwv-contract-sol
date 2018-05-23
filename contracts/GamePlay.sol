pragma solidity ^0.4.21;

//import "./Random.sol";
import "./strings.sol";
//import "./OraclizeI.sol";
contract GamePlay {
  using strings for *;



//用户投注信息
struct userInfo{
  //uint IndexValue;
  string period;//期号
  string betting;//投注信息
  uint256 winPrice;//中奖金额
  string winLevel;//中奖奖等   多笔用逗号分割
}
//中奖号码
struct WinNumValue{
  string period;//期号
  string winOne;
  string winTwo;
  string winThree;
  /* string winFour;
  string winFive;
  string winSix;
  string winSeven;
  string winEight;
  string winNine;
  string winTen; */
  string[] winArray;
}

//用户投注信息
struct BettingValue{
  string period;//期号
  string bettOne;
  string bettTwo;
  /* string bettThree;
  string bettFour;
  string bettFive;
  string bettSix;
  string bettSeven;
  string bettEight;
  string bettNine;
  string bettTen; */
  string playtype;//投注玩法
  string chipintype;//投注方式
  string multiple;//倍数
  string[] bettingArray;
  string bettBool;//投注号码为空
  string level;//奖等
  string money;//金额
}

//用户投注信息
//mapping(address => userInfo[]) userBettingInfo;
mapping(address => BettingValue[]) userBettingInfo;
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
//开奖号码存储
WinNumValue winNumValue;
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
    winNumValue = WinNumValue(_period,wagerdataArray[0],wagerdataArray[1],
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
  userBettingInfo[msg.sender].push(BettingValue(_period,wagerdataArray[0],wagerdataArray[1],
    wagerdataArray[2],wagerdataArray[4],wagerdataArray[5],tempArray,wagerdataArray[13],"0","0"));
}

//算奖
function computerPrize() public payable{
  //不是创建合约用户，不能算奖
  require(owner==msg.sender);
  require(now >= auctionEnd);
  //require(gameCode);
  //计算
  //循环投注数组，判断是否中奖
  for(uint m=0;m<userBetAddr.length;m++){
      address tempaddr = userBetAddr[m];
      BettingValue[] memory tempUser = userBettingInfo[tempaddr];
      uint256 award = 0;
      for(uint n=0;n<tempUser.length;n++){
          BettingValue memory tempUserInfo = tempUser[n];
          string memory divisionType =  calcPrizeLevelStruct(tempUserInfo);
          string memory prizeLevel = divisionTransfer(divisionType);
          string memory prizeMoney0 = divisionMoney(prizeLevel);
          tempUser[n].level = prizeLevel;
          tempUser[n].money = prizeMoney0;
          award = award + parseInt(prizeMoney0);
      }
      //算奖同时返奖
      if(award == 0){
        tempaddr.transfer(award);
      }
  }
}

function divisionMoney(string infoLevel) internal returns(string){
  string memory prizeMoney;
  //普通投注
  if(stringsEqual("1",infoLevel)){
    prizeMoney = "888888";
  }else if(stringsEqual("2",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("3",infoLevel)){
    prizeMoney = "80000";
  }else if(stringsEqual("4",infoLevel)){
    prizeMoney = "10000";
  }else if(stringsEqual("5",infoLevel)){
    prizeMoney = "5000";
  }else if(stringsEqual("6",infoLevel)){
    prizeMoney = "250";
  }else if(stringsEqual("7",infoLevel)){
    prizeMoney = "50";
  }else if(stringsEqual("8",infoLevel)){
    prizeMoney = "10";
  }else if(stringsEqual("9",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("10",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("11",infoLevel)){
    prizeMoney = "40000";
  }else if(stringsEqual("12",infoLevel)){
    prizeMoney = "2000";
  }else if(stringsEqual("13",infoLevel)){
    prizeMoney = "500";
  }else if(stringsEqual("14",infoLevel)){
    prizeMoney = "100";
  }else if(stringsEqual("15",infoLevel)){
    prizeMoney = "20";
  }else if(stringsEqual("16",infoLevel)){
    prizeMoney = "10";
  }else if(stringsEqual("17",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("18",infoLevel)){
    prizeMoney = "20000";
  }else if(stringsEqual("19",infoLevel)){
    prizeMoney = "4500";
  }else if(stringsEqual("20",infoLevel)){
    prizeMoney = "40";
  }else if(stringsEqual("21",infoLevel)){
    prizeMoney = "25";
  }else if(stringsEqual("22",infoLevel)){
    prizeMoney = "10";
  }else if(stringsEqual("23",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("24",infoLevel)){
    prizeMoney = "10000";
  }else if(stringsEqual("25",infoLevel)){
    prizeMoney = "2000";
  }else if(stringsEqual("26",infoLevel)){
    prizeMoney = "100";
  }else if(stringsEqual("27",infoLevel)){
    prizeMoney = "10";
  }else if(stringsEqual("28",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("29",infoLevel)){
    prizeMoney = "500";
  }else if(stringsEqual("30",infoLevel)){
    prizeMoney = "30";
  }else if(stringsEqual("31",infoLevel)){
    prizeMoney = "8";
  }else if(stringsEqual("32",infoLevel)){
    prizeMoney = "3";
  }else if(stringsEqual("33",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("34",infoLevel)){
    prizeMoney = "350";
  }else if(stringsEqual("35",infoLevel)){
    prizeMoney = "20";
  }else if(stringsEqual("36",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("37",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("38",infoLevel)){
    prizeMoney = "160";
  }else if(stringsEqual("39",infoLevel)){
    prizeMoney = "10";
  }else if(stringsEqual("40",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("41",infoLevel)){
    prizeMoney = "55";
  }else if(stringsEqual("42",infoLevel)){
    prizeMoney = "2";
  }else if(stringsEqual("43",infoLevel)){
    prizeMoney = "10";
  }


  else if(stringsEqual("44",infoLevel)){
    prizeMoney = "5000";
  }else if(stringsEqual("45",infoLevel)){
    prizeMoney = "700";
  }else if(stringsEqual("46",infoLevel)){
    prizeMoney = "90";
  }else if(stringsEqual("47",infoLevel)){
    prizeMoney = "";
  }else if(stringsEqual("48",infoLevel)){
    prizeMoney = "";
  }else if(stringsEqual("49",infoLevel)){
    prizeMoney = "";
  }else if(stringsEqual("50",infoLevel)){
    prizeMoney = "44";
  }else if(stringsEqual("51",infoLevel)){
    prizeMoney = "118";
  }else if(stringsEqual("52",infoLevel)){
    prizeMoney = "205";
  }else if(stringsEqual("53",infoLevel)){
    prizeMoney = "3";
  }else if(stringsEqual("54",infoLevel)){
    prizeMoney = "15";
  }

  else if(stringsEqual("55",infoLevel)){
    prizeMoney = "44";
  }else if(stringsEqual("56",infoLevel)){
    prizeMoney = "12";
  }else if(stringsEqual("57",infoLevel)){
    prizeMoney = "12";
  }else if(stringsEqual("58",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("59",infoLevel)){
    prizeMoney = "5";
  }


  else if(stringsEqual("60",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("61",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("62",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("63",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("64",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("65",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("66",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("67",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("68",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("69",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("70",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("71",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("72",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("73",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("74",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("75",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("76",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("77",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("78",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("79",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("80",infoLevel)){
    prizeMoney = "5";
  }else if(stringsEqual("81",infoLevel)){
    prizeMoney = "5";
  }else{
    prizeMoney = "0";
  }
  return prizeMoney;
}

//获取奖等及奖金
function divisionTransfer(string infoName) internal returns (string){
  string memory prizeLevel;
  //普通投注
  if(stringsEqual("10_10",infoName)){
    prizeLevel = "1";
  }else if(stringsEqual("10_0",infoName)){
    prizeLevel = "2";
  }else if(stringsEqual("9_9",infoName)){
    prizeLevel = "3";
  }else if(stringsEqual("9_8",infoName)){
    prizeLevel = "4";
  }else if(stringsEqual("9_7",infoName)){
    prizeLevel = "5";
  }else if(stringsEqual("9_6",infoName)){
    prizeLevel = "6";
  }else if(stringsEqual("9_5",infoName)){
    prizeLevel = "7";
  }else if(stringsEqual("9_4",infoName)){
    prizeLevel = "8";
  }else if(stringsEqual("9_3",infoName)){
    prizeLevel = "9";
  }else if(stringsEqual("9_2",infoName)){
    prizeLevel = "10";
  }else if(stringsEqual("8_8",infoName)){
    prizeLevel = "11";
  }else if(stringsEqual("8_7",infoName)){
    prizeLevel = "12";
  }else if(stringsEqual("8_6",infoName)){
    prizeLevel = "13";
  }else if(stringsEqual("8_5",infoName)){
    prizeLevel = "14";
  }else if(stringsEqual("8_4",infoName)){
    prizeLevel = "15";
  }else if(stringsEqual("8_3",infoName)){
    prizeLevel = "16";
  }else if(stringsEqual("8_2",infoName)){
    prizeLevel = "17";
  }else if(stringsEqual("7_7",infoName)){
    prizeLevel = "18";
  }else if(stringsEqual("7_6",infoName)){
    prizeLevel = "19";
  }else if(stringsEqual("7_5",infoName)){
    prizeLevel = "20";
  }else if(stringsEqual("7_4",infoName)){
    prizeLevel = "21";
  }else if(stringsEqual("7_3",infoName)){
    prizeLevel = "22";
  }else if(stringsEqual("7_2",infoName)){
    prizeLevel = "23";
  }else if(stringsEqual("6_6",infoName)){
    prizeLevel = "24";
  }else if(stringsEqual("6_5",infoName)){
    prizeLevel = "25";
  }else if(stringsEqual("6_4",infoName)){
    prizeLevel = "26";
  }else if(stringsEqual("6_3",infoName)){
    prizeLevel = "27";
  }else if(stringsEqual("6_2",infoName)){
    prizeLevel = "28";
  }else if(stringsEqual("5_5",infoName)){
    prizeLevel = "29";
  }else if(stringsEqual("5_4",infoName)){
    prizeLevel = "30";
  }else if(stringsEqual("5_3",infoName)){
    prizeLevel = "31";
  }else if(stringsEqual("5_2",infoName)){
    prizeLevel = "32";
  }else if(stringsEqual("5_1",infoName)){
    prizeLevel = "33";
  }else if(stringsEqual("4_4",infoName)){
    prizeLevel = "34";
  }else if(stringsEqual("4_3",infoName)){
    prizeLevel = "35";
  }else if(stringsEqual("4_2",infoName)){
    prizeLevel = "36";
  }else if(stringsEqual("4_1",infoName)){
    prizeLevel = "37";
  }else if(stringsEqual("3_3",infoName)){
    prizeLevel = "38";
  }else if(stringsEqual("3_2",infoName)){
    prizeLevel = "39";
  }else if(stringsEqual("3_1",infoName)){
    prizeLevel = "40";
  }else if(stringsEqual("2_2",infoName)){
    prizeLevel = "41";
  }else if(stringsEqual("2_1",infoName)){
    prizeLevel = "42";
  }else if(stringsEqual("1_1",infoName)){
    prizeLevel = "43";
  }else if(stringsEqual("e_4_4",infoName)){
    prizeLevel = "44";
  }else if(stringsEqual("e_3_3",infoName)){
    prizeLevel = "45";
  }else if(stringsEqual("e_2_2",infoName)){
    prizeLevel = "46";
  }else if(stringsEqual("c_4_4",infoName)){
    prizeLevel = "47";
  }else if(stringsEqual("c_3_3",infoName)){
    prizeLevel = "48";
  }else if(stringsEqual("c_2_2",infoName)){
    prizeLevel = "49";
  }else if(stringsEqual("1_3_2",infoName)){
    prizeLevel = "50";
  }else if(stringsEqual("1_3_3",infoName)){
    prizeLevel = "51";
  }else if(stringsEqual("1_3_4",infoName)){
    prizeLevel = "52";
  }else if(stringsEqual("3_1_1",infoName)){
    prizeLevel = "53";
  }else if(stringsEqual("3_2_2",infoName)){
    prizeLevel = "54";
  }else if(stringsEqual("4_1_0",infoName)){
    prizeLevel = "55";
  }else if(stringsEqual("5_1_0",infoName)){
    prizeLevel = "56";
  }else if(stringsEqual("5_2_0",infoName)){
    prizeLevel = "57";
  }else if(stringsEqual("6_1_0",infoName)){
    prizeLevel = "58";
  }else if(stringsEqual("6_2_0",infoName)){
    prizeLevel = "59";
  }else if(stringsEqual("7_1_6",infoName)){
    prizeLevel = "60";
  }else if(stringsEqual("7_1_7",infoName)){
    prizeLevel = "61";
  }else if(stringsEqual("7_1_8",infoName)){
    prizeLevel = "62";
  }else if(stringsEqual("7_1_9",infoName)){
    prizeLevel = "63";
  }else if(stringsEqual("7_1_10",infoName)){
    prizeLevel = "64";
  }else if(stringsEqual("7_1_11",infoName)){
    prizeLevel = "65";
  }else if(stringsEqual("7_1_12",infoName)){
    prizeLevel = "66";
  }else if(stringsEqual("7_1_13",infoName)){
    prizeLevel = "67";
  }else if(stringsEqual("7_1_14",infoName)){
    prizeLevel = "68";
  }else if(stringsEqual("7_1_15",infoName)){
    prizeLevel = "69";
  }else if(stringsEqual("7_1_16",infoName)){
    prizeLevel = "70";
  }else if(stringsEqual("7_1_17",infoName)){
    prizeLevel = "71";
  }else if(stringsEqual("7_1_18",infoName)){
    prizeLevel = "72";
  }else if(stringsEqual("7_1_19",infoName)){
    prizeLevel = "73";
  }else if(stringsEqual("7_1_20",infoName)){
    prizeLevel = "74";
  }else if(stringsEqual("7_1_21",infoName)){
    prizeLevel = "75";
  }else if(stringsEqual("7_1_22",infoName)){
    prizeLevel = "76";
  }else if(stringsEqual("7_1_23",infoName)){
    prizeLevel = "77";
  }else if(stringsEqual("7_1_24",infoName)){
    prizeLevel = "78";
  }else if(stringsEqual("7_1_25",infoName)){
    prizeLevel = "79";
  }else if(stringsEqual("7_1_26",infoName)){
    prizeLevel = "80";
  }else if(stringsEqual("7_1_27",infoName)){
    prizeLevel = "81";
  }
  return prizeLevel;
}


/*
计算奖等并返奖
*/

function calcPrizeLevelStruct (BettingValue bettingValue) internal returns(string){

  // 根据中奖号码算奖 01|02|03|
  //string memory winnumber = winCode;
  //玩法
  string memory bettypeArr = bettingValue.playtype;
      //投注方式
  string memory chipintypeArr = bettingValue.chipintype;
      //投注号码(多个以,分隔)
  //string memory wagerDataArr = wagerdata;
      //投注号码个数(多个以,分隔)
  string memory spotsArr = "";

  string memory divisionName0;

  //倍数在
  string memory betmultirArr = bettingValue.multiple;
  //4拖拉机投注 1  01|02|03*1
  //5猜奇偶  全奇1 01|02|03*1  全偶2 01|02|03*1
  //6猜大小  猜大1 01|02|03*1  猜小2  01|02|03*1
  if (stringsEqual("4",bettypeArr) || stringsEqual("5",bettypeArr)|| stringsEqual("6",bettypeArr)) {
    //divisionName0 = getDivisionName("", winnumber, bettypeArr, chipintypeArr);
    divisionName0 = getDivisionName(bettingValue);
  } else {
    //2普通投注  2 08|03|02|10|06|04|09|07|05|01*5
    //1精确投注  1精确投注 03|02*1   2复选 03|02*1   3组选 03|02*1
    //3位置投注  1位置一 03*1 2位置二 03|04*1
    //7和数     1 和数1 6*1
    divisionName0 = getDivisionName(bettingValue);
  }

  if(stringsEqual(divisionName0,"") && stringsEqual(bettingValue.bettBool,"1")){

    // 获取奖等级别
    if(!stringsEqual("3",chipintypeArr) && (stringsEqual("1",bettypeArr) || stringsEqual("2",bettypeArr))){
      uint wonCount1 = wonCount(bettingValue);// 计算中奖号码个数
      divisionName0 = strConcat(spotsArr,"_",string(toBytes(wonCount1)),"","");
    }

    // 精选
    if (stringsEqual("1",bettypeArr)&&stringsEqual("1",chipintypeArr)) {
      divisionName0 = strConcat("e_",divisionName0,"","","");
    }

    // 复选
    if (stringsEqual("1",bettypeArr)&&stringsEqual("2",chipintypeArr)) {
      divisionName0 = strConcat("c_",divisionName0,"","","");
    }
  }
  return divisionName0;
}


/*
计算中奖号码个数
*/
function wonCount(BettingValue bettingValue) internal returns (uint){

		uint wonCount0 = 0;
    if (stringsEqual("2",bettingValue.playtype) || (stringsEqual("1",bettingValue.playtype)&&stringsEqual("1",bettingValue.chipintype))) {
			wonCount0 = wonCount2Or1And1(bettingValue);
		} else {
			wonCount0 = wonCountZero(bettingValue);
		}
		return wonCount0;
}
function wonCount2Or1And1(BettingValue bettingValue) internal returns (uint){

  string[] memory wagerdataArray = bettingValue.bettingArray;

  string[] memory winnerNumberArray = winNumValue.winArray;

  uint wonCount0 = 0;
  for (uint i = 0; i < 10; i++) {
    if (parseInt(wagerdataArray[i]) == parseInt(winnerNumberArray[i])) {
      wonCount0++;
    }
  }
  return wonCount0;
}

function wonCountZero(BettingValue bettingValue) internal returns (uint){
  string[] memory wagerdataArray = bettingValue.bettingArray;

  string[] memory winnerNumberArray = winNumValue.winArray;

  uint wonCount0 = 0;
  for(uint k=0; k<wagerdataArray.length; k++){
    for(uint j=0; j<wagerdataArray.length; j++){
      if(parseInt(wagerdataArray[k])==parseInt(winnerNumberArray[j])){
        wonCount0++;
      }
    }
  }
  return wonCount0;
}
/*
计算是否中奖
wagerdata		投注号码
winnerNumber	中奖号码
playtype		玩法
chipintype		类型
*/
function getDivisionName(BettingValue bettingValue) internal returns (string){
  string memory divisionName;
  //精确投注   组选
  if(stringsEqual("1",bettingValue.playtype)&&stringsEqual("3",bettingValue.playtype)){
    divisionName = computer1(bettingValue);
  }else if(stringsEqual("3",bettingValue.playtype)){
    //位置投注
    divisionName = computer3(bettingValue);
  }else if(stringsEqual("4",bettingValue.playtype)&&stringsEqual("1",bettingValue.chipintype)){
    //拖拉机投注
    divisionName = computer4And1(bettingValue);
  }else if(stringsEqual("5",bettingValue.playtype)){
    //猜奇偶
    divisionName = computer5(bettingValue);
  }else if(stringsEqual("6",bettingValue.playtype)){
    //猜大小
    divisionName = computer6(bettingValue);
  }else if(stringsEqual("7",bettingValue.playtype)&&stringsEqual("1",bettingValue.chipintype)){
    //和数
    divisionName = computer7And1(bettingValue);
  }
  return divisionName;

}

//精确投注   组选
function computer1(BettingValue bettingValue)internal returns (string){
    //string memory divisionName1;
    //var delim1 = ",".toSlice();
    string[] memory wagerdataArray = bettingValue.bettingArray;

    string[] memory winnerNumberArray = winNumValue.winArray;

    uint kk = 0;
    string memory winNum0;
    for(kk=0;kk<wagerdataArray.length;kk++){
      winNum0 = strConcat(winNum0,"#",winnerNumberArray[kk],"#","");
    }
    bool isWin = true;
    //uint wagerdatalength = wagerdataArray.length;
    for( kk=0;kk<wagerdataArray.length;kk++){
      string memory wagerNum0;
      if (wagerdataArray[kk].toSlice().len() == 1) {
        wagerNum0 = strConcat(wagerNum0,"#0",wagerdataArray[kk],"#","");
      } else {
        wagerNum0 = strConcat(wagerNum0,"#",wagerdataArray[kk],"#","");
      }
      var wagerNum0Str = wagerNum0.toSlice();
      var winNum0Str = winNum0.toSlice();
      var tempStr = winNum0Str.until(winNum0Str.copy().find(wagerNum0Str).beyond(wagerNum0Str));
      if(stringsEqual("",tempStr.toString())){
        isWin = false;
        break;
      }
    }
    if (isWin) {
      //// playtype_chipintype_中奖号码个数
      divisionNameInfo = strConcat(bettingValue.playtype,"_",bettingValue.chipintype,"_",string(toBytes(wagerdataArray.length)));
    }else{
      divisionNameInfo = "";
    }
    return divisionNameInfo;
}
function computer3(BettingValue bettingValue)internal returns (string){
    string memory divisionName3;
    //var delim1 = ",".toSlice();
    string[] memory wagerdataArray = bettingValue.bettingArray;
    string[] memory winnerNumberArray = winNumValue.winArray;
    //uint wagerdatalength = wagerdataArray.length;
    string memory winNum0;
    uint ll = 0;
    for(ll=0;ll<wagerdataArray.length;ll++){
      winNum0 = strConcat(winNum0,"#",winnerNumberArray[ll],"#","");
    }

    string memory winNum1 = strConcat("#",winnerNumberArray[0],"#",winnerNumberArray[1],"#");
    // 一至三号位置的开将号码
    winNum1 = strConcat(winNum1,winnerNumberArray[2],"#","","");
		//uint wagerdatalength1 = wagerdataArray.length;// 投注号码个数 1-2个投注号码
		bool isWin1 = true;
		for (ll = 0; ll < wagerdataArray.length; ll++) {
			string memory wagerNum1;
			if (wagerdataArray[ll].toSlice().len() == 1) {
				wagerNum1 = strConcat(wagerNum1,"#0", wagerdataArray[ll] , "#","");
			} else {
				wagerNum1 = strConcat(wagerNum1,"#" , wagerdataArray[ll] , "#","");
			}
      var wagerNum1Str = wagerNum1.toSlice();
      var winNum1Str = winNum1.toSlice();
      var tempStr1 = winNum1Str.until(winNum1Str.copy().find(wagerNum1Str).beyond(wagerNum1Str));
      if(stringsEqual("",tempStr1.toString())){
				isWin1 = false;
				break;
			}
		}
		if (isWin1) {
			//playtype_chipintype_中奖号码个数
			divisionName3 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_" , string(toBytes(wagerdataArray.length)));
		}
    return divisionName3;
  }
function computer4And1(BettingValue bettingValue)  internal returns (string){
  string memory divisionName4;
  string[] memory wagerdataArray = bettingValue.bettingArray;

  uint n1 = parseInt(winNumValue.winOne);
  uint n2 = parseInt(winNumValue.winTwo);
  uint n3 = parseInt(winNumValue.winThree);
  if ((n1 + 1 == n2 && n2 + 1 == n3) || (n1 - 1 == n2 && n2 - 1 == n3)) {
    // 拖拉机,wagerdata固定位：1,2,3
    divisionName4 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
  }
  return divisionName4;
}
function computer5(BettingValue bettingValue)  internal returns (string){
  string memory divisionName5;

  string[] memory wagerdataArray = bettingValue.bettingArray;

  uint n11 = parseInt(winNumValue.winOne);
  uint n21 = parseInt(winNumValue.winTwo);
  uint n31 = parseInt(winNumValue.winThree);
  if (stringsEqual("1",bettingValue.chipintype) && n11 % 2 != 0 && n21 % 2 != 0 && n31 % 2 != 0) {
    // 全奇(1),wagerdata固定位：1,2,3
    divisionName5 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
  } else if (stringsEqual("2",bettingValue.chipintype) && n11 % 2 == 0 && n21 % 2 == 0 && n31 % 2 == 0) {
    // 是全偶(2),wagerdata固定位：1,2,3
    divisionName5 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
  }
  return divisionName5;
}
function computer6(BettingValue bettingValue)  internal returns (string){
  string memory divisionName6;

  string[] memory wagerdataArray = bettingValue.bettingArray;

  uint n12 = parseInt(winNumValue.winOne);
  uint n22 = parseInt(winNumValue.winTwo);
  uint n32 = parseInt(winNumValue.winThree);
  uint n = n12 + n22 + n32;
  if (stringsEqual("1",bettingValue.chipintype) && 21 <= n && n <= 27) {
    // 猜大(1),wagerdata固定位：1,2,3
    divisionName6 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
  } else if (stringsEqual("2",bettingValue.chipintype) && 6 <= n && n <= 12) {
    // 猜小(2),wagerdata固定位：1,2,3
    divisionName6 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
  }
  return divisionName6;
}

function computer7And1(BettingValue bettingValue)  internal returns (string){
  string memory divisionName7and1;
  string[] memory wagerdataArray1 = bettingValue.bettingArray;

  uint n13 = parseInt(winNumValue.winOne);
  uint n23 = parseInt(winNumValue.winTwo);
  uint n33 = parseInt(winNumValue.winThree);
  uint n9 = n13 + n23 + n33;


  /*var delim2 = ",".toSlice();
  var wagerdataStr22 = wagerdata.toSlice();
  var wagerdataArray1 = new string[](wagerdataStr22.count(delim2) + 1);*/
  string memory wagerNum3;
  for(uint jj=0;jj<wagerdataArray1.length;jj++){
    wagerNum3 = strConcat(wagerNum3,wagerdataArray1[jj],"","","");
  }
  uint wagerNum2 = parseInt(wagerNum3);
  if (wagerNum2 == n9) {
    // 和数
    divisionName7and1 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_" , string(toBytes(wagerNum2)));
  }
  return divisionName7and1;
}


//字符串转整数
function parseInt(string _a) internal returns (uint) {
    return parseInt(_a, 0);
}

//字符串转整数
function parseInt(string _a, uint _b) internal returns (uint) {
    bytes memory bresult = bytes(_a);
    uint mint = 0;
    bool decimals = false;
    for (uint i=0; i<bresult.length; i++){
        if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
            if (decimals){
               if (_b == 0) break;
                else _b--;
            }
            mint *= 10;
            mint += uint(bresult[i]) - 48;
        } else if (bresult[i] == 46) decimals = true;
    }
    if (_b > 0) mint *= 10**_b;
    return mint;
}
//字符串相等
function stringsEqual(string memory _a, string memory _b) internal returns (bool) {
		bytes memory a = bytes(_a);
		bytes memory b = bytes(_b);
		if (a.length != b.length)
			return false;
		// @todo unroll this loop
		for (uint i = 0; i < a.length; i ++)
			if (a[i] != b[i])
				return false;
		return true;
	}
  //字符串连接
  function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    bytes memory _be = bytes(_e);
    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
    for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
    return string(babcde);
  }

  //数字转bytes
  function toBytes(uint256 x)internal returns (bytes) {
    bytes memory b = new bytes(32);
    assembly { mstore(add(b, 32), x) }
  }
}
