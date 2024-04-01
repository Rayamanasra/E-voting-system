// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    address public admin; // The address of the administrator

    // Mapping to store whether an address has admin privileges
    mapping(address => bool) public isAdmin;

    // Mapping to store candidate names by their IDs
    mapping(uint => string) public candidates;

    // Mapping to store whether an address is a registered voter
    mapping(address => bool) public voters;

    // Mapping to store the vote count for each candidate
    mapping(uint => uint) public voteCounts;

    // Variable to keep track of the total number of candidates
    uint public candidateCount;

    // Event to notify when admin privileges are granted or revoked
    event AdminUpdated(address indexed _admin, bool _isAdmin);

    // Event to notify when a new candidate is added
    event CandidateAdded(uint indexed _candidateId, string _name);

    // Event to notify when a voter is registered
    event VoterRegistered(address indexed _voter);

    // Event to notify when a vote is cast
    event VoteCast(uint indexed _candidateId, address indexed _voter);

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only admin can call this function");
        _;
    }

    // Constructor to set the initial admin
    constructor() {
        admin = msg.sender;
        isAdmin[msg.sender] = true;
        emit AdminUpdated(msg.sender, true);
    }

    // Function to grant admin privileges to an address (only accessible to the current admin)
    function grantAdmin(address _user) public onlyAdmin {
        isAdmin[_user] = true;
        emit AdminUpdated(_user, true);
    }

    // Function to revoke admin privileges from an address (only accessible to the current admin)
    function revokeAdmin(address _user) public onlyAdmin {
        require(_user != admin, "Cannot revoke admin privileges from the main admin");
        isAdmin[_user] = false;
        emit AdminUpdated(_user, false);
    }

    // Function to add a new candidate (only accessible to the admin)
    function addCandidate(string memory _name) public onlyAdmin returns (uint) {
        uint candidateId = candidateCount;
        candidates[candidateId] = _name;
        candidateCount++;
        emit CandidateAdded(candidateId, _name);
        return candidateId;
    }

    // Function to register a voter (only accessible to the admin)
    function registerVoter(address _voter) public onlyAdmin {
        voters[_voter] = true;
        emit VoterRegistered(_voter);
    }

    // Function to cast a vote (accessible to registered voters)
    function castVote(uint _candidateId) public {
        require(voters[msg.sender], "Only registered voters can cast votes");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");

        voteCounts[_candidateId]++;
        emit VoteCast(_candidateId, msg.sender);
    }

    // Function to get the total vote count for a candidate
    function getVoteCountForCandidate(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        return voteCounts[_candidateId];
    }

    // Function to get the total number of candidates
    function getCandidateCount() public view returns (uint) {
        return candidateCount;
    }
}
