pragma solidity ^0.8.7;

// This contract
// 1) sets the number of tickets available for he event
// 2) allows the organizer to update the available tickets
// 3) allows any user to register to the event

contract gameEvent {
    // array that stores all the winners (allowed to mint tickets)
    address[] s_winners;
    uint32 s_numerOfTickets;
    address immutable owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(uint32 _numberOfTickets) {
        s_numerOfTickets = _numberOfTickets;
        owner = msg.sender;
    }

    // Update number of tickets if necessary
    function updateTickets(uint32 _updatedTickets)
        external
        onlyOwner
        returns (bool)
    {
        s_numberOfTickets = _updatedTickets;
        return true;
    }

    // Registration of buyers => checks multi-registration
    address[] public registeredAddresses;
    mapping(address => bool) public isRegistered;

    function register() external returns (bool) {
        // ensure the person have not registered
        require(
            isRegistered[msg.sender] == false,
            "You have already registered!"
        );
        isRegistered[msg.sender] = true;
        registeredAddresses.push(msg.sender);
        // emit event?
        return true;
    }

    function startGame() public onlyOwner returns (bool) {
        // should be owner or us¿ TBD
        address[] storage s_participants = registeredAddress;
        return true;
    }
}
