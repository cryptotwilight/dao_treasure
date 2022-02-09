// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


interface IProtocol { 

    function getName() view external returns (string memory _name);

    function getHolding() view external returns (string memory _market, uint256 _aprapy, bool _isApy, uint256 _volume, uint256 _eaningsToDate, uint256 _initialInvestment, uint256 _investmentDate);

    function getLatestDeals() view external returns (string [] memory _market, uint256 [] memory _aprapy, uint256 [] memory _totalValueLocked); 

    function enter(string memory _market, uint256 _investmentAmount, address _investmentCurrency ) payable external returns (uint256 _entryDate);

    function exit(string memory _market) external returns (uint256 _exitDate, uint256 _exitAmount, string memory _exitCurrency);    
}