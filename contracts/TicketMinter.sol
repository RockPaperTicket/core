// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface IeventGame {
    function _isWinner(uint256 _eventId, address _userAddress) external view returns (bool);
    function getNumberOfTickets(uint256 _eventId) external view returns (uint256);
    function getEventName(uint256 _eventId) external view returns (string memory);
    function _eventId() external view returns (uint256);
}

contract TicketMinter is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;
    uint256 public newTokenId;
    string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='purple' /><text x='50%' y='30%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string baseSvg2 = "<text x='20%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string baseSvg3 = "<text x='80%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    constructor() ERC721("RockPaperTicket", "RPT"){
        _tokenIds.increment();
    }

    //instead of eventLog address, I simply pass in eventaddress
    function mintTicket(address _eventAddress, uint256 _eventId) public {
        
        //set new tokenID
        newTokenId = _tokenIds.current();

        // access necessary information for the ticket
        //uint256 _eventId = IeventGame(_eventAddress)._eventId();
        uint256 numberOfTickets = IeventGame(_eventAddress).getNumberOfTickets(_eventId);
        string memory eventName = IeventGame(_eventAddress).getEventName(_eventId);

        //check all requirements
        require(newTokenId <= numberOfTickets, "All Tickets have been sold out!");
        require(IeventGame(_eventAddress)._isWinner(_eventId ,msg.sender) == true, "You are not qualified to receive a ticket.");
        //require(balanceOf(msg.sender) == 0, 'Each player may only own one ticket');

        //define finalSVG name
        string memory finalSvg = string(abi.encodePacked(baseSvg1, eventName, "</text>", baseSvg2, newTokenId.toString(), "</text>", baseSvg3, numberOfTickets.toString(), "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',eventName,'", "description": "This is your unique ticket for the event!", "image": "data:image/svg+xml;base64,',Base64.encode(bytes(finalSvg)),'"}'
                    )
                )     
            )
        );

        //define finalTokenURI
        string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
        );

        //mint the token
        _safeMint(msg.sender, newTokenId);

        //set the final tokenURI
        _setTokenURI(newTokenId, finalTokenUri);

        //increment the tokenID
        _tokenIds.increment();
    }
}