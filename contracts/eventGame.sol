pragma solidity 0.8.4;

// This contract
// 1) can update the name and number of tickets of the event
// 3) allows any user to register to the event
// 4) allows the organizer to start the game

interface eventLog {
    function _logEvent(
        uint256 _eventId,
        address _eventGameAddress,
        address _eventOwner,
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external;

    function _addWinner(uint256 _eventId, address _winner) external;

    function _updateName(uint256 _eventId, string memory _newName) external;

    function _updateTickets(uint256 _eventId, uint256 _newTickets) external;

    function _updatePrice(uint256 _eventId, uint256 _newPrice) external;

    function _closeEvent(uint256 _eventId) external;

    function _addRegisteredEvent(address _userAddress, uint256 _eventId)
        external;

    function _addCreatedEvent(address _userAddress, uint256 _eventId) external;
}

contract EventGame {
    // constant variables since the creation of the event
    address immutable s_logAddress;
    address immutable s_owner;
    uint256 immutable s_eventId;

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    // constructor that defines all variables described above
    constructor(
        address _logAddress,
        address _owner,
        uint256 _eventId
    ) {
        // definition of constant variables
        s_logAddress = _logAddress;
        s_owner = _owner;
        s_eventId = _eventId;
    }

    // registration and user-related variables
    bool s_registrationOpen = true;
    address[] public s_registeredAddresses;
    mapping(address => bool) public s_isRegistered;
    mapping(address => userScore) scoreboard;
    struct userScore {
        uint256 points;
        uint256 numberOfPlays;
        uint256 timeElapsed;
    }

    // game-related variables
    enum possiblePlays {
        paper,
        rock,
        scissors
    }

    // emission of events for each play result
    event result(address player, string result, uint256 points);

    // updates the event details

    function test() public view onlyOwner returns (string memory) {
        return "hello";
    }

    function updateName(string memory _newName) public onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._updateName(s_eventId, _newName);
    }

    function updateTickets(uint256 _newTickets) public onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._updateTickets(s_eventId, _newTickets);
    }

    function updatePrice(uint256 _newPrice) public onlyOwner {
        eventLog log = eventLog(s_logAddress);
        log._updatePrice(s_eventId, _newPrice);
    }

    // Registration of buyers => checks multi-registration
    function register() public {
        require(s_registrationOpen == true, "Registration not open yet!"); // ensure registration is open
        require(
            s_isRegistered[msg.sender] == false,
            "You have already registered!"
        ); // ensure the person have not registered
        userScore memory initialUserScore = userScore(0, 0, block.timestamp);
        scoreboard[msg.sender] = initialUserScore;
        s_registeredAddresses.push(msg.sender);
        s_isRegistered[msg.sender] = true;
        eventLog log = eventLog(s_logAddress);
        log._addRegisteredEvent(msg.sender, s_eventId);
    }

    function startGame() public {
        _closeRegistration;
        _createGroups;
    }

    function _closeRegistration() private {
        if (s_registrationOpen == true) {
            s_registrationOpen = false;
        }
        eventLog log = eventLog(s_logAddress);
        log._closeEvent(s_eventId);
    }

    function _createGroups() private {}

    function userPlay(uint256 _play) public {
        require(s_isRegistered[msg.sender] == true);
        require(scoreboard[msg.sender].numberOfPlays <= 5);
        possiblePlays algoPlay = _getAlgoPlay();
        if (possiblePlays(_play) == algoPlay) {
            emit result(msg.sender, "draw", 1);
            scoreboard[msg.sender].points += 1;
        } else if (
            possiblePlays(_play) == possiblePlays(0) &&
            algoPlay == possiblePlays(1)
        ) {
            emit result(msg.sender, "loss", 0);
        } else if (
            possiblePlays(_play) == possiblePlays(0) &&
            algoPlay == possiblePlays(2)
        ) {
            emit result(msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        } else if (
            possiblePlays(_play) == possiblePlays(1) &&
            algoPlay == possiblePlays(0)
        ) {
            emit result(msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        } else if (
            possiblePlays(_play) == possiblePlays(1) &&
            algoPlay == possiblePlays(2)
        ) {
            emit result(msg.sender, "loss", 0);
        } else if (
            possiblePlays(_play) == possiblePlays(2) &&
            algoPlay == possiblePlays(0)
        ) {
            emit result(msg.sender, "loss", 0);
        } else {
            emit result(msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        }
        scoreboard[msg.sender].numberOfPlays += 1;
        scoreboard[msg.sender].timeElapsed += block.timestamp;
    }

    function _getAlgoPlay() private pure returns (possiblePlays) {
        uint256 randomNum = _getRandomNumber();
        possiblePlays algoPlay = possiblePlays(randomNum);
        return algoPlay;
    }

    function _getRandomNumber() private pure returns (uint256) {
        // chainlink VRF
        uint256 randomNumber = 0;
        return randomNumber;
    }
}
