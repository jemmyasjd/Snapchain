const hre=require("hardhat");

async function main() {
    const SnapChain = await hre.ethers.getContractFactory("SnapChain");
 
    // Start deployment, returning a promise that resolves to a contract object
    const snapchain = await SnapChain.deploy("SnapChain");   
    console.log("Contract deployed to address:", snapchain.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });