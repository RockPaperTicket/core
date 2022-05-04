pragma solidity ^0.8.7;

contract eventFactory is eventGame {

    // This contract
    // 1) is a factory of eventGame contracts
    // 2) records every event created 

    // mapping of the created events
    mapping(string=>Event) events;
    Event {
        eventGameAddress;
        eventOwner;
        numberOfTickets;
    }

    // deploys a new contract for the event and adds it into the mapping
    function createEventGame(string memory _eventName, uint32 _numberOfTickets) external {
        eventGame EventGame = new eventGame();
        _recordEvent (EventGame, msg.sender, _numberOfTickets);
    }

    function _recordEvent (address _EventGame, address _owner, uint32 _numberOfTickets) public {
        Event memory newEvent = Event(EventGame, msg.sender, _numberOfTickets);
        events[_eventName] = newEvent;
    }
    
}

interface Factory {
    function _recordEvent (address _EventGame, address _owner, uint32 _numberOfTickets) public;
}

contract eventGame {

    // This contract
    // 1) can update the name and number of tickets of the event
    // 3) allows any user to register to the event
    // 4) allows the organizer to start the game

    address immutable s_owner;
    bool s_registrationOpen = false;

    // Interface
    address immutable s_eventFactory;
    Factory factory = Factory (s_eventFactory);

    struct Game {
        address[] winners; //winners of the game (people who can mint tickets)
        address[] participants;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner) {
        s_owner = _owner;
        s_eventFactory = msg.sender;
    }


    ///////////////////////// EVENT BLOCK

    // updates the event name and number of tickets
    function updateEvent(string memory _newName, uint32 _newTickets) external onlyOwner {
        factory._recordEvent(this.address, msg.sender, _newTickets);
    }

    // stops registration and sets the participants of the game
    function startGame() public onlyOwner {
        if (s_registrationOpen == true){
            s_registrationOpen = false;
        }
        Game.participants = registeredAddresses;
    }


    ///////////////////////// REGISTRATION BLOCK
    
    address[] public registeredAddresses;
    mapping(address => bool) public isRegistered;

    // Registration of buyers => checks multi-registration
    function register() external {
        require(Event.s_registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(isRegistered[msg.sender] == false, "You have already registered!"); // ensure the person have not registered
        isRegistered[msg.sender] = true;
        registeredAddresses.push(msg.sender);
    }

    
}
