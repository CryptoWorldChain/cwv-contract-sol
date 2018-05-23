pragma solidity ^0.4.21;

contract BuyingSellingHouses{

    //开始卖房时间 及受益人
    address beneficiary;

    //佣金地址
    //address commission;


    //买入人地址
    address buyMan;


    uint public auctionStart;
    uint128 public sellPrice;
    //佣金价格
    uint128 public commissionPrice;
    string public houseid;

    //房屋已成交
    bool ended;

    // 买入调用事件    买入者地址    买入价格
    event BuyHouse(address winner,uint amount);
    function BuyingSellingHouses ()  public {
      beneficiary = msg.sender;
      /*commission = _commission;
      commissionSigPub = _commissionSigPub;
      beneficiarySigPub = _beneficiarySigPub;*/
    }
    /* //卖出对象     卖出人地址   卖出价格
    function BuyingSellingHouses (address _beneficiary,uint _amount)  public {
        beneficiary = _beneficiary;
        auctionStart = now;
        amountHouse = _amount;
    } */
    //设置卖出信息
    /* function setSell(address _commission) public {
      require(beneficiary == msg.sender);
      commission = _commission;
    } */

    //卖出信息    _houseid 房屋id  _sellPrice 卖出价格
    function sellHouse(string _houseid,uint128 _sellPrice) public {
      require(beneficiary == msg.sender);
      houseid = _houseid;
      sellPrice = _sellPrice;
    }

    //买入
    function buyHouse() public {
        require(beneficiary != msg.sender);
        require(msg.sender.balance > sellPrice);
        require(!ended);
        buyMan = msg.sender;


        emit BuyHouse(msg.sender,sellPrice);
        //收千分之一的佣金
        //commissionPrice = sellPrice * 1/1000;
        beneficiary.transfer(sellPrice);
        //commission.transfer(commissionPrice);
        msg.sender.transfer(-sellPrice);

        ended = true;
    }
}
