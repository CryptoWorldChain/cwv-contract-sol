pragma solidity ^0.4.22;

contract TestReturn{

  uint256 num = 0;
  function getNum() public payable returns(uint256){
    num = num + 1;
    return num;
  }
}
