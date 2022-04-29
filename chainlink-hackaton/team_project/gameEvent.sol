pragma solidity ^0.8.7;

// This contract
// 1) sets the number of tickets available for he event
// 2) allows any user to register to the event

contract eventGame {
    // Initialize the contract with the number of tickets
    uint32 s_numerOfTickets;

    constructor(uint32 _numberOfTickets) {
        s_numerOfTickets = _numberOfTickets;
    }

    // Then create an address array of size s_numerOfTickets
    address[s_numerOfTickets] s_availableTickets;

    // address storing all the people registered + address to avoid multi-registration
    address[] public registeredAddresses;
    mapping(address => bool) public isRegistered;

    function register() public returns (bool) {
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
}
