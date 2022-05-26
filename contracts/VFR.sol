// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity 0.8.4;

// we need to request a random number from this contract
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// we also need some functionalities from this contract
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract VRF is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface immutable i_vrfCoordinator; // "i_" to remind it's an immutable variable

    address constant VRF_COORDINATOR =
        0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 constant GAS_LANE =
        0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc; // =keyHash --> max gas price willing to pay for the request
    uint64 constant SUBSCRIPTION_ID = 4894;
    uint32 constant CALLBACK_GAS_LIMIT = 100000; // max gas amoung willing to pay to receive the number
    uint16 constant REQUEST_CONFIRMATIONS = 3; // how many confirmationts we want to wait to consider the transaction completed
    uint32 constant NUM_WORDS = 5; // number of values that we want to get
    uint256 constant MAX_VALUE = 2; // maximum value we want to get

    //variables no definides en aquest contracte:
    uint256[] s_randomWords;
    uint256 public s_requestId;

    constructor() VRFConsumerBaseV2(VRF_COORDINATOR) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(VRF_COORDINATOR);
    }

    function requestRandomWords() external {
        s_requestId = i_vrfCoordinator.requestRandomWords(
            GAS_LANE,
            SUBSCRIPTION_ID,
            REQUEST_CONFIRMATIONS,
            CALLBACK_GAS_LIMIT,
            NUM_WORDS
        );
    }

    // will provide an array of random values
    function fulfillRandomWords(uint256, uint256[] memory randomWords)
        internal
        override
    {
        for (uint256 i = 0; i < MAX_VALUE; i++) {
            s_randomWords[i] = randomWords[i] % MAX_VALUE; // we will get a number between 0-2
        }
    }

    function _getRandomNumber(uint256 _playId) external view returns (uint256) {
        return s_randomWords[_playId];
    }
}
