pragma solidity ^0.4.18


contract hello{
    string greeting;


    function hello(string _greeting) public{
        greeting = _greeting;
    }

    function say() contract public return (string){
        return greeting;
    }
}