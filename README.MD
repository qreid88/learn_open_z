# SETTING UP AN OPENZEPPLIN PROJECT

## Docs
    https://docs.openzeppelin.com/contracts/3.x/
    https://docs.openzeppelin.com/contracts/3.x/access-control
    https://docs.openzeppelin.com/learn/connecting-to-public-test-networks

## Installation
 https://nodejs.org/en/download/
 mkdir learn && cd learn
 npm init -y
 truffle init
 npx truffle init
 ### create an empty truffle project
 npm install --save-dev truffle
 ### initialize truffle
 npx truffle init

## First Contract
 Solidity source code (.sol)
📦contracts directory is equivalent to the 📦src directory 
 
## create the following 
📦contracts
 ┣ 📂access-control
 ┃ ┗ 📜Auth.sol
 ┣ 📜Box.sol
 ┗ 📜Migrations.sol

 ### Box.sol
    Box.sol will let people store a value that can be later retrieved 

## Truffle-config.js
    The Ethereum Virtual Machine (EVM) cannot execute Solidity code directly: we first need to compile it into EVM bytecode.

    we specify our version in our truffle-config.js

### Compiling 
    npx truffle compile

    - the compile command will automatically look for all contracts in the 📦contracts and compile them using the Solidity compiler using the 📜truffle-config.js 

