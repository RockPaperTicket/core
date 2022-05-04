pragma solidity ^0.8.7;

// This contract
// 1) sets the event name and tickets, and allows update
// 2) allows the organizer to open and close registration to the event
// 3) allows any user to register to the event, preventint double entries
// 4) allows the organizer to start the game 

contract eventGame {
    
    // Definition of the event
    address immutable s_owner;
    struct Event {
        string eventName;
        uint32 numerOfTickets;
        bool registrationOpen = false; //registration closed/open
    }

    struct Game {
        address[] winners; // array that stores all the winners (allowed to mint tickets)
        address[] participants;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(string _eventName, uint32 _numberOfTickets) {
        Event.numerOfTickets = _numberOfTickets;
        Event.eventName = _eventName; 
        owner = msg.sender;
    }


    ///////////////////////// EVENT BLOCK

    function updateName(string _updatedName) external onlyOwner {
        Event.eventName = _eventName;
    }

    function updateTickets(uint32 _updatedTickets) external onlyOwner {
        Event.numberOfTickets = _updatedTickets;
    }

    function startRegistration() external onlyOwner {
        Event.registrationOpen = true;
    }

    function closeRegistration() external onlyOwner {
        Event.registrationOpen = false;
    }

    function startGame() public onlyOwner {
        if (Event.registrationOpen == true){
            Event.registrationOpen = false;
        }
        Game.participants = registeredAddress;
    }


    ///////////////////////// REGISTRATION BLOCK
    
    address[] public registeredAddresses;
    mapping(address => bool) public isRegistered;

    // Registration of buyers => checks multi-registration
    function register() external {
        require(Event.registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(isRegistered[msg.sender] == false, "You have already registered!"); // ensure the person have not registered
        isRegistered[msg.sender] = true;
        registeredAddresses.push(msg.sender);
        // emit event?
    }

    
}
