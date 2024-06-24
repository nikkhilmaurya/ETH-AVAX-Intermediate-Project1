// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract VotingSystem {
    struct Voter {
        bool hasVoted;
        uint voteIndex;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    Candidate[] public candidates;
    mapping(address => Voter) public voters;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function addCandidate(string memory name) public onlyOwner {
        candidates.push(Candidate(name, 0));
    }
    
    //Function will allow the voters to vote for an option 
    function vote(uint index) public {
        require(index < candidates.length, "Invalid candidate index");
        
        if (voters[msg.sender].hasVoted) {
          revert("You have already voted");
        }

        if (index >= candidates.length) {
            revert("Candidate index out of range");
        }

        voters[msg.sender] = Voter(true, index);
        candidates[index].voteCount += 1;

        assert(candidates[index].voteCount > 0);
    }

    function getCandidateCount() public view returns (uint) {
        if(candidates.length == 0){
            revert("You haven't added any candidate yet");
        }
        return candidates.length;
    }

    //This function will determine the winner of the voting system
    function getWinner() public view returns (string memory winName, uint winnerVoteCount) {
        require(candidates.length > 0, "No candidates available");

        uint winCount;  // winning Vote Count
        uint winIndex;  // winning Index

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winCount) {
                winCount = candidates[i].voteCount;
                winIndex = i;
            }
        }

        winName = candidates[winIndex].name;
        winnerVoteCount = candidates[winIndex].voteCount;

        assert(winCount > 0);
    }
}
