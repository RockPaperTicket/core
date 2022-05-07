pragma solidity ^0.8.7;

// This contract
// 1) is a factory of eventGame contracts
// 2) records every event created  

interface eventLog {
    _logEvent(string memory _eventName, address _eventGameAddress, address _eventOwner, uint32 _numberOfTickets, uint32 _ticketPrice){
}

contract eventFactory is eventGame {

    address public s_logAddress;

    constructor(address _logAddress) {
        s_logAddress = _logAddress;
    }

    // deploy a new contract for the event and log it
    function createEventGame(string memory _eventName, uint32 _numberOfTickets, uint32 _ticketPrice) external {
        eventLog log = eventLog(logAddress);
        eventGame game = new eventGame();
        log._logEvent (_eventName, game, msg.sender, _numberOfTickets, ticketPrice);
    }
}