#### build/contracts
build/contracts holds the compiled artifacts (bytecode and metadata in .json files
also add a .gitignore directory

📦build
 ┗ 📂contracts
 ┃ ┣ 📜Auth.json
 ┃ ┣ 📜Box.json
 ┃ ┗ 📜Migrations.json

### Adding more Contracts
Each contract that you add to your project stored in its own 📜.sol 

# Using OpenZeppelin Contracts
OpenZeppelin contains reusable modules and libraries for smart contracts that are audited and battle-tested

### inheritance 
The contracts in the OpenZeppelin library are a starting point to **build your own** smart contracts by adding features
**Multiple Inheritance** - Solidity 
Multiple Inheritance [Solidity](https://docs.soliditylang.org/en/latest/contracts.html#inheritance)

For example, the Ownable contract marks the deployer account as the contract’s owner, and provides a modifier called onlyOwner. When applied to a function, onlyOwner will cause all function calls that do not originate from the owner account to revert. Functions to transfer and renounce ownership are also available.

When used this way, inheritance becomes a powerful mechanism that allows for modularization, without forcing you to deploy and manage multiple contracts.

# Importing OpenZeppelin Contracts
$ npm install --save-dev @openzeppelin/contracts

To use one of the OpenZeppelin Contracts, import it by prefixing its path with @openzeppelin/contracts reference Box.sol line 6     

# Deploying 
   **Smart Contracts** do not run on a computer or someones server: they **live on the Ethereum network** itself

## Setting up a local blockchain 
The **Ethereum blockchain** is called **mainnet** and requires spending real money to use it in the form of **Ether** 

**Test networks** such as Ropsten,Rinkeby, Kovan and Goerli blockchains work simiar to mainnet but let you get test ether for free. You will still deal with private key management, blocktimes (5 to 20 seconds) 

**local blockchains** run on your machine and requires no internet 

### Ganache local blockchain 
npm install --save-dev ganache-cli

Ganache will create a random set of unlocked accounts and give them Ether. In order to get the same addresses that will be used in this guide, you can start Ganache in deterministic mode

in a new terminal window run the following command: 

npx ganache-cli --deterministic

it will display its address, which we’ll use to connect to it. By default, this will be 127.0.0.1:8545.
Every time you run Ganache it will create a brand new local blockchain.

## Deploying a smart contract 

Truffle uses migrations to deploy contracts. 

📦migrations
 ┣ 📜1_initial_migration.js
 ┗ 📜2_deploy.js

**Migrations** consist of JavaScript files and a special Migrations contract to track migrations on-chain

### Configure connection to ganache 
Inside our 📜truffle-config.js

We need to add a development network for localhost and port 8545 which is what our local blockchain is using. 

#### Migrate command 
Using the migrate command we can deploy the 📜Box.sol contract to the development network ganache 

Open a third terminal and run the following command:

npx truffle migrate --network development

> Truffle will keep track of your deployed contracts, but it also displays their addresses when deploying (in our example, 0xCfEB869F69431e42cdB54A4F4f105C19C080A601). These values will be useful when interacting with them programmatically.

> **if you close this process you will have to redeploy your contract** 

## Interacting from the console 

We will use the Truffle console to interact with our deployed Box contract on our local development network.

npx truffle console --network development

inside the truffle development console type in the box variable  
truffle(development)> box = await Box.deployed()

### Sending transactions 

#### store() function
The **store() function** inside our Box.sol contract **receives an integer value and stores it** in the contract storage. Because this function modifies the blockchain state, we need to send a transaction to the contract to execute it.

inside our truffle(development)> console we will send a transaction to call the store function with a numeric value:

await box.store(42)

this transaction receipt shows that Box emitted a ValueChanged event 
    event: 'ValueChanged',

> store sends a transaction  with a transaction hash to report which costs Ether 

### Querying state 

#### retrieve() function

The **retrieve()** in our Box.sol is a query of blockchain state so we dont send it a transaction 

Box has a **retrieve()** function **returns an integer value stored in the contract** 

await box.retrieve()

> Queries only return state and do not cost either 

#### uint256 

> Our Box contract returns uint256 which is too large a number for JavaScript so instead we get returned a big number object.

inside our truffle(development)> we can display the big number as a string using 

(await box.retrieve()).toString()

### Interacting programmatically

The console is useful for prototyping and running one-off queries or transactions. However, eventually you will want to interact with your contracts from your own code.

📦scripts
 ┗ 📜index.js

inside a new terminal run the following command  to check we are getting a list of available accounts in response 

npx truffle exec --network development ./scripts/index.js

> this should match the accounts inside your local blockchain you created with the npx ganache-cli --deterministic

### Getting a constant instance 
📦scripts
 ┗ 📜index.js
To interact with the Box.sol contract we deployed we use the **Truffle contract abstraction**

https://www.trufflesuite.com/docs/truffle/reference/contract-abstractions

>To obtain a contract abstraction you can require it with the contract name from the artifacts object
> Outside of the console this is an object available in migration files, tests, and exec scripts.

inside the 📜index.js file:
**const MyContract = artifacts.require("MyContract");**
const Box = artifacts.require("Box");

>Contract abstractions in the truffle(development)> console :
inside the development console 
**const myContract = await MyContract.deployed()**
const box = await Box.deployed();

>Command if you need to redeploy to the development network (Ganache):
npx truffle migrate --network development

### Sending a transaction 
📦scripts
 ┗ 📜index.js

 > In a real-world application, you may want to estimate the gas of your transactions, and check a gas price oracle to know the optimal values to use on every transaction.

to check a snippet:

npx truffle exec --network development ./scripts/index.js

### So far you are able to 
[x] set up a local blockchain
[x] deploy contracts
[x] interact with the contracts manually and programmatically 

what is next ?

[] Setting up a Testing Environment 
[] Writing Unit Tests
[] Preforming Complex Assertions
[] Using the OpenZeppelin Test Environment 

# Writing Automated Smart Contracts 

 > A single mistake can cause you to lose your funds, you will need to write automated tests that verify your application.

## About testing 
- simple manual verifications (https://docs.openzeppelin.com/learn/deploying-and-interacting#interacting-from-the-console)
- end-to-end setups
- unit testing (https://en.wikipedia.org/wiki/Unit_testing)

**Smart Contract Unit Testing** 
- small focused tests that check a small part of your contracts correctness
- They can often be expressed in single sentences that make up a specification, such as 'the admin is able to pause the contract', 'transferring tokens emits an event' or 'non-admins cannot mint new tokens'.

### Setting up a testing environment 
- we will use a **local blockchain** 

Writing unit tests 
- we will use Chai assertions 

npm install --save-dev chai

📦test
 ┗ 📜.gitkeep
 - test files will go in the test directory
- structure tests by mirroring the contracts directory 
- for every .sol file create a test file 

📦test
 ┣ 📜.gitkeep
 ┣ 📜Box.test.js
 ┗ 📜Migration.test.js

our Box.test.js will test will test properties of the Box contract from previous guides: a simple contract that lets you retrieve a value the owner previously store d.

#### Compiling your truffle tests 
npx truffle test 

this will execute all tests in the tests directory 

https://circleci.com/
make your tests run automatically every time you commit your code to github

## Preforming Complex Assertions 
OpenZeppelin Test Helpers
https://docs.openzeppelin.com/test-helpers/0.5/

simplify the task of simulating time passing on the blockchain and handling very large numbers 

npm install --save-dev @openzeppelin/test-helpers

📜Box.test.js
- this tests if the properties of the Ownable Box contract lets you retrive a value the owner previously stored 

### OpenZeppelin Test Environment 
Test Environments uses ganache under the hood


npm install --save-dev @openzeppelin/test-environment

to run tests you need  a test runner 

npm install --save-dev mocha chai

reference our Box.test.js

**Recompile your contract** 
truffle compile && mocha --exit --recursive

## Connecting to public test networks 

### What test networks are available 
    - Rapsten - proof of work testnet with unpredictable block times and frequent chain reorganizations 
    - Rinkeby - proof-of-authority network. new blocks are added by a set of pre-defined trusted nodes
    - Kovan - proof-of-authority network runs with OpenEthereum clients
    - Goerli - proof-of-authrity - compatible with geth and OpenEthereum clients 

### how to set up your project for working on a testnet
The easiest way to acess a public node
A public node accessed by the general public can reply to queries and relay signed transactions but cannot sign transactions on its own

Alchemy
https://alchemyapi.io/

Infura
https://infura.io/

#### Creating a new account

to send transactions to the test net you need an Ethereum account 

we will use the mnemonics package 

npx mnemonics

keep mnemonic secure do not commit to version control even for testing 

#### Configuring your network

we are making public nodes so we need to sign all transactions locally.
we will configure the network with our mnemonic and Alchemy endpoint 

install the truffle hdwallet 

npm install --save-dev @truffle/hdwallet-provider

### how to deploy and interact with your testnet contract instances 









