pragma solidity ^0.8.7;

// This contract
// 1) can update the name and number of tickets of the event
// 3) allows any user to register to the event
// 4) allows the organizer to start the game

import "@openzeppelin/contracts/access/Ownable.sol";

interface eventLog {
    _logEvent(string memory _eventName, address _eventGameAddress, address _eventOwner, uint32 _numberOfTickets, uint32 _ticketPrice){
}

contract eventGame {

    address public s_logAddress;
    address immutable s_owner;
    bool s_registrationOpen = false;

    address[] public s_registeredAddresses;
    mapping(address => bool) public s_isRegistered;


    struct Game {
        address[] winners; //winners of the game (people who can mint tickets)
        address[] participants;
    }

    constructor(address _logAddress) {
        s_logAddress = _logAddress;
    }


    // updates the event details
    function updateEvent(string memory _newName, uint32 _newTickets, uint32 _newPrice) external onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._logEvent (_newName, address(this), msg.sender, _newTickets, _newPrice);
    }

    // stops registration and sets the participants of the game
    function startGame() public onlyOwner {
        if (s_registrationOpen == true){
            s_registrationOpen = false;
        }
        Game.participants = registeredAddresses;
    }

    // Registration of buyers => checks multi-registration
    function register() external {
        require(Event.s_registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(s_isRegistered[msg.sender] == false, "You have already registered!"); // ensure the person have not registered
        s_isRegistered[msg.sender] = true;
        s_registeredAddresses.push(msg.sender);
    }

    
}