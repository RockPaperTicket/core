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
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external;    
    function _addWinner (string calldata _eventName, address _winner) external;
}

contract eventGame is Ownable {

    // event-related variables
    struct Event {
        address eventGameAddress;
        address eventOwner;
        uint256 numberOfTickets;
        uint256 ticketPrice;
    }
    address immutable s_logAddress;
    uint256 s_numberOfTickets;
    bool s_registrationOpen = true;
    address immutable s_owner;
    string s_eventName;

    // user-related variables
    address[] public s_registeredAddresses;
    mapping(address => bool) public s_isRegistered;
    mapping(address => userScore) scoreboard;
    struct userScore {
        uint256 points ;
        uint256 numberOfPlays;
        uint256 timeElapsed;
    }

    // game-related variables
    enum possiblePlays {paper, rock, scissors}
    event result (address player, string result, uint256 points);


    constructor(string memory _eventName, address _logAddress, uint256 _numberOfTickets, address _owner) {
        s_eventName = _eventName;
        s_logAddress = _logAddress;
        s_numberOfTickets = _numberOfTickets;
        s_owner = _owner;
    }

    // updates the event details
    function updateEvent(string memory _newName, uint32 _newTickets, uint32 _newPrice) external onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._logEvent (_newName, address(this), msg.sender, _newTickets, _newPrice);
        s_numberOfTickets = _newTickets;
    }


    // Registration of buyers => checks multi-registration
    function register() external {
        require(s_registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(s_isRegistered[msg.sender] == false, "You have already registered!"); // ensure the person have not registered
        userScore memory initialUserScore = userScore(0,0, block.timestamp);
        scoreboard[msg.sender] = initialUserScore;
        s_registeredAddresses.push(msg.sender);
        s_isRegistered[msg.sender] = true;
    }

    function _closeRegistration() private {
        if (s_registrationOpen == true){
            s_registrationOpen = false;
        }
    }
    
    function userPlay (uint256 _play) public {
        require(s_isRegistered[msg.sender] == true);
        require (scoreboard[msg.sender].numberOfPlays <= 5);
        possiblePlays algoPlay = _getAlgoPlay();
        if (possiblePlays(_play) == algoPlay){
            emit result (msg.sender, "draw", 1);
            scoreboard[msg.sender].points += 1;
        }
        else if (possiblePlays(_play) == possiblePlays(0) && algoPlay == possiblePlays(1)){
            emit result (msg.sender, "loss", 0);
        }
        else if (possiblePlays(_play) == possiblePlays(0) && algoPlay == possiblePlays(2)){
            emit result (msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        }
        else if (possiblePlays(_play) == possiblePlays(1) && algoPlay == possiblePlays(0)){
            emit result (msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        }
        else if (possiblePlays(_play) == possiblePlays(1) && algoPlay == possiblePlays(2)){
            emit result (msg.sender, "loss", 0);
        }
        else if (possiblePlays(_play) == possiblePlays(2) && algoPlay == possiblePlays(0)){
            emit result (msg.sender, "loss", 0);
        }
        else {
            emit result (msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        }
        scoreboard[msg.sender].numberOfPlays += 1;
        scoreboard[msg.sender].timeElapsed += block.timestamp;
    }

    function _getAlgoPlay() private pure returns (possiblePlays){
        uint256 randomNum = _getRandomNumber();
        possiblePlays algoPlay = possiblePlays(randomNum);
        return algoPlay;
    }

    function _getRandomNumber() private pure returns (uint256){
        // chainlink VRF
        uint256 randomNumber = 0;
        return randomNumber;
    }

}