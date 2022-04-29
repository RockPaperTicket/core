pragma solidity ^0.8.7;

// This contract deploys a gameEvent contract with a set number of tickets

contract eventGameFactory {
    // array with the addresses of deployed event games
    eventGame[] public s_eventGames;

    function createEventGame(uint32 _numberOfTickets) external returns (bool) {
        eventGame eventgame = new eventGame(_numberOfTickets);
        s_eventGames.push(eventgame);
        // should we emit an event to know what address created the game?
        return true;
    }
}
