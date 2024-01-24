require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const ALCHEMY_API_KEY=process.env.SEPOLIA_KEY;
const SEPOLIA_PRIVATE_KEY=process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.9",
//   networks: {
//     hardhat: {
//       chainId: 1337,
//     },
//     goerli:{
//       url: GOERLI_URL,
//       accounts: [PRIVATE_KEY],
//     }
//   },
//   paths: {
//     artifacts: "./client/src/artifacts",
//   },
// };


module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: ALCHEMY_API_KEY,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  }
};