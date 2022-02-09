// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IProtocol.sol";

contract ProtocolStub is IProtocol { 

    struct Investment { 
        string market; 
        uint256 amount; 
        address currency; 
        uint256 date;
    }

    mapping(address=>Investment) investmentByAddress; 

    function getName() override view external returns (string memory _name){
        return "Protocol Stub";
    }

    function getHolding() override view external returns (string memory _market, uint256 _aprapy, bool _isApy, uint256 _volume, uint256 _eaningsToDate, uint256 _initialInvestment, uint256 _investmentDate){
        return ("USDC", 10, true, 1000000000000000000, 100000000000000, 900000000000000000, block.timestamp);
    }


    function getLatestDeals() override view external returns (string [] memory _market, uint256 [] memory _aprapy, uint256 [] memory _totalValueLocked){

    } 

    function enter(string memory _market, uint256 _investmentAmount, address _investmentCurrency ) override payable external returns (uint256 _entryDate){
        Investment investment = 
        return block.timestamp; 

    }

    function exit(string memory _market) override external returns (uint256 _exitDate, uint256 _exitAmount, string memory _exitCurrency){
        Investment memory investment = investmentByAddress[msg.sender];
        return (block.timestamp, investment.amount *2, "USDC");
    }   
}