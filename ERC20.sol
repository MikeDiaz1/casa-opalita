pragma solidity ^0.4.11;

//Interface for the ERC20 required features
contract ERC20 {
  uint256 internal _totalSupply;
  function totalSupply() constant returns (uint256);
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 amount) returns (bool);
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 amount) returns (bool);
  function approve(address spender, uint256 amount) returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);
}
