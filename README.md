# 合约返回状态
## 随机数  RandomApple.sol
    fingerprintInfo:收集指纹
    已收集过指纹--1
    正在生成随机数--2
    成功收集指纹--0
    computerRandomNumber:生成随机数
    不是合约创建者--3
    现有的用户指纹数过低，不能生成随机数--4
    成功生成随机数--0
    getFixedRange:生成固定范围的随机数
    生成失败--0
    
## 发布房产 HouseRelease.sol


## 竞拍房产 Auction.sol
    auctionBid方法：收集竞拍信息
    合约创建者不能参与竞拍--1
    未到竞拍开始时间--2
    竞拍已结束--3
    竞拍价小于当前最高价--4
    竞拍用户的余额不足--5
    低于竞价幅度值--6
    auctionEnd方法：竞拍结束时调用
    合约创建者调用结束方法--7
    竞拍未结束--8
    已经调用过竞拍结束方法--9

## 买卖房产 BuyingSellingHouses.sol
    sellHouse方法：卖房信息设置
    房屋id小于开始号—— 1
    房屋id大于结束号-- 2
    cancelHouse方法：房屋撤销设置
    房屋id小于开始号—— 3
    房屋id大于结束号-- 4
    房屋已卖出不能撤销-- 5
    buyHouse方法：买房信息设置
    房屋id小于开始号—— 6
    房屋id大于结束号-- 7
    卖方不能买入房产—— 8
    买方余额不足 ——  9
    房产已卖出——   10
    房屋买卖已撤销—— 11

## 总奖池 PrizePool.sol



## 轻博彩（pk10）GamePlay.sol

    setInfo方法：设置游戏信息
    不是创建合约用户，不能设置地址信息--1
    addPool方法：增加奖池金额
    不是创建合约用户，不能设置地址信息--2
    setGamePeriod方法：设置开奖号码和期号
    不是创建合约用户，不能设置开奖号码和开奖期号--3
    userBetting方法：收集用户投注信息
    游戏已结束--4
    computerPrize方法：算奖并返奖
    已经算过奖--5
    不是创建合约用户，不能算奖--6
    游戏未结束--7
