pragma solidity ^0.4.11;

import './BasicToken.sol';

contract CASACrowdsale is BasicToken {
  using SafeMath for uint256;

  string public constant name = "Casa Opalita"; //Confirm
  string public constant symbol = "OPAL"; //Confirm
  uint8 public constant decimals = 18;
  uint256 public constant rate = 10000;
  uint256 public startTime;
  uint256 public constant endTime = 1546318799; //Unix Epoch timestamp for: 31 Dec 2018, 23:59:59
  uint256 public weiRaised;
  uint256 public amountSold; //Includes decimal places

  event TokenPurchase(address indexed purchaser, uint256 amountWei, uint256 amountOut);

  function CASACrowdsale() {
    require(now < endTime);
    startTime = now;
    _totalSupply = 5000000 ether;
    balances[owner] = _totalSupply;
  }

  function () payable {
    buy();
  }

  function buy() payable {
    uint256 recieveAmount = validateAndCalculate(msg.sender);
    //Validated...
    amountSold = amountSold.add(recieveAmount);
    weiRaised = weiRaised.add(msg.value);
    //Accounted For...
    balances[owner] = balances[owner].sub(recieveAmount);
    balances[msg.sender] = balances[msg.sender].add(recieveAmount);
    owner.transfer(msg.value);
    //Finalized
    TokenPurchase(msg.sender, msg.value, recieveAmount);
  }

  function validateAndCalculate(address buyer) internal constant returns (uint256) {
    uint256 recieveAmount = calculateBonus(msg.value.mul(rate));
    bool validAddress = (buyer != 0x0) ? true : false;
    bool nonZeroPurchase = msg.value != 0;
    bool duringCrowdsale = now <= endTime;
    bool underHardCap = amountSold.add(recieveAmount) <= 5000000 ether;
    bool haveTokens = balances[owner] >= recieveAmount;
    require(duringCrowdsale && nonZeroPurchase && validAddress && underHardCap && haveTokens);
    return recieveAmount;
  }

  function getPhase() internal constant returns (uint8) {
    if (now < startTime.add(30 days)) {
      return 0; //Presale 1
    } else if (now < startTime.add(60 days)) {
      return 1; //Presale 2
    } else if (now < startTime.add(90 days)) {
      return 2; //Presale 3
    } else if (now < startTime.add(120 days)) {
      return 3; //Presale 4
    } else if (now < endTime) {
      return 4; //Public Sale
    } else {
      return 5; //Sale Finished
    }
  }

  function calculateBonus(uint256 amt) internal constant returns (uint256) {
    uint8 phase = getPhase();
    if (phase == 0) {
      return amt.mul(21).div(20);   // 21/20    = 1.05
    } else if (phase == 1) {
      return amt.mul(26).div(25);   // 26/25    = 1.04
    } else if (phase == 2) {
      return amt.mul(103).div(100); // 103/100  = 1.03
    } else if (phase == 3) {
      return amt.mul(51).div(50);   // 51/50    = 1.02
    } else if (phase == 4){
      return amt.mul(101).div(100); // 101/100  = 1.01
    } else {
      revert();
    }
  }
}
