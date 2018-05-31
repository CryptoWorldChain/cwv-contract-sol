pragma solidity ^0.4.22;

contract BuyingSellingHouses{
    uint256 houseTotalNum = 1000000;
    uint256 houseSign = 0;
    struct HouseInfo{
      uint256 sellPrice;
      address sellAddr;
      uint256 commPrice;
      address commAddr;
      address buyAddr;
      bool isSell;
    }
    mapping(string => HouseInfo) houseSellInfo;
    event BuyHouse(address winner,uint256 amount,bool isSells,string houseid);
    event HouseTotal(uint256 houseSigns);
    function sellHouse(string _houseid,uint256 _sellPrice,uint256 _commissionPrice,address _commission) public {
      require(houseSign<houseTotalNum,"1");
      houseSellInfo[_houseid] = HouseInfo(_sellPrice,msg.sender,_commissionPrice,_commission,_commission,false);
      houseSign = houseSign +1;
      emit HouseTotal(houseSign);
    }

    function buyHouse(string _houseid) public payable {

        uint256 tempSellPrice = houseSellInfo[_houseid].sellPrice;
        address tempSellAddr = houseSellInfo[_houseid].sellAddr;
        bool tempIsSell = houseSellInfo[_houseid].isSell;
        require(tempSellAddr != msg.sender,"2");
        require(msg.sender.balance > tempSellPrice,"3");
        require(!tempIsSell,"4");

        houseSellInfo[_houseid].buyAddr = msg.sender;

        uint256 tempCommissionPrice = houseSellInfo[_houseid].commPrice;
        uint256 tempTruePrice =  tempSellPrice - tempCommissionPrice;
        tempSellAddr.transfer(tempTruePrice);
        houseSellInfo[_houseid].commAddr.transfer(tempCommissionPrice);
        houseSellInfo[_houseid].isSell = true;
        emit BuyHouse(msg.sender,tempSellPrice,houseSellInfo[_houseid].isSell,_houseid);
    }
}
