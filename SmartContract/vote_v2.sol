
// SPDX-License-Identifier: MIT


pragma solidity ^0.8.2;

import "./SolRsaVerify/src/RsaVerify.sol";

contract ElectionVote{
    // Instantiate the RsaVerify library
    using RsaVerify for *;

    mapping(string => int) private votes;
    string[] private votesExists;
    string[] private voted_modulus;
    string exponent = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001";
    address private owner;
    bool private votingFinished = false;
    string[] private validVotes = ["PP", "PSOE", "Vox","Sumar","Podemos","Ciudadanos"];

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function isVoteExist(string memory _str) private view returns (bool) {
        for (uint i = 0; i < votesExists.length; i++) {
            if (keccak256(abi.encodePacked(votesExists[i])) == keccak256(abi.encodePacked(_str))) {
                return true;
            }
        }
        return false;
    }
    function isModulusExist(string memory _str) private view returns (bool) {
        for (uint i = 0; i < votesExists.length; i++) {
            if (keccak256(abi.encodePacked(voted_modulus[i])) == keccak256(abi.encodePacked(_str))) {
                return true;
            }
        }
        return false;
    }
    function isValidVote(string memory _str) private view returns (bool) {
        for (uint i = 0; i < validVotes.length; i++) {
            if (keccak256(abi.encodePacked(validVotes[i])) == keccak256(abi.encodePacked(_str))) {
                return true;
            }
        }
        return false;
    }

   function vote(string memory Message,
                string memory _hexSignature,
                string memory _hexModulus) public returns(string memory) {
        if(votingFinished){
            return "Vote Finished";
        }

        if (!isValidVote(Message)) {
            return "Invalid vote option";
        }

        if(RsaVerify.pkcs1Sha256Raw(bytes(Message), fromHex(_hexSignature), fromHex(exponent), fromHex(_hexModulus))){
            if(isVoteExist(Message) && !isModulusExist(_hexModulus)){
                votes[Message] += 1;
            }
            else if (  !isModulusExist(_hexModulus)) {
                votes[Message] = 1;
                voted_modulus.push(_hexModulus);
                votesExists.push(Message);
            }
            return "OK";
        } else {
            return "Not OK";
        }
   }

    // Function to get the complete votes mapping
    function getVotes() public view onlyOwner returns (string[] memory, int[] memory) {
        int[] memory allVotes = new int[](votesExists.length);
        for (uint i = 0; i < votesExists.length; i++) {
            allVotes[i] = votes[votesExists[i]];
        }
        return (votesExists, allVotes);
    }
    
    // Function to finish the voting
    function finishVoting() public onlyOwner {
        votingFinished = true;
    }

    // Convert an hexadecimal character to their value
    function fromHexChar(uint8 c) private pure returns (uint8) {
        if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
            return c - uint8(bytes1('0'));
        }
        if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
            return 10 + c - uint8(bytes1('a'));
        }
        if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
            return 10 + c - uint8(bytes1('A'));
        }
        revert("fail");
    }
    
    // Convert an hexadecimal string to raw bytes
    function fromHex(string memory s) private pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = bytes1(fromHexChar(uint8(ss[2*i])) * 16 +
                        fromHexChar(uint8(ss[2*i+1])));
        }
        return r;
    }
}