pragma solidity ^0.8.7;

//This contract is a log of the created events

contract eventLog {

    mapping(string=>Event) s_events;
    Event {
        eventGameAddress;
        eventOwner;
        numberOfTickets;
        ticketPrice;
    }

    _logEvent(string memory _eventName, address _eventGameAddress, address _eventOwner, uint32 _numberOfTickets, uint32 _ticketPrice) internal {
        Event memory newEvent = Event(_eventGameAddress, _eventOwner, _numberOfTickets, _ticketPrice);
        s_events[_eventName] = newEvent;
    }

}

