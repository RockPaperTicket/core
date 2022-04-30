// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract CertificatesCollection is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters
    
    constructor() public ERC721("TBD", "TBD"){
    }

    function mintTicket(string memory tokenURI) public returns (uint256){
        // utilise Counters
        uint256 newTokenId = _tokenIds.current();        // *** Move _setTokenUri before _safeMint
        // *** Execute _safeMint at the end to follow 
        // *** Check-Effect-Interaction pattern
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _tokenIds.increment();
        return newTokenId;
    }
}