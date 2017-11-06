pragma solidity ^0.4.11;

import './SafeMath.sol';
import './ERC20.sol';
import './Ownable.sol';

/*
 *Flush out basic functionality
 */
contract BasicToken is ERC20, Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) balances;
  mapping(address => mapping (address => uint256)) allowances;

  function myBalance() constant returns (uint256 balance){
    return balances[msg.sender];
  }

  function totalSupply() constant returns (uint256){
    return _totalSupply;
  }

  function balanceOf(address owner) constant returns (uint256 balance){
    return balances[owner];
  }

  function transfer(address to, uint256 amount) returns (bool success){
    require(balances[msg.sender] >= amount
      && amount > 0
      && balances[to] + amount > balances[to]
    );

    balances[msg.sender] = balances[msg.sender].sub(amount);
    balances[to] = balances[to].add(amount);
    Transfer(msg.sender, to, amount);
    return true;
  }

  function transferFrom(address from, address to, uint amount) returns (bool success){
    require(balances[from] >= amount
      && allowances[from][msg.sender] >= amount
      && amount > 0
      && balances[to] + amount > balances[to]
    );

    balances[from] = balances[from].sub(amount);
    allowances[from][msg.sender] = allowances[from][msg.sender].sub(amount);
    balances[to] = balances[to].add(amount);
    Transfer(from, to, amount);
    return true;
  }

  function approve(address spender, uint256 amount) returns (bool success){
    allowances[msg.sender][spender] = amount;
    Approval(msg.sender, spender, amount);
    return true;
  }

  function allowance(address owner, address spender) constant returns (uint256 remaining){
    return allowances[owner][spender];
  }
}
