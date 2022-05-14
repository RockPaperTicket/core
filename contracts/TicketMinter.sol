// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketMinter is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters
    uint256 public maxSupply; //global variable, any function in the contract can call this.
    string public eventName;
    mapping(address => bool) winnersAddresses;
    uint256 public newTokenId;

    constructor(uint256 _maxSupply, string memory _eventName)
        ERC721("RockPaperTicket", "RPT")
    {
        maxSupply = _maxSupply; //check ER721 contract
        eventName = _eventName;
    }

    function addWinner(address[] memory _winnersAddresses) public onlyOwner{
        for (uint i = 0; i < _winnersAddresses.length; i++) {
            winnersAddresses[_winnersAddresses[i]] = true;
        }
    }

    function mintTicket(string memory tokenURI) public returns (uint256) {
        // utilise Counters
        //local variable, only this function can call it
        _tokenIds.increment();
        newTokenId = _tokenIds.current();
        require(newTokenId <= maxSupply, "All Tickets have been sold out!");
        if (winnersAddresses[msg.sender] == true) { //maybe use view?? Add a pay function. 
            _safeMint(msg.sender, newTokenId);
            _setTokenURI(newTokenId, tokenURI);
            return newTokenId;
        } else {
            revert("You are not qualified to receive a ticket.");
        require(balanceOf(msg.sender) == 0, 'Each player may only own one ticket');
        }
    }
}