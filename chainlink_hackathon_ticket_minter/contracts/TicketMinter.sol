// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TicketMinter is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters
    uint256 public maxSupply; //global variable, any function in the contract can call this.
    string public eventName;
    uint256 public newTokenId;

    constructor(uint256 _maxSupply, string memory _eventName) public ERC721("TBD", "TBD"){
        maxSupply = _maxSupply; //check ER721 contract
        eventName = _eventName;
    }

    function mintTicket(string memory tokenURI) public returns (uint256){
        // utilise Counters
         //local variable, only this function can call it
        require(newTokenId <= maxSupply, "Not enough NFTs!");
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _tokenIds.increment();
        return newTokenId;
    }
}