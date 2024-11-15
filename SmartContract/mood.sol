// SPDX-License-Identifi er: MIT
pragma solidity ^0.8.1;
// Defi ne contract which has to 2 fn – Set mood, get mood
contract MoodDairy{
// declaring a global variables as d_type var;
string mood;
//A public fn that writes into a smart contract (here mood) – setMood (used in the index.htm)
function setMood(string memory _mood) public {
mood = _mood;
}
//A public fn that reads from the smart contract (here mood value) – getMood (used in the index.htm)
function getMood() public view returns(string memory) {
return mood;
}
}
// getMood is a public function that returns a string and stores data in memory.
// Since it doesn’t change the state of the contract, it is called a “view” argument.