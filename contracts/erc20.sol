// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract erc20 is ERC20, AccessControl{
    address[] Admins;
    uint private confirmations;
    uint transactionID = 1;

    struct transactionDetails {
        uint _value;
        string _action;
        uint confirmation;
        address to;
    }
    mapping(uint => transactionDetails) transaction;         
    mapping(address => mapping(uint => bool)) confirmationStat;

    

constructor(address[2] memory _admins, uint Reqconfirmation_) ERC20("TestToken", "tkt"){
    require(_admins.length >= 2, "minimum admins not met");
    require(Reqconfirmation_ > 0 && Reqconfirmation_ <= _admins.length, "invalid input");
     _setupRole(DEFAULT_ADMIN_ROLE, _admins[0]);
     _setupRole(DEFAULT_ADMIN_ROLE, _admins[1]);
    confirmations = Reqconfirmation_;
}

modifier onlyRole(bytes32 role) {
        hasRole(role, _msgSender());
        _;

        }
function execute(uint value__, string memory action__, address _to) internal onlyRole(DEFAULT_ADMIN_ROLE) {
   if(sha256(bytes(action__)) == sha256(bytes("mint"))){
        _mint(_to, value__);
   }
   if(sha256(bytes(action__)) == sha256(bytes("burn"))){
        _burn(_to, value__);
   }
   if(sha256(bytes(action__)) == sha256(bytes("admin"))){
        grantRole(DEFAULT_ADMIN_ROLE, _to);
   } 
}

function submitTransaction(uint value, string memory action, address to_)external onlyRole(DEFAULT_ADMIN_ROLE){
    string memory __action = toLower(action); 
    require(sha256(bytes(__action)) == sha256(bytes("mint")) || 
    sha256(bytes(__action)) == sha256(bytes("burn")) || 
    sha256(bytes(__action)) == sha256(bytes("admin")), "command not recognized");  
    transaction[transactionID] = transactionDetails(value, __action, 0, to_);
    transactionID++;
}

function confirmTransaction(uint transactionID_) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(confirmationStat[msg.sender][transactionID_] == false, 'already confirmed');
    transaction[transactionID_].confirmation++;
    confirmationStat[msg.sender][transactionID_] = true;
    if (transaction[transactionID_].confirmation >= confirmations){
        execute(transaction[transactionID_]._value, transaction[transactionID_]._action, transaction[transactionID_].to);
    }
}

function toLower(string memory str) internal pure returns (string memory){
    bytes memory bStr = bytes(str);
    bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }


}


// to-doo
//set mint, burn and default admin role.

