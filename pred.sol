pragma solidity ^0.8.0;

contract BettingContract {
    address public owner;
    bool public bettingOpen;
    uint256 public winner;
    mapping(uint256 => mapping(address => uint256)) bets;

    constructor() {
        owner = msg.sender;
    }

    // Start the betting window
    function startBetting() public {
        require(msg.sender == owner, "Only owner can start betting");
        require(!bettingOpen, "Betting is already open");
        bettingOpen = true;
    }

    // Place a bet on a specific event
    function placeBet(uint256 eventId) public payable {
        require(bettingOpen, "Betting is not open");
        bets[eventId][msg.sender] += msg.value;
    }

    // End the betting window and determine the winner
    function endBetting(uint256 winningEventId) public {
        require(msg.sender == owner, "Only owner can end betting");
        require(bettingOpen, "Betting is not open");
        winner = winningEventId;
        bettingOpen = false;
    }
    
    // Withdraw winnings for a winning bet
    function withdrawWinnings(uint256 eventId) public {
        uint256 winnings = bets[eventId][msg.sender];
        require(winner == eventId, "Event is not the winning event");
        require(winnings > 0, "No winnings for this event");
        bets[eventId][msg.sender] = 0;
        payable(msg.sender).transfer(winnings);
    }
}
