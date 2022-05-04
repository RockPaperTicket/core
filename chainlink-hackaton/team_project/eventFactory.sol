pragma solidity ^0.8.7;

// This contract deploys an eventGame contract with a set number of tickets

import "./event.sol";

contract eventFactory is eventGame {
    // array with the addresses of deployed event games
    eventGame[] public s_eventGames;

    function createEventGame(string memory _eventName, uint32 _numberOfTickets)
        external
    {
        eventGame EventGame = new eventGame(_eventName, _numberOfTickets);
        s_eventGames.push(EventGame);
    }
}
