pragma solidity ^0.4.22;

contract Auction{
    bool ended = false;
    uint256 startTime;
    uint256 endTime;


    address beneficiary;
    address highestBidder;
    uint256 highestBid = 0;

    uint256 bidStartingPrice;
    uint256 increasePrice;

    struct AuctionInfo{
      //address auctionAddr;
      uint256 bidPrice;
      uint256 bidFrequency;
      bool isExist;
    }
    address[] auctionUser = new address[](1);
    mapping(address => AuctionInfo) pendingReturns;


    constructor(uint256 _startTime,uint256 _endTime,uint256 _bidStartingPrice,uint256 _increasePrice) public {
      beneficiary = msg.sender;
      bidStartingPrice = _bidStartingPrice;
      increasePrice = _increasePrice;
      startTime = _startTime;
      endTime = _endTime;
    }

    event test(uint256 num,address tempaddrs);
    function auctionBid(uint256 _bigPrice)  public payable{
      require(beneficiary != msg.sender);
      //现在时间小于竞拍开始时间
      require(now > startTime,"");
      //现在时间大于竞拍结束时间
      require(now < endTime,"");
      uint256 differencePrice;
      uint256 computerBidPrice;
      uint256 tempBidFrequency;

      if(pendingReturns[msg.sender].isExist){
        AuctionInfo storage auctionInfo = pendingReturns[msg.sender];
        uint256 tempbidPrice = auctionInfo.bidPrice;
        differencePrice = _bigPrice - tempbidPrice;

        computerBidPrice = differencePrice;

        tempBidFrequency = auctionInfo.bidFrequency;
        tempBidFrequency = tempBidFrequency + 1;
      }else{
        computerBidPrice = _bigPrice;
        if(highestBidder>0){
            differencePrice = _bigPrice - bidStartingPrice;
        }else{
            differencePrice = _bigPrice - highestBid;
        }
        tempBidFrequency = 1;
        auctionUser.push(msg.sender);
      }

      if(highestBid < _bigPrice){
        highestBid = _bigPrice;
        highestBidder = msg.sender;
      }
      //竞拍者的余额小于竞拍价
      require(msg.sender.balance >= computerBidPrice,"1");
      //涨价的幅度小于既定额度
      require(differencePrice >= increasePrice,"2");

      pendingReturns[msg.sender] = AuctionInfo(_bigPrice,tempBidFrequency,true);

      beneficiary.transfer(computerBidPrice);
    }


    function auctionEnd() public payable{
      require(msg.sender == beneficiary,"");
      //当前时间小于结束时间
      require(now > endTime,"");

      require(!ended,"");
      ended = true;

      uint256 len = auctionUser.length;
      for(uint256 i=1;i<len;i++){
          address tempUserAddr = auctionUser[i];
          if(tempUserAddr != highestBidder){
            AuctionInfo storage auctionInfo = pendingReturns[tempUserAddr];
            uint256 tempPrice = auctionInfo.bidPrice;
            tempUserAddr.transfer(tempPrice);
          }
      }

    }
}
