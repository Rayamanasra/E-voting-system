// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract VoterRegistrationContract {
    AccessControl public accessControl; // Reference to the AccessControl contract

    // Event to notify when a voter is registered
    event VoterRegistered(address indexed _voter);

    // Modifier to ensure only registered voters can perform certain actions
    modifier onlyRegisteredVoter() {
        require(accessControl.voters(msg.sender), "Only registered voters can call this function");
        _;
    }

    // Constructor to set the AccessControl contract address
    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    // Function for voter registration
    function registerVoter() public {
        accessControl.registerVoter(msg.sender);
        emit VoterRegistered(msg.sender);
    }

    // Function to check if an address is a registered voter
    function isRegisteredVoter(address _voter) public view returns (bool) {
        return accessControl.voters(_voter);
    }
}
