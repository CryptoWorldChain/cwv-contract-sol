pragma solidity ^0.4.22;

contract TestArray{

  address[] testAddr = new address[](1);
  function setArray() public {

    testAddr.push(msg.sender);
  }

  function getArray() public view returns(address){
    return testAddr[1];
  }

}
