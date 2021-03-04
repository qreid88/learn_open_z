// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/access/Ownable.sol";


contract Box is Ownable {
    // uint256 is a large number to display a big number as a string 
    // (await box.retrieve()).toString()
    uint256 private value;

    // Emitted when the stored value changes
    event ValueChanged(uint256 newValue);

    // Stores a new value in the contract
    // the store function  receives an integer value and stores it in the contract storage.
    // store() function modifies the blockchain state
    // we need to send a transaction to the contract to execute the store()
    // in the truffle(development console) send a transation to call the store function:
    // await box.store(42)
    // store sends a transaction  with a transaction hash to report which costs Ether 
    function store(uint256 newValue) public onlyOwner {
        value = newValue;
        emit ValueChanged(newValue);
    }

    // Reads the last stored value
    // retrieve() returns the interger value stored in the contract 
    // this is a query of a blockchain state
    function retrieve() public view returns (uint256) {
        return value;
    }
}
