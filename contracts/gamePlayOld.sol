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
struct winNumValue{
  string period;//期号
  string winOne;
  string winTwo;
  string winThree;
  string winFour;
  string winFive;
  string winSix;
  string winSeven;
  string winEight;
  string winNine;
  string winTen;
}

//用户投注信息
struct bettingValue{
  string period;//期号
  string bettOne;
  string bettTwo;
  string bettThree;
  string bettFour;
  string bettFive;
  string bettSix;
  string bettSeven;
  string bettEight;
  string bettNine;
  string bettTen;
  string playtype;//投注玩法
  string chipintype;//投注方式
  string multiple;//倍数
}

//用户投注信息
//mapping(address => userInfo[]) userBettingInfo;
mapping(address => bettingValue[]) userBettingInfo;
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

//结束时间
uint public auctionEnd;
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

}

/*投注信息
_strBet   投注号码格式：“玩法:投注方式:投注号码1*倍数,投注号码2*倍数”
"1,1:1,1:08|03|02|10|06|04|09|07|05|01*5,01|02|03|06|04|10|08|07|09|05*10"
投注号码格式：“玩法:投注方式:倍数:投注号码”
"1:1:10:01:02:03:06:04:10:08:07:09:05"
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
  var delim0 = ":".toSlice();
  var wagerdataArraystr = _strBet.toSlice();
  var wagerdataArray = new string[](wagerdataArraystr.count(delim0) + 1);
  for(uint aa=0;aa<wagerdataArray.length;aa++){
    wagerdataArray[aa] = wagerdataArraystr.split(delim0).toString();
  }
  //userBettingInfo[msg.sender].push(userInfo(_period,_strBet,0,""));
  userBettingInfo[msg.sender].push(bettingValue(_period,wagerdataArray[0],wagerdataArray[1],
    wagerdataArray[2],wagerdataArray[3],wagerdataArray[4],wagerdataArray[5],wagerdataArray[6],
    wagerdataArray[7],wagerdataArray[8],wagerdataArray[9],wagerdataArray[10],wagerdataArray[11],
    wagerdataArray[12]));
}

//算奖
function computerPrize() public payable{
  //不是创建合约用户，不能算奖
  require(owner==msg.sender);
  require(now >= auctionEnd);
  //require(gameCode);
  //计算
  var delimComma = ",".toSlice();
  var delimLine = "|".toSlice();
  var delimSign = "*".toSlice();
  var delimColon = ":".toSlice();
  //循环投注数组，判断是否中奖
  for(uint m=0;m<userBetAddr.length;m++){
      address tempaddr = userBetAddr[m];
      bettingValue[] memory tempUser = userBettingInfo[tempaddr];
      for(uint n=0;n<tempUser.length;n++){
          bettingValue memory tempUserInfo = tempUser[n];
          string memory bettingstr = tempUserInfo.betting;

          var bettingArraystr = bettingstr.toSlice();
          var bettingInfoArray = new string[](bettingArraystr.count(delimColon) + 1);
          for(uint mm=0;mm<bettingInfoArray.length;mm++){
            bettingInfoArray[mm] = bettingArraystr.split(delimColon).toString();
          }
          var bettype = bettingInfoArray[0];
          var chipintype = bettingInfoArray[1];
          var wagerdata = bettingInfoArray[2];
          calcPrizeLevel(bettype,chipintype,wagerdata);
      }
  }
}


  //var delim = ",".toSlice();
/*
计算奖等并返奖
*/
function calcPrizeLevel (string bettype,string chipintype,string wagerdata) internal {

  // 用户的投注信息
  		// 根据中奖号码算奖 01|02|03|
      string memory winnumber = winCode;
  		//玩法
  		string memory bettypeArr = bettype;
  				//投注方式
  		string memory chipintypeArr = chipintype;
  				//投注号码(多个以,分隔)
  		string memory wagerDataArr = wagerdata;
  				//投注号码个数(多个以,分隔)
  		string memory spotsArr = "";

  		string memory divisionName0;

      //倍数在
      string memory betmultirArr;
  		//4拖拉机投注 1  01|02|03*1
  		//5猜奇偶  全奇1 01|02|03*1  全偶2 01|02|03*1
  		//6猜大小  猜大1 01|02|03*1  猜小2  01|02|03*1
  		if (stringsEqual("4",bettypeArr) || stringsEqual("5",bettypeArr)|| stringsEqual("6",bettypeArr)) {
  			divisionName0 = getDivisionName("", winnumber, bettypeArr, chipintypeArr);
  		} else {
  			//2普通投注  2 08|03|02|10|06|04|09|07|05|01*5
  			//1精确投注  1精确投注 03|02*1   2复选 03|02*1   3组选 03|02*1
  			//3位置投注  1位置一 03*1 2位置二 03|04*1
  			//7和数     1 和数1 6*1
  			divisionName0 = getDivisionName(wagerDataArr, winnumber, bettypeArr, chipintypeArr);
  		}

  		if(stringsEqual(divisionName0,"") && !stringsEqual(wagerDataArr,"")){

  			// 获取奖等级别
        if(!stringsEqual("3",chipintypeArr) && (stringsEqual("1",bettypeArr) || stringsEqual("2",bettypeArr))){
  				uint wonCount1 = wonCount(wagerDataArr,winnumber, bettypeArr,chipintypeArr);// 计算中奖号码个数
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
}

/*
计算中奖号码个数
*/
function wonCount(string wagerdata, string winnerNumber, string bettype,string chipintype) internal returns (uint){

		uint wonCount0 = 0;
    if (stringsEqual("2",bettype) || (stringsEqual("1",bettype)&&stringsEqual("1",chipintype))) {
			wonCount0 = wonCount2Or1And1(wagerdata,winnerNumber,bettype,chipintype);
		} else {
			wonCount0 = wonCountZero(wagerdata,winnerNumber,bettype,chipintype);
		}
		return wonCount0;
}
function wonCount2Or1And1(string wagerdata, string winnerNumber, string bettype,string chipintype) internal returns (uint){
  var delim0 = ",".toSlice();
  var wagerdataArraystr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataArraystr.count(delim0) + 1);
  for(uint aa=0;aa<wagerdataArray.length;aa++){
    wagerdataArray[aa] = wagerdataArraystr.split(delim0).toString();
  }
  var winnerNumberstr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberstr.count(delim0) + 1);
  for(uint cc=0;cc<winnerNumberArray.length;cc++){
    winnerNumberArray[cc] = winnerNumberstr.split(delim0).toString();
  }
  uint wonCount0 = 0;
  for (uint i = 0; i < wagerdataArray.length; i++) {
    if (parseInt(wagerdataArray[i]) == parseInt(winnerNumberArray[i])) {
      wonCount0++;
    }
  }
  return wonCount0;
}

function wonCountZero(string wagerdata, string winnerNumber, string bettype,string chipintype) internal returns (uint){
  var delim0 = ",".toSlice();
  var wagerdataArraystr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataArraystr.count(delim0) + 1);
  for(uint aa=0;aa<wagerdataArray.length;aa++){
    wagerdataArray[aa] = wagerdataArraystr.split(delim0).toString();
  }
  var winnerNumberstr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberstr.count(delim0) + 1);
  for(uint cc=0;cc<winnerNumberArray.length;cc++){
    winnerNumberArray[cc] = winnerNumberstr.split(delim0).toString();
  }
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
function getDivisionName(string wagerdata, string winnerNumber,
  string playtype, string chipintype) internal returns (string){
  string memory divisionName;
  if(stringsEqual("1",playtype)&&stringsEqual("3",playtype)){
    divisionName = computer1(wagerdata,winnerNumber,playtype,chipintype);
  }else if(stringsEqual("3",playtype)){
    divisionName = computer3(wagerdata,winnerNumber,playtype,chipintype);
  }else if(stringsEqual("4",playtype)&&stringsEqual("1",chipintype)){
    divisionName = computer4And1(wagerdata,winnerNumber,playtype,chipintype);
  }else if(stringsEqual("5",playtype)){
    divisionName = computer5(wagerdata,winnerNumber,playtype,chipintype);
  }else if(stringsEqual("6",playtype)){
    divisionName = computer6(wagerdata,winnerNumber,playtype,chipintype);
  }else if(stringsEqual("7",playtype)&&stringsEqual("1",chipintype)){
    divisionName = computer7And1(wagerdata,winnerNumber,playtype,chipintype);
  }
  return divisionName;

}
function tempsplitStr(string strInfo,string delim) constant returns(string[]){
  var delim1 = delim.toSlice();
  var wagerdataStr = strInfo.toSlice();
  var wagerdataArray = new string[](wagerdataStr.count(delim1) + 1);
  uint kk=0;
  for(kk=0;kk<wagerdataArray.length;kk++){
    wagerdataArray[kk] = wagerdataStr.split(delim1).toString();
  }
  return wagerdataArray;
}
function computer1(string wagerdata, string winnerNumber,
  string playtype, string chipintype)internal returns (string){
    //string memory divisionName1;
    //var delim1 = ",".toSlice();
    var wagerdataStr = wagerdata.toSlice();
    var wagerdataArray = new string[](wagerdataStr.count(",".toSlice()) + 1);
    uint kk=0;
    for(kk=0;kk<wagerdataArray.length;kk++){
      wagerdataArray[kk] = wagerdataStr.split(",".toSlice()).toString();
    }
    var winnerNumberStr = winnerNumber.toSlice();
    var winnerNumberArray = new string[](winnerNumberStr.count(",".toSlice()) + 1);
    for(kk=0;kk<winnerNumberArray.length;kk++){
      winnerNumberArray[kk] = winnerNumberStr.split(",".toSlice()).toString();
    }
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
      divisionNameInfo = strConcat(playtype,"_",chipintype,"_",string(toBytes(wagerdataArray.length)));
    }else{
      divisionNameInfo = "";
    }
    return divisionNameInfo;
}
function computer3(string wagerdata, string winnerNumber,
  string playtype, string chipintype)internal returns (string){
    string memory divisionName3;
    //var delim1 = ",".toSlice();
    var wagerdataStr = wagerdata.toSlice();
    var wagerdataArray = new string[](wagerdataStr.count(",".toSlice()) + 1);
    uint ll=0;
    for(ll=0;ll<wagerdataArray.length;ll++){
      wagerdataArray[ll] = wagerdataStr.split(",".toSlice()).toString();
    }
    var winnerNumberStr = winnerNumber.toSlice();
    var winnerNumberArray = new string[](winnerNumberStr.count(",".toSlice()) + 1);
    for(ll=0;ll<winnerNumberArray.length;ll++){
      winnerNumberArray[ll] = winnerNumberStr.split(",".toSlice()).toString();
    }
    uint wagerdatalength = wagerdataArray.length;
    string memory winNum0;
    for(ll=0;ll<wagerdatalength;ll++){
      winNum0 = strConcat(winNum0,"#",winnerNumberArray[ll],"#","");
    }

    string memory winNum1 = strConcat("#",winnerNumberArray[0],"#",winnerNumberArray[1],"#");
    // 一至三号位置的开将号码
    winNum1 = strConcat(winNum1,winnerNumberArray[2],"#","","");
		uint wagerdatalength1 = wagerdataArray.length;// 投注号码个数 1-2个投注号码
		bool isWin1 = true;
		for (ll = 0; ll < wagerdatalength1; ll++) {
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
			divisionName3 = strConcat(playtype , "_" , chipintype , "_" , string(toBytes(wagerdatalength)));
		}
    return divisionName3;
  }
function computer4And1(string wagerdata, string winnerNumber,
  string playtype, string chipintype)  internal returns (string){
  string memory divisionName4;
  var delim1 = ",".toSlice();
  var wagerdataStr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataStr.count(delim1) + 1);
  for(uint ll=0;ll<wagerdataArray.length;ll++){
    wagerdataArray[ll] = wagerdataStr.split(delim1).toString();
  }
  var winnerNumberStr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberStr.count(delim1) + 1);
  for(uint kk=0;kk<winnerNumberArray.length;kk++){
    winnerNumberArray[kk] = winnerNumberStr.split(delim1).toString();
  }
  uint n1 = parseInt(winnerNumberArray[0]);
  uint n2 = parseInt(winnerNumberArray[1]);
  uint n3 = parseInt(winnerNumberArray[2]);
  if ((n1 + 1 == n2 && n2 + 1 == n3) || (n1 - 1 == n2 && n2 - 1 == n3)) {
    // 拖拉机,wagerdata固定位：1,2,3
    divisionName4 = strConcat(playtype , "_" , chipintype , "_0","");
  }
  return divisionName4;
}
function computer5(string wagerdata, string winnerNumber,string playtype,string chipintype)  internal returns (string){
  string memory divisionName5;

  var delim1 = ",".toSlice();
  var wagerdataStr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataStr.count(delim1) + 1);
  for(uint ll=0;ll<wagerdataArray.length;ll++){
    wagerdataArray[ll] = wagerdataStr.split(delim1).toString();
  }
  var winnerNumberStr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberStr.count(delim1) + 1);
  for(uint kk=0;kk<winnerNumberArray.length;kk++){
    winnerNumberArray[kk] = winnerNumberStr.split(delim1).toString();
  }
  uint n11 = parseInt(winnerNumberArray[0]);
  uint n21 = parseInt(winnerNumberArray[1]);
  uint n31 = parseInt(winnerNumberArray[2]);
  if (stringsEqual("1",chipintype) && n11 % 2 != 0 && n21 % 2 != 0 && n31 % 2 != 0) {
    // 全奇(1),wagerdata固定位：1,2,3
    divisionName5 = strConcat(playtype , "_" , chipintype , "_0","");
  } else if (stringsEqual("2",chipintype) && n11 % 2 == 0 && n21 % 2 == 0 && n31 % 2 == 0) {
    // 是全偶(2),wagerdata固定位：1,2,3
    divisionName5 = strConcat(playtype , "_" , chipintype , "_0","");
  }
  return divisionName5;
}
function computer6(string wagerdata, string winnerNumber,string playtype,string chipintype)  internal returns (string){
  string memory divisionName6;

  var delim1 = ",".toSlice();
  var wagerdataStr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataStr.count(delim1) + 1);
  for(uint ll=0;ll<wagerdataArray.length;ll++){
    wagerdataArray[ll] = wagerdataStr.split(delim1).toString();
  }
  var winnerNumberStr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberStr.count(delim1) + 1);
  for(uint kk=0;kk<winnerNumberArray.length;kk++){
    winnerNumberArray[kk] = winnerNumberStr.split(delim1).toString();
  }
  uint n12 = parseInt(winnerNumberArray[0]);
  uint n22 = parseInt(winnerNumberArray[1]);
  uint n32 = parseInt(winnerNumberArray[2]);
  uint n = n12 + n22 + n32;
  if (stringsEqual("1",chipintype) && 21 <= n && n <= 27) {
    // 猜大(1),wagerdata固定位：1,2,3
    divisionName6 = strConcat(playtype , "_" , chipintype , "_0","");
  } else if (stringsEqual("2",chipintype) && 6 <= n && n <= 12) {
    // 猜小(2),wagerdata固定位：1,2,3
    divisionName6 = strConcat(playtype , "_" , chipintype , "_0","");
  }
  return divisionName6;
}

