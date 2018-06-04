pragma solidity ^0.4.22;

contract SimpleAuction {

    //受益者地址
    address public beneficiary;
    //结束时间
    uint public auctionEnd;

    //出最高价的用户的地址
    address public highestBidder;
    //最高价
    uint public highestBid;

    //所有出价人的地址及出的最高价
    mapping(address => uint) pendingReturns;
    //所有出价人地址
    address[] addressArray = new address[](1);

    //竞拍结束
    bool ended;

    //出现最高出价者时，触发的事件。
    event HighestBidIncreased(address bidder, uint amount);
    //竞拍结束时，调用的事件。
    event AuctionEnded(address winner, uint amount);

    function SimpleAuction(uint _biddingTime) public {
        beneficiary = msg.sender;
        auctionEnd = now + _biddingTime;
    }

    function bid() public payable {


        require(beneficiary != msg.sender);
        //当前时间小于结束时间时，不返回；
        require(now <= auctionEnd);

        //当前出价大于最大价格时，不返回；
        require(msg.value > highestBid);

        //当前用户余额大于出价值时，不返回；
        require(msg.sender.balance > msg.value);


        highestBidder = msg.sender;
        highestBid = msg.value;

        uint fzuntAmount;
        //是否包含
        if(pendingReturns[highestBidder]==0){
            addressArray.push(highestBidder);
            fzuntAmount = highestBid;
        }else{
            fzuntAmount = pendingReturns[highestBidder];
            fzuntAmount = highestBid - fzuntAmount;
            pendingReturns[highestBidder] = highestBid;
        }

        //当前用户扣款
        msg.sender.transfer(-fzuntAmount);
        //受益者用户接收转账
        beneficiary.transfer(fzuntAmount);
        emit HighestBidIncreased(msg.sender, msg.value);
    }



    //竞价结束时调用
    function auctionEnd() public {

        //当前时间大于等于结束时间时，不返回；
        require(now >= auctionEnd);
        //
        require(!ended);

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        uint len = addressArray.length;

        for(uint i=0;i<len;i++){
            address strAddress = addressArray[i];
            if(strAddress != highestBidder){
                uint tempAmount  = pendingReturns[strAddress];
                pendingReturns[strAddress] = 0;
                //返还冻结的资金
                strAddress.transfer(tempAmount);
                beneficiary.transfer(-tempAmount);

            }
        }
    }
}
