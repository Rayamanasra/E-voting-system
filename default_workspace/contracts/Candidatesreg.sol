// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract CandidateRegistrationContract {
    AccessControl public accessControl; // Reference to the AccessControl contract

    // Event to notify when a candidate is registered
    event CandidateRegistered(uint indexed _id, string _name);

    // Modifier to ensure only registered voters can perform certain actions
    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "Only admin can call this function");
        _;
    }

    // Constructor to set the AccessControl contract address
    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    // Function for candidate registration
    function registerCandidate(string memory _name) public onlyAdmin {
        uint candidateId = accessControl.addCandidate(_name);
        emit CandidateRegistered(candidateId, _name);
    }
}
