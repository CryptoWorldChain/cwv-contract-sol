pragma solidity ^0.4.22;

contract TestGet{


  function getCurrentTimes() public pure returns(string){
    require(1>2,"1");
    return "hello 您好！";
  }

  function getBalance() public payable returns(uint256){
    return msg.sender.balance;
  }

}
