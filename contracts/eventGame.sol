pragma solidity 0.8.4;

// This contract
// 1) can update the name and number of tickets of the event
// 3) allows any user to register to the event
// 4) allows the organizer to start the game

import "@openzeppelin/contracts/access/Ownable.sol";

interface eventLog {
    function _logEvent(
        string memory _eventName,
        address _eventGameAddress,
        address _eventOwner,
        uint32 _numberOfTickets,
        uint32 _ticketPrice
    ) external;
}

contract eventGame is Ownable {
    address public immutable s_logAddress;
    uint256 public s_numberOfTickets;
    bool public s_registrationOpen = true;
    address public immutable s_owner;

    address[] public s_registeredAddresses;
    mapping(address => bool) public s_isRegistered;

    address[] public s_winners;
    uint32[] groups;

    constructor(
        address _logAddress,
        uint256 _numberOfTickets,
        address _owner
    ) {
        s_logAddress = _logAddress;
        s_numberOfTickets = _numberOfTickets;
        s_owner = _owner;
    }

    enum play {
        Paper,
        Rock,
        Scissors
    }

    // updates the event details
    function updateEvent(
        string memory _newName,
        uint32 _newTickets,
        uint32 _newPrice
    ) external onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._logEvent(
            _newName,
            address(this),
            msg.sender,
            _newTickets,
            _newPrice
        );
        s_numberOfTickets = _newTickets;
    }

    // Registration of buyers => checks multi-registration
    function register() external {
        require(s_registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(
            s_isRegistered[msg.sender] == false,
            "You have already registered!"
        ); // ensure the person have not registered
        s_isRegistered[msg.sender] = true;
        s_registeredAddresses.push(msg.sender);
    }

    // stops registration and sets the participants of the game
    function startGame() public onlyOwner {
        _closeRegistration();
        if (s_registeredAddresses.length <= s_numberOfTickets) {
            s_winners = s_registeredAddresses;
        } else {
            _createGroups();
        }
    }

    function _closeRegistration() private {
        if (s_registrationOpen == true) {
            s_registrationOpen = false;
        }
    }

    // Create as many groups as numberOfTickets
    function _createGroups() private {
        uint256 rem = s_registeredAddresses.length % s_numberOfTickets;
        uint256 groupSize = (s_registeredAddresses.length - rem) /
            s_numberOfTickets;
        _createGroup(groupSize);
    }

    function _createGroup(uint256 groupSize) private {
        uint256 i = 0;
        uint256 j = groupSize - 1;
        //while(i < s_numberOfTickets){
        //    address[] memory group = s_registeredAddresses[i:j];
        //    groups.append(group);
        //    i = i + groupSize;
        //}
        //uint256[] memory lastGroup = s_registeredAddresses[s_numberOfTickets+1:s_registeredAddresses.length+1];
        //groups.append(lastGroup);
    }

    function _getAlgoPlay() public returns (uint32) {
        uint32 algoPlay;
        return algoPlay;
    }
}
