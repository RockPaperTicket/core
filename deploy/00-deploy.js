// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

//eventLog deployed to: 0xDD65Cf1280C52A825B4997bC10E3ad688F6Feab3
//eventFactory deployed to: 0x8968d23FB3D852cB110BF6c38cbfCE299BE757FD
//eventGame created at 0x67F7afEE5858BB10f562833009B73A763C3Fb974

const hre = require("hardhat");

async function main() {

    // DEPLOY LOG
    const EventLog = await hre.ethers.getContractFactory("contracts/eventLog.sol:EventLog");
    const eventLog = await EventLog.deploy();
    await eventLog.deployed();
    console.log("eventLog deployed to:", eventLog.address);

    // DEPLOY FACTORY
    const EventFactory = await hre.ethers.getContractFactory("EventFactory");
    const eventFactory = await EventFactory.deploy(eventLog.address);
    await eventLog.deployed();
    console.log("eventFactory deployed to:", eventFactory.address);


    await eventFactory.createEventGame("test", "100", "10");

    const newEventAddress = await eventLog.getEventAddress(1)
    console.log("eventGame created at", newEventAddress);

    newEventGame = await ethers.getContractAt("EventGame", newEventAddress);

    const eventName = await eventLog._getEventName(1);
    console.log("event name is", eventName);

    const numberOfTickets = await eventLog._getNumberOfTickets(1);
    console.log("number of tickets is", numberOfTickets);

    const isWinner = await eventLog._isWinner(1, "0x5FbDB2315678afecb367f032d93F642f64180aa3");
    console.log(isWinner)

}

// Call the main function
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });