const { ethers } = require("hardhat");

async function main() {
  const contract = ethers.deployContract("Mint");
  (await contract).waitForDeployment();

  console.log("NFT Contract is ", (await contract).getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