function computer7And1(string wagerdata, string winnerNumber,string playtype,string chipintype)  internal returns (string){
  string memory divisionName7and1;
  var delim1 = ",".toSlice();
  var wagerdataStr = wagerdata.toSlice();
  var wagerdataArray = new string[](wagerdataStr.count(delim1) + 1);
  for(uint ll=0;ll<wagerdataArray.length;ll++){
    wagerdataArray[ll] = wagerdataStr.split(delim1).toString();
  }
  var winnerNumberStr = winnerNumber.toSlice();
  var winnerNumberArray = new string[](winnerNumberStr.count(delim1) + 1);
  for(uint kk=0;kk<winnerNumberArray.length;kk++){
    winnerNumberArray[kk] = winnerNumberStr.split(delim1).toString();
  }
  uint n13 = parseInt(winnerNumberArray[0]);
  uint n23 = parseInt(winnerNumberArray[1]);
  uint n33 = parseInt(winnerNumberArray[2]);
  uint n9 = n13 + n23 + n33;
  var delim2 = ",".toSlice();
  var wagerdataStr22 = wagerdata.toSlice();
  var wagerdataArray1 = new string[](wagerdataStr22.count(delim2) + 1);
  string memory wagerNum3;
  for(uint jj=0;jj<wagerdataArray1.length;jj++){
    wagerNum3 = strConcat(wagerNum3,wagerdataStr22.split(delim2).toString(),"","","");
  }
  uint wagerNum2 = parseInt(wagerNum3);
  if (wagerNum2 == n9) {
    // 和数
    divisionName7and1 = strConcat(playtype , "_" , chipintype , "_" , string(toBytes(wagerNum2)));
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
