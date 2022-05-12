pragma solidity 0.8.4;

// This contract
// 1) is a factory of eventGame contracts
// 2) records every event created

import "https://github.com/RockPaperTicket/core/blob/eventFactory/contracts/eventGame.sol";

contract eventFactory {
    address immutable s_logAddress;

    constructor(address _logAddress) {
        s_logAddress = _logAddress;
    }

    // deploy a new contract for the event and log it
    function createEventGame(
        string memory _eventName,
        uint32 _numberOfTickets,
        uint32 _ticketPrice
    ) external {
        eventLog log = eventLog(s_logAddress);
        eventGame game = new eventGame(
            s_logAddress,
            _numberOfTickets,
            msg.sender
        );
        log._logEvent(
            _eventName,
            address(game),
            msg.sender,
            _numberOfTickets,
            _ticketPrice
        );
    }
}
