pragma solidity ^0.4.22;

contract TestContract{
  address owner;
  string strinfo;

  constructor(string _strinfo) public{
    owner = msg.sender;
    strinfo = _strinfo;
  }
  function testTransfer(uint256 pirce) public payable{
    owner.transfer(pirce);
  }

  function getAddr() public view returns(address){
    return owner;
  }
  function getInfo() public view returns(string){
    return strinfo;
  }
}
