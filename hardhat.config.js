require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("dotenv").config()

const PRIVATE_KEY = process.env.PRIVATE_KEY
const FTM_MAINNET_RPC_URL = process.env.FTM_MAINNET_RPC_URL
const FTM_TESTNET_RPC_URL = process.env.FTM_TESTNET_RPC_URL
const FTMSCAN_API_KEY = process.env.FTMSCAN_API_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1,
            priceFeedAddress: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
        },
        localhost: {
            chainId: 31337,
            blockConfirmations: 1,
        },
        fantom: {
            url: FTM_MAINNET_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 250,
            blockConfirmations: 6,
            priceFeedAddress: "0xf4766552d15ae4d256ad41b6cf2933482b0680dc",
            // gasPrice: 22000000000, // you can modify the gas price according to the network state
        },
        fantomTestnet: {
            url: FTM_TESTNET_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 4002,
            blockConfirmations: 6,
            priceFeedAddress: "0xe04676B9A9A2973BCb0D1478b5E1E9098BBB7f3D",
        },
    },
    gasReporter: {
        enabled: false,
        currency: "USD",
        outputFile: "gas-report.txt",
        noColors: true,
        // coinmarketcap: COINMARKETCAP_API_KEY,
    },
    contractSizer: {
        runOnCompile: false,
        only: ["Raffle"],
    },
    solidity: {
        compilers: [
            { version: "0.8.19" },
            { version: "0.6.6" },
            { version: "0.4.19" },
            { version: "0.6.12" },
        ],
    },
    namedAccounts: {
        deployer: {
            default: 0, // here this will by default take the first account as deployer
            1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
        },
        player: {
            default: 1,
        },
    },
    etherscan: {
        // yarn hardhat verify --network <NETWORK> <CONTRACT_ADDRESS> <CONSTRUCTOR_PARAMETERS>
        apiKey: FTMSCAN_API_KEY,
        mocha: {
            timeout: 500000, // 500 seconds max
        },
    },
}
