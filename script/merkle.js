const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const addresses = [
  ];

  const leafNodes = addresses.map((addr) => keccak256(addr));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
  const rootHash = merkleTree.getHexRoot();

  console.log("Merkle Tree \n", merkleTree.toString());
  console.log("Root Hash\n\t", rootHash.toString());
  console.log(
    addresses[0],
    "'s Proof\n\t",
    merkleTree.getHexProof(keccak256(addresses[0]))
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});