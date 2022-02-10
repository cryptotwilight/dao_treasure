// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


interface ITresoreria { 

    function getApprovedAddresses() view external returns(address [] memory _approvedAddress, 
                                                                string [] memory _addressName, 
                                                                    address [] memory _approvedBy, 
                                                                        uint256 [] memory _date);

    function getAvailableBalances() view external returns (string [] memory _currency, 
                                                                uint256 [] memory _balance);

    function getLatestDeals() view external returns (string [] memory _protocol, 
                                                        string [] memory _market, 
                                                            uint256 [] memory _aprapy,  
                                                                bool [] memory _isAPYs, 
                                                                    uint256 [] memory _totalValueLocked);

    function getHoldings() view external returns (string [] memory _protocol, 
                                                        string [] memory _maArket, 
                                                            uint256 [] memory _rateYield, 
                                                                bool [] memory _isAPY, 
                                                                    uint256 [] memory _volume, 
                                                                        uint256 [] memory _earningsToDate, 
                                                                            uint256 [] memory _initialInvestment, 
                                                                                uint256 [] memory _investmentDate);

    function getInvestmentHistory() view external returns (string [] memory _protocol, 
                                                                string [] memory _market, 
                                                                    uint256 [] memory _entryDate, 
                                                                        uint256 [] memory _exitDate, 
                                                                            uint256 [] memory _entryInvestment, 
                                                                                uint256 [] memory _entryInvestmentDenominated, 
                                                                                    uint256 [] memory _exitReturn, 
                                                                                        string [] memory _exitCurrency );

    function swap(address _fromCurrency, address _toCurrency, uint256 _fromDenominated, uint256 _fromCurrencyAmount) payable external returns (uint256 _toCurrencyAmount);

    function getDepositHistory() view external returns (string [] memory _currency, 
                                                            uint256 [] memory _volume, 
                                                                uint256[] memory _denominated,  
                                                                    uint256[] memory depositDate, 
                                                                        address [] memory _payer );

    function getWithdrawalHistory() view external returns (string [] memory _currency, 
                                                                uint256 [] memory _volume, 
                                                                    uint256[] memory _denominated, 
                                                                        uint256[] memory _withdrawalDate, 
                                                                            address [] memory _withdrawer, 
                                                                                address [] memory _payee);

    function getSwapHistory() view external returns (string [] memory _fromCurrency, 
                                                        string [] memory _toCurrency, 
                                                                uint256 [] memory _fromCurrencyAmount, 
                                                                    uint256 [] memory _toCurrencyAmount, 
                                                                        uint256 [] memory _fromCurrencyAmountDenominated, 
                                                                            uint256 [] memory _swapDate, 
                                                                                    address [] memory _swapper);                                                                

    function deposit(uint256 _amount, uint256 _denominated, string memory _currency, address _erc20) payable external returns (bool _deposited);

    function withdraw(uint256 _amount, uint256 _denominated, string memory _currency, address _erc20, address payable _payee ) external returns (bool _withdrawn);

    function invest(string memory _protocol, string memory _market, uint256 _amount, uint256 _denominated, string memory _currency, address _erc20) external returns (bool _invested);

    function exit(string memory _protocol, string memory _market) external returns (bool _liquidated, string memory _currency, uint256 _amount);

}