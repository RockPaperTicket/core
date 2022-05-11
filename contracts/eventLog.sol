pragma solidity 0.8.4;

//This contract is a log of the created events

contract eventLog {
    mapping(string => Event) s_events;
    struct Event {
        address eventGameAddress;
        address eventOwner;
        uint32 numberOfTickets;
        uint32 ticketPrice;
    }

    function _logEvent(
        string memory _eventName,
        address _eventGameAddress,
        address _eventOwner,
        uint32 _numberOfTickets,
        uint32 _ticketPrice
    ) external {
        Event memory newEvent = Event(
            _eventGameAddress,
            _eventOwner,
            _numberOfTickets,
            _ticketPrice
        );
        s_events[_eventName] = newEvent;
    }
}
