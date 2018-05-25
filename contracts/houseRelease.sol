pragma solidity ^0.4.21;

/*
721token发行
*/
contract houseRelease{

  //超级账户地址
  address owner = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;

  //721token
  string soymol;
  //名称
  string name;
  //Id
  string code;
  //索引
  string index;
  //总量
  string total;

  /*function houseRelease() public{
      //owner = msg.sender;
      owner = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
  }*/


  function createHouse(string _soymol,string _name,string _code,string _index,string _total) public{
    require(owner == msg.sender);
      soymol = _soymol;
      name = _name;
      code = _code;
      index = _index;
      total = _total;
  }

}
