// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const hre = require("hardhat");

async function main() {

    // DEPLOY LOG
    const EventLog = await hre.ethers.getContractFactory("contracts/eventLog.sol:EventLog");
    const eventLog = await EventLog.deploy();
    await eventLog.deployed();
    console.log("eventLog deployed to:", eventLog.address);

    // DEPLOY EVENTGAME
    //const EventGame = await hre.ethers.getContractFactory("EventGame");
    //const eventGame = await EventGame.deploy(eventLog.address, "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266", 0);
    //await eventGame.deployed();
    //console.log("eventGame deployed to:", eventGame.address);

    // DEPLOY FACTORY
    const EventFactory = await hre.ethers.getContractFactory("EventFactory");
    const eventFactory = await EventFactory.deploy(eventLog.address);
    await eventLog.deployed();
    console.log("eventFactory deployed to:", eventFactory.address);


    await eventFactory.createEventGame("test", "100", "10");

    const newEventAddress = await eventLog.getEventAddress(1)
    console.log("eventGame created at", newEventAddress);

    newEventGame = await ethers.getContractAt("EventGame", newEventAddress);
    const result = await newEventGame.test();
    console.log(result);

}

// Call the main function
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });