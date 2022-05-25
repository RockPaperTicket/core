pragma solidity 0.8.4;

// This contract
// 1) can update the name and number of tickets of the event
// 3) allows any user to register to the event
// 4) allows the organizer to start the game

interface EventLog {
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

    function _gameStart(uint256 _eventId) external;

    function _isWinner(uint256 _eventId, address _userAddress)
        external
        view
        returns (bool);
}

contract EventGame {
    // constant variables since the creation of the event
    address immutable s_logAddress;
    address immutable s_owner;
    uint256 immutable s_eventId;

    enum GameStatus {
        Registering,
        Started,
        Ended
    }

    GameStatus public status;

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

    modifier isRegistering() {
        require(status == GameStatus.Registering);
        _;
    }

    modifier isStarted() {
        require(status == GameStatus.Started);
        _;
    }

    modifier isEnded() {
        require(status == GameStatus.Ended);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    // registration and user-related variables
    address[] public s_registeredAddresses;
    mapping(address => bool) public s_isRegistered;
    mapping(address => UserScore) public scoreboard;
    struct UserScore {
        uint256 points;
        uint256 numberOfPlays;
        uint256 timeElapsed;
    }

    // game-related variables
    uint256 timeLimit;
    enum PossiblePlays {
        Rock,
        Paper,
        Scissors
    }

    // emission of events for each play result
    event result(
        address indexed gameAddress,
        address indexed player,
        string result,
        uint256 points
    );

    // updates the event details
    function updateName(string memory _newName) public onlyOwner isRegistering {
        EventLog log = EventLog(s_logAddress);
        log._updateName(s_eventId, _newName);
    }

    function updateTickets(uint256 _newTickets) public onlyOwner isRegistering {
        EventLog log = EventLog(s_logAddress);
        log._updateTickets(s_eventId, _newTickets);
    }

    function updatePrice(uint256 _newPrice) public onlyOwner isRegistering {
        EventLog log = EventLog(s_logAddress);
        log._updatePrice(s_eventId, _newPrice);
    }

    // Registration of buyers => checks multi-registration
    function register() public isRegistering {
        require(
            s_isRegistered[msg.sender] == false,
            "You have already registered!"
        ); // ensure the person have not registered
        UserScore memory initialUserScore = UserScore(0, 0, block.timestamp);
        scoreboard[msg.sender] = initialUserScore;
        s_registeredAddresses.push(msg.sender);
        s_isRegistered[msg.sender] = true;
        EventLog log = EventLog(s_logAddress);
        log._addRegisteredEvent(msg.sender, s_eventId);
    }

    function startGame() public isRegistering {
        status = GameStatus.Started;
        EventLog log = EventLog(s_logAddress);
        log._gameStart(s_eventId);
        timeLimit = block.timestamp + 1000000000000000;
        _createGroups();
    }

    function _createGroups() private {}

    function userPlay(uint256 _play) public isStarted {
        // its called by each user FE
        require(s_isRegistered[msg.sender] == true);
        require(scoreboard[msg.sender].numberOfPlays <= 5);
        require(block.timestamp < timeLimit);
        PossiblePlays algoPlay = _getAlgoPlay();
        if (PossiblePlays(_play) == algoPlay) {
            emit result(address(this), msg.sender, "draw", 1);
            scoreboard[msg.sender].points += 1;
        } else if (
            PossiblePlays(_play) == PossiblePlays(0) &&
            algoPlay == PossiblePlays(1)
        ) {
            emit result(address(this), msg.sender, "loss", 0);
        } else if (
            PossiblePlays(_play) == PossiblePlays(0) &&
            algoPlay == PossiblePlays(2)
        ) {
            emit result(address(this), msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        } else if (
            PossiblePlays(_play) == PossiblePlays(1) &&
            algoPlay == PossiblePlays(0)
        ) {
            emit result(address(this), msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        } else if (
            PossiblePlays(_play) == PossiblePlays(1) &&
            algoPlay == PossiblePlays(2)
        ) {
            emit result(address(this), msg.sender, "loss", 0);
        } else if (
            PossiblePlays(_play) == PossiblePlays(2) &&
            algoPlay == PossiblePlays(0)
        ) {
            emit result(address(this), msg.sender, "loss", 0);
        } else {
            emit result(address(this), msg.sender, "win", 3);
            scoreboard[msg.sender].points += 3;
        }
        scoreboard[msg.sender].numberOfPlays += 1;
        scoreboard[msg.sender].timeElapsed += block.timestamp;
    }

    function _getAlgoPlay() private pure returns (PossiblePlays) {
        uint256 randomNum = _getRandomNumber();
        PossiblePlays algoPlay = PossiblePlays(randomNum);
        return algoPlay;
    }

    function _getRandomNumber() private pure returns (uint256) {
        // chainlink VRF
        uint256 randomNumber = 0;
        return randomNumber;
    }

    function getScoreboard() public view returns (UserScore memory) {
        return scoreboard[msg.sender];
    }

    function endGame() public {
        status = GameStatus.Ended;
    }

    function isWinner(address _userAddress)
        external
        view
        isEnded
        returns (bool)
    {
        EventLog log = EventLog(s_logAddress);
        return log._isWinner(s_eventId, _userAddress);
    }
}
