// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20{
    address owner;

constructor() ERC20("MockUSDC", "MUSDC") {
    owner = msg.sender;
    _mint(msg.sender, 10 ether);
}

function mint(uint _amount, address _to)external {
    _mint(_to, _amount);
}

}



