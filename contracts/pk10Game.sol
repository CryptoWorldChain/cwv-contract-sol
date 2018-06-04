pragma solidity ^0.4.22;

library pk10Game{

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



  function divisionMoney(string infoLevel) internal pure returns(string){
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
    }else{
      prizeMoney = "0";
    }
    return prizeMoney;
  }

  //获取奖等及奖金
  function divisionTransfer(string infoName) internal pure returns (string){
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

  function calcPrizeLevelStruct (BettingValue memory bettingValue,WinNumValue winNumValue) internal pure returns(string){

    // 根据中奖号码算奖 01|02|03|
    //string memory winnumber = winCode;
    //玩法
    string memory bettypeArr = bettingValue.playtype;
        //投注方式
    //string memory chipintypeArr = bettingValue.chipintype;
        //投注号码(多个以,分隔)
    //string memory wagerDataArr = wagerdata;
        //投注号码个数(多个以,分隔)
    //string memory spotsArr = "";

    string memory divisionName0;

    //倍数在
    //string memory betmultirArr = bettingValue.multiple;
    //4拖拉机投注 1  01|02|03*1
    //5猜奇偶  全奇1 01|02|03*1  全偶2 01|02|03*1
    //6猜大小  猜大1 01|02|03*1  猜小2  01|02|03*1
    if (stringsEqual("4",bettypeArr) || stringsEqual("5",bettypeArr)|| stringsEqual("6",bettypeArr)) {
      //divisionName0 = getDivisionName("", winnumber, bettypeArr, chipintypeArr);
      divisionName0 = getDivisionName(bettingValue,winNumValue);
    }


    return divisionName0;
  }



  /*
  计算是否中奖
  wagerdata		投注号码
  winnerNumber	中奖号码
  playtype		玩法
  chipintype		类型
  */
  function getDivisionName(BettingValue bettingValue,WinNumValue winNumValue) internal pure returns (string){
    string memory divisionName;
    if(stringsEqual("4",bettingValue.playtype)&&stringsEqual("1",bettingValue.chipintype)){
      //拖拉机投注
      divisionName = computer4And1(bettingValue,winNumValue);
    }else if(stringsEqual("5",bettingValue.playtype)){
      //猜奇偶
      divisionName = computer5(bettingValue,winNumValue);
    }else if(stringsEqual("6",bettingValue.playtype)){
      //猜大小
      divisionName = computer6(bettingValue,winNumValue);
    }
    return divisionName;

  }


  function computer4And1(BettingValue bettingValue,WinNumValue winNumValue)  internal pure returns (string){
    string memory divisionName4;
    //string[] memory wagerdataArray = bettingValue.bettingArray;

    uint n1 = parseInt(winNumValue.winOne);
    uint n2 = parseInt(winNumValue.winTwo);
    uint n3 = parseInt(winNumValue.winThree);
    if ((n1 + 1 == n2 && n2 + 1 == n3) || (n1 - 1 == n2 && n2 - 1 == n3)) {
      // 拖拉机,wagerdata固定位：1,2,3
      divisionName4 = strConcat(bettingValue.playtype , "_" , bettingValue.chipintype , "_0","");
    }
    return divisionName4;
  }
  function computer5(BettingValue bettingValue,WinNumValue winNumValue)  internal pure returns (string){
    string memory divisionName5;

    //string[] memory wagerdataArray = bettingValue.bettingArray;

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
  function computer6(BettingValue bettingValue,WinNumValue winNumValue)  internal pure returns (string){
    string memory divisionName6;

    //string[] memory wagerdataArray = bettingValue.bettingArray;

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



    function nameLength(string name) internal pure returns (uint) {

        return bytes(name).length;
    }
  //字符串转整数
  function parseInt(string _a) internal pure returns (uint) {
      return parseInt(_a, 0);
  }

  //字符串转整数
  function parseInt(string _a, uint _b) internal pure returns (uint) {
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
  function stringsEqual(string memory _a, string memory _b) internal pure returns (bool) {
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
    function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
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
    function toBytes(uint256 x)internal pure returns (bytes) {
      bytes memory b = new bytes(32);
      assembly { mstore(add(b, 32), x) }
    }
  }
