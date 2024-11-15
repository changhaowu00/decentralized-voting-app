// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.1/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20 {
 uint INITIAL_SUPPLY = 100000000000000000000;
constructor(string memory name, string memory symbol) ERC20(name, symbol) {
 _mint(msg.sender, INITIAL_SUPPLY);
 }
}

