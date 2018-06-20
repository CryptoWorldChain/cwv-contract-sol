pragma solidity ^0.4.22;

contract TestContract{
  address owner;

string strs;
  constructor(string str) public {
    owner = msg.sender;
    strs = str;
  }

  function testBid(uint256 pirce) public payable{
    owner.transfer(pirce);

  }

}
