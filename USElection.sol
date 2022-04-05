// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./Ownable.sol";

contract USElection is Ownable{
    uint8 public constant BIDEN = 1;
    uint8 public constant TRUMP = 2;
    
    bool public electionEnded;
    
    mapping(uint8 => uint8) public seats;

    mapping(string=>bool) public resultsSubmitted;
    
    struct StateResult {
        string name;
        uint votesBiden;
        uint votesTrump;
        uint8 stateSeats;
    }

    event LogElectionEnded(uint winner);
    
    event LogStateResult(uint8 winner, uint8 stateSeats, string state);

	modifier onlyActiveElection() {
        require(!electionEnded, "The election has ended already");
        _;
    }
		    
	function  submitStateResult(StateResult calldata result) public onlyOwner onlyActiveElection{
		    require(result.stateSeats > 0, "States must have at least 1 seat");
		    require(result.votesBiden != result.votesTrump, "There cannot be a tie");
            require(!resultsSubmitted[result.name], "Already submitted results for this state!");

		    uint8 winner;
		    if(result.votesBiden > result.votesTrump) {
		        winner = BIDEN;
		    } else {
		        winner = TRUMP;
		    }
		    
		    seats[winner] += result.stateSeats;
            resultsSubmitted[result.name] = true;
		    
		    emit LogStateResult(winner, result.stateSeats, result.name);
	}

    function currentLeader() public view returns(uint8) {
		    if(seats[BIDEN] > seats[TRUMP]) {
		        return BIDEN;
		    }
		    if(seats[TRUMP] > seats[BIDEN]) {
		        return TRUMP;
		    }
		    return 0;
	}
    
    
	function endElection() public onlyOwner onlyActiveElection {
        electionEnded = true;
        emit LogElectionEnded(currentLeader());
    }
    
}