// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FortuneWheel {
  address public owner;
  uint256 public totalPrize;
  uint256 public totalParticipants;
  mapping(address => uint256) public participantBalances;

  event SpinResult(address indexed participant, uint256 prize);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the contract owner can call this function");
    _;
  }

  function spinWheel() external payable {
    require(msg.value > 0, "You need to send some ether to spin the wheel");
    
    uint256 prize = determinePrize();
    totalPrize += prize;
    totalParticipants++;
    participantBalances[msg.sender] += prize;

    emit SpinResult(msg.sender, prize);
  }

  function withdrawPrize() external {
    uint256 prize = participantBalances[msg.sender];
    require(prize > 0, "You don't have any prize to withdraw");

    participantBalances[msg.sender] = 0;
    totalPrize -= prize;

    payable(msg.sender).transfer(prize);
  }

  function determinePrize() internal view returns (uint256) {
    // Add your logic to determine the prize amount here
    // For example, you can use random number generation or any other algorithm
    // This is just a placeholder implementation
    return block.timestamp % 100;
  }

  // Only the contract owner can withdraw the remaining balance
  function withdrawRemainingBalance() external onlyOwner {
    require(totalPrize > 0, "There is no remaining balance to withdraw");

    uint256 remainingBalance = totalPrize;
    totalPrize = 0;

    payable(owner).transfer(remainingBalance);
  }
}
