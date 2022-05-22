pragma solidity 0.8.4;

//This contract is a log of the created events

contract eventLog {
    // all events ever created are stored in these structures
    uint256 s_eventId;
    uint256[] s_eventIds;
    mapping(uint256 => Event) s_events; // s_eventId => Event

    // every user events are stored as userAddress => Event
    mapping(address => Event[]) s_registeredEvents;
    mapping(address => Event[]) s_createdEvents;

    // the winners of each event are stored as s_eventId => userAddress => true
    mapping(uint256 => mapping(address => bool)) s_winners;

    struct Event {
        address eventGameAddress;
        address eventOwner;
        string eventName;
        uint256 numberOfTickets;
        uint256 ticketPrice;
        bool isOpen;
    }

    function _logEvent(
        address _eventGameAddress,
        address _eventOwner,
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) public {
        s_events[s_eventId] = Event(
            _eventGameAddress,
            _eventOwner,
            _eventName,
            _numberOfTickets,
            _ticketPrice,
            true
        );
        s_eventId += 1;
    }

    function _closeEvent(uint256 _eventId) external {
        s_events[_eventId].isOpen = false;
    }

    function getEvent(uint256 _eventId) public view returns (Event memory) {
        return s_events[_eventId];
    }

    function getOpenEvents() public view returns (Event[] memory) {
        Event[] memory openEvents;
        for (uint256 i; i < s_eventId + 1; i++) {
            if (s_events[i].isOpen == true) {
                openEvents.push(s_events[i]);
            }
        }
        return openEvents;
    }

    function _addWinner(uint256 _eventId, address _winner) public {
        s_winners[_eventId][_winner] = true;
    }
}
