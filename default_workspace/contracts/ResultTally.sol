// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract ResultTallyContract {
    AccessControl public accessControl; // Reference to the AccessControl contract

    // Struct to represent the result of an election
    struct ElectionResult {
        uint[] candidateIds;
        uint[] voteCounts;
        bool finalized;
    }

    ElectionResult public electionResult; // Variable to store the result of the election

    // Event to notify when the election result is finalized
    event ElectionResultFinalized(uint[] _candidateIds, uint[] _voteCounts);

    // Modifier to ensure only admin can perform certain actions
    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "Only admin can call this function");
        _;
    }

    // Constructor to set the AccessControl contract address
    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    // Function to finalize the election result
    function finalizeResult() public onlyAdmin {
        require(!electionResult.finalized, "Result has already been finalized");

        uint candidateCount = accessControl.getCandidateCount();
        electionResult.candidateIds = new uint[](candidateCount);
        electionResult.voteCounts = new uint[](candidateCount);

        for (uint i = 0; i < candidateCount; i++) {
            electionResult.candidateIds[i] = i + 1;
            electionResult.voteCounts[i] = accessControl.getVoteCountForCandidate(i + 1);
        }

        electionResult.finalized = true;
        emit ElectionResultFinalized(electionResult.candidateIds, electionResult.voteCounts);
    }
}
