pragma solidity 0.8.4;

// This contract
// 1) is a factory of eventGame contracts
// 2) records every event created

import "./eventGame.sol";

contract EventFactory {
    address immutable s_logAddress;
    uint256 s_nextId;

    constructor(address _logAddress) {
        s_logAddress = _logAddress;
        s_nextId = 1;
    }

    // deploy a new contract for the event and log it
    function createEventGame(
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external returns (address) {
        EventLog log = EventLog(s_logAddress);
        EventGame game = new EventGame(s_logAddress, msg.sender, s_nextId);
        log._logEvent(
            s_nextId,
            address(game),
            msg.sender,
            _eventName,
            _numberOfTickets,
            _ticketPrice
        );
        log._addCreatedEvent(msg.sender, s_nextId);
        s_nextId += 1;
    }
}
