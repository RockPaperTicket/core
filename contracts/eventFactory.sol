pragma solidity 0.8.4;

// This contract
// 1) is a factory of eventGame contracts
// 2) records every event created

import "./eventGame.sol";

contract eventFactory {
    address immutable s_logAddress;
    uint256 s_numberOfEvents;

    constructor(address _logAddress) {
        s_logAddress = _logAddress;
        s_numberOfEvents = 0;
    }

    // deploy a new contract for the event and log it
    function createEventGame(
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external {
        eventLog log = eventLog(s_logAddress);
        eventGame game = new eventGame(
            s_logAddress,
            msg.sender,
            s_numberOfEvents
        );
        log._logEvent(
            address(game),
            msg.sender,
            _eventName,
            _numberOfTickets,
            _ticketPrice
        );
        s_numberOfEvents += 1;
    }
}
