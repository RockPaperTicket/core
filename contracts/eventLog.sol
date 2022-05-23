pragma solidity 0.8.4;

//This contract is a log of the created events

import "@openzeppelin/contracts/access/Ownable.sol";

contract eventLog {
    // all events ever created are stored in these structures
    uint256 s_numberOfEvents;
    uint256[] s_eventIds;
    mapping(uint256 => Event) s_events; // s_eventId => Event

    // every user events are stored as userAddress => Event
    mapping(address => uint256[]) s_registeredEvents;
    mapping(address => uint256[]) s_createdEvents;

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

    constructor() {
        s_numberOfEvents = 0;
    }

    function _logEvent(
        uint256 _eventId,
        address _eventGameAddress,
        address _eventOwner,
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external {
        s_events[_eventId] = Event(
            _eventGameAddress,
            _eventOwner,
            _eventName,
            _numberOfTickets,
            _ticketPrice,
            true
        );
        s_numberOfEvents += 1;
        s_eventIds.push(_eventId);
    }

    function _updateName(uint256 _eventId, string memory _newName)
        external
        onlyOwner
    {
        s_events[_eventId].eventName = _newName;
    }

    function _updateTickets(uint256 _eventId, uint256 _newTickets)
        external
        onlyOwner
    {
        s_events[_eventId].numberOfTickets = _newTickets;
    }

    function _updatePrice(uint256 _eventId, uint256 _newPrice)
        external
        onlyOwner
    {
        s_events[_eventId].ticketPrice = _newPrice;
    }

    function _closeEvent(uint256 _eventId) external onlyOwner {
        s_events[_eventId].isOpen = false;
    }

    function getEvent(uint256 _eventId) public view returns (Event memory) {
        return s_events[_eventId];
    }

    function getOpenEvents() public view returns (Event[] memory) {
        uint256 availableLength = 0;
        for (uint256 i = 0; i < s_numberOfEvents; i++) {
            if (s_events[i].isOpen == true) {
                availableLength += 1;
            }
        }

        uint256 currentIndex = 0;
        Event[] memory openEvents = new Event[](availableLength);
        for (uint256 i = 0; i < s_numberOfEvents; i++) {
            if (s_events[i].isOpen == true) {
                Event storage currentItem = s_events[i];
                openEvents[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return openEvents;
    }

    function _addWinner(uint256 _eventId, address _winner) external {
        //this visibility must be protected
        s_winners[_eventId][_winner] = true;
    }
}
