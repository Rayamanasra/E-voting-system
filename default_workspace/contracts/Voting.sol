// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract VotingContract {
    AccessControl public accessControl; // Reference to the AccessControl contract

    // Struct to represent a vote
    struct Vote {
        uint candidateId;
        address voter;
    }

    Vote[] public votes; // Array to store the votes

    // Event to notify when a vote is cast
    event VoteCast(uint indexed _candidateId, address indexed _voter);

    // Constructor to set the AccessControl contract address
    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    // Function to cast a vote
    function castVote(uint _candidateId) public {
        require(accessControl.voters(msg.sender), "Only registered voters can cast votes");
        require(_candidateId > 0 && _candidateId <= accessControl.getCandidateCount(), "Invalid candidate ID");

        votes.push(Vote(_candidateId, msg.sender));
        emit VoteCast(_candidateId, msg.sender);
    }

    // Function to get the total number of votes cast
    function getVoteCount() public view returns (uint) {
        return votes.length;
    }

    // Other functions for managing the voting process, calculating results, etc.
}
