pragma solidity ^0.4.21;


contract owned{

  function owned public() {
        owner = msg.sender;
    }
    modifier onlyowner() {
        if (msg.sender == owner)
            _;
    }
    address owner;
}
