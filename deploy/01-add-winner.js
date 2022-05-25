const hre = require("hardhat");

async function main() {

    const newLog = await ethers.getContractAt("contracts/eventLog.sol:EventLog", "0xDD65Cf1280C52A825B4997bC10E3ad688F6Feab3");
    const john = "0x93D76F2889061272CdAb3Ff11FB271BA979fFAd1";

    //await newLog._addWinner(1, john);
    //console.log("John successfully added");

    const isWinner = await newLog._isWinner(1, john);
    console.log("Is John a winner?", isWinner);

}

// Call the main function
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });