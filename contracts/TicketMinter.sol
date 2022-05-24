// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IeventLog {
    function _isWinner(uint256 _eventId, address _userAddress) external view returns (bool);
    function _getNumberOfTickets(uint256 _eventId) external view returns (uint256);
    function _getEventName(uint256 _eventId) external view returns (string memory);
}

contract TicketMinter is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public newTokenId;
    string public eventName;
    uint256 public numberOfTickets;
    uint256 public _eventId;

    constructor() ERC721("RockPaperTicket", "RPT"){
        newTokenId = 1;
    }

    function getEventData (address _eventAddress, uint256 _eventId) public {
        numberOfTickets = IeventLog(_eventAddress)._getNumberOfTickets(_eventId);
        eventName = IeventLog(_eventAddress)._getEventName(_eventId);
    }

    function mintTicket(string memory tokenURI, address _eventAddress, uint256 _eventId) public returns (uint256) {
        _tokenIds.increment();
        newTokenId = _tokenIds.current();
        require(newTokenId <= numberOfTickets, "All Tickets have been sold out!");
        //require(IeventLog(_eventAddress)._isWinner(_eventId, msg.sender) == true, "You are not qualified to receive a ticket.");
        require(balanceOf(msg.sender) == 0, 'Each player may only own one ticket');
        _setTokenURI(newTokenId, tokenURI);
        _safeMint(msg.sender, newTokenId);
        return newTokenId;
    }
}