pragma solidity ^0.4.22;

contract TestMapping{

  mapping(address => string) testmap;
  function setMapping(string strInfo) public {
    testmap[msg.sender] = strInfo;
  }

  function getBalance() public view returns(string){
    return testmap[msg.sender];
  }

}
