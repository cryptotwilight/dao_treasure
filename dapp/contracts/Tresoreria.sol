// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./ITresoreria.sol";
import "./IProtocol.sol";
import "./ISwap.sol";
import "./LTresoreria.sol";


contract Tresoreria is ITresoreria { 

    using LTresoreria for address; 
    using LTresoreria for uint256[];
    using LTresoreria for string[];
    using LTresoreria for bool[];

    address rootAdmin; 
    address self; 
    
    address [] tokenList;   
    mapping(address=>string) tokenNameByTokenAddress; 
    mapping(address=>bool) hasBalanceByAddress; 

    IProtocol [] protocols; 

    ApprovedAddress [] approvedAddresses;
    mapping(address=>bool) isApprovedByAddress; 
    mapping(address=> ApprovedAddress) approvedAddressByAddress; 

    mapping(string=>bool) knownByProtocol; 
    mapping(string=>IProtocol) protocolByName; 

    mapping(string=>Investment) investmentByProtocol; 
    mapping(string=>bool) hasInvestmentByProtocol; 

    ISwap swaps; 

    Deposit [] depositHistory; 
    Withdrawal [] withdrawalHistory; 
    Investment [] investmentHistory; 
    Swap [] swapHistory; 
  
    address NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    struct Deposit { 
        uint256 amount;
        uint256 denominated; 
        string  currency; 
        address erc20;  
        uint256 date;      
        address payer;  
    }

    struct Withdrawal { 
        uint256 amount; 
        uint256 denominated;
        string currency;
        address erc20;
        address payee;
        address withdrawer; 
        uint256 date; 
    }

    struct Investment { 
        string protocol;
        string market;  
        uint256 entryAmount; 
        uint256 entryAmountDenominated; 
        string entryCurrency; 
        address entryErc20;
        uint256 entryDate; 
        uint256 exitDate; 
        uint256 exitReturn; 
        string exitCurrency; 
    }

    struct Swap { 
        string fromCurrency; 
        string toCurrency; 
        uint256 fromAmount; 
        uint256 toAmount; 
        uint256 fromAmountDenominated; 
        uint256 date; 
        address swapper; 
    }

    struct ApprovedAddress { 
        address approvedAddress; 
        address approvedBy; 
        uint256 date; 
        string  name; 
    }

    constructor (address _rootAdmin, address [] memory _protocolAddresses, address _swap) { 
        rootAdmin = _rootAdmin;
        self = address(this); 
        addProtocolsInternal(_protocolAddresses);
        swaps = ISwap(_swap);
    }

    function getApprovedAddresses() override view external returns(address [] memory _approvedAddresses, string [] memory _addressNames, address [] memory _approvedBy, uint256 [] memory _date ){
        _approvedAddresses = new address [] (approvedAddresses.length);
        _addressNames = new string[](approvedAddresses.length);
        _approvedBy = new address [] (approvedAddresses.length);
        _date = new uint256 [] (approvedAddresses.length);

        for(uint256 x = 0; x < approvedAddresses.length; x++){
            ApprovedAddress memory approvedAddress_ = approvedAddresses[x];
            _approvedAddresses[x] = approvedAddress_.approvedAddress; 
            _addressNames[x] = approvedAddress_.name; 
            _approvedBy[x] = approvedAddress_.approvedBy; 
            _date[x] = approvedAddress_.date; 
        }
        return (_approvedAddresses, _addressNames, _approvedBy, _date);
    }

    function getAvailableBalances() override view external returns (string [] memory _currency, uint256 [] memory _balance){
        _currency = new string[](tokenList.length);
        _balance = new uint256[](tokenList.length);
        for(uint256 x = 0; x < tokenList.length; x++){
            address tokenAddress_ = tokenList[x];
            _currency[x] = tokenNameByTokenAddress[tokenAddress_]; 
            if(tokenAddress_ == NATIVE){
                _balance[x] = self.balance; 
            }
            else { 
                _balance[x] = IERC20(tokenAddress_).balanceOf(self);
            }
        }
        return (_currency, _balance);
    }

    function getLatestDeals() override view external returns (string [] memory _protocols, 
                                                                string [] memory _markets, 
                                                                    uint256 [] memory _aprapys, 
                                                                        bool [] memory _isAPYs, 
                                                                            uint256 [] memory _totalValueLockeds) {
        _protocols = new string[](0);
        _markets = new string[](0);
        _aprapys = new uint256[](0);
        _isAPYs = new bool[](0);
        _totalValueLockeds = new uint256[](0);

        for(uint256 x = 0; x < protocols.length; x++) {
            IProtocol protocol_ = protocols[x];
            (string [] memory market_, uint256 [] memory aprapy_, bool [] memory isAPY_, uint256 [] memory totalValueLocked_)  = protocol_.getLatestDeals();
            
            string memory protocolName_ = protocol_.getName(); 
            string [] memory p = new string[](market_.length);
            for( uint256 y = 0; y < market_.length; y++) {
                p[y] = protocolName_;
            }
            
            _protocols = _protocols.append(p);
            _markets = _markets.append(market_);
            _aprapys = _aprapys.append(aprapy_);
            _isAPYs =  _isAPYs.append(isAPY_);
            _totalValueLockeds = _totalValueLockeds.append(totalValueLocked_);
        }
        return (_protocols, _markets, _aprapys, _isAPYs, _totalValueLockeds);
    }

    function getHoldings() override  view external returns (string [] memory _protocol, string [] memory _market, 
                                                                uint256 [] memory _rateYield, bool [] memory _isAPY, 
                                                                    uint256 [] memory _volume, uint256 [] memory _earningsToDate, 
                                                                        uint256 [] memory _initialInvestment, uint256 [] memory _investmentDate){
        uint256 size_       = protocols.length; 
        _protocol           = new string[](size_); 
        _market             = new string[](size_); 
        _rateYield          = new uint256[](size_);
        _isAPY              = new bool[](size_);
        _volume             = new uint256[](size_);
        _earningsToDate     = new uint256[](size_);
        _initialInvestment  = new uint256[](size_); 
        _investmentDate     = new uint256[](size_);

        for(uint256 x = 0; x < protocols.length; x++) {        
            _protocol[x] =  protocols[x].getName(); 
            (_market[x], _rateYield[x], _isAPY[x], _volume[x], _earningsToDate[x], _initialInvestment[x], _investmentDate[x]) =  protocols[x].getHolding();
        }
        return (_protocol, _market, _rateYield, _isAPY, _volume, _earningsToDate, _initialInvestment, _investmentDate);
    }
    
                                                
    function getInvestmentHistory() override view external returns (string [] memory _protocol, string [] memory _market, 
                                                                        uint256 [] memory _entryDate, uint256 [] memory _exitDate, 
                                                                            uint256 [] memory _entryInvestment, uint256 [] memory _entryInvestmentDenominated, 
                                                                                uint256 [] memory _exitReturn,  string [] memory _exitCurrency ){
        uint256 size_ = investmentHistory.length;
        _protocol = new string[](size_);
        _market = new string[](size_); 
        _entryDate = new uint256[](size_);
        _exitDate = new uint256[](size_); 
        _entryInvestment = new uint256[](size_); 
        _exitReturn = new uint256[](size_); 
        _exitCurrency = new string[](size_);
        for(uint256 x = 0; x < size_; x++) {
            Investment memory investment_  = investmentHistory[x];
            _protocol[x]                   = investment_.protocol; 
            _market[x]                     = investment_.market; 
            _entryDate[x]                  = investment_.entryDate; 
            _exitDate[x]                   = investment_.exitDate; 
            _entryInvestment[x]            = investment_.entryAmount;
            _entryInvestmentDenominated[x] = investment_.entryAmountDenominated;
            _exitReturn[x]                 = investment_.exitReturn;
            _exitCurrency[x]               = investment_.exitCurrency; 
        }
        return (_protocol, _market, _entryDate, _exitDate, _entryInvestment, _entryInvestmentDenominated, _exitReturn, _exitCurrency); 
    }

    function getDepositHistory() override view external returns (string [] memory _currency, uint256 [] memory _volume, 
                                                                    uint256[] memory _denominated,  uint256[] memory _depositDate, 
                                                                        address [] memory _payer){
        uint256 size_ = depositHistory.length; 
        _currency     = new string[](size_);
        _volume       = new uint256[](size_); 
        _denominated  = new uint256[](size_);  
        _depositDate  = new uint256[](size_);
        _payer        = new address[](size_);                                                                  
        for(uint256 x = 0; x < size_; x++) {
            Deposit memory deposit_ = depositHistory[x];
            _currency[x]     = deposit_.currency; 
            _volume[x]       = deposit_.amount; 
            _denominated[x]  = deposit_.denominated;  
            _depositDate[x]  = deposit_.date;
            _payer[x]        = deposit_.payer;  

        }
        return (_currency, _volume, _denominated, _depositDate, _payer);

    }

    function getWithdrawalHistory() override view external returns (string [] memory _currency, uint256 [] memory _volume, uint256[] memory _denominated, 
                                                                    uint256[] memory _withdrawalDate, address [] memory _withdrawer, address [] memory _payee){
        uint256 size_ = withdrawalHistory.length; 
        _currency          = new string[](size_);
        _volume            = new uint256[](size_);
        _denominated       = new uint256[](size_);
        _withdrawalDate    = new uint256[](size_);
        _withdrawer        = new address[](size_); 
        _payee             = new address[](size_); 
        for(uint256 x = 0; x < size_; x++) {
            Withdrawal memory withdrawal_ = withdrawalHistory[x];
            _currency[x]          = withdrawal_.currency; 
            _volume[x]            = withdrawal_.amount; 
            _denominated[x]       = withdrawal_.denominated;             
            _withdrawalDate[x]    = withdrawal_.date; 
            _withdrawer[x]        = withdrawal_.withdrawer; 
            _payee[x]             = withdrawal_.payee;

        }
        return ( _currency,  _volume, _denominated, _withdrawalDate, _withdrawer, _payee);

    }
    function getSwapHistory() override view external returns (string [] memory _fromCurrency, string [] memory _toCurrency, 
                                                                uint256 [] memory _fromCurrencyAmount, uint256 [] memory _toCurrencyAmount, uint256 [] memory _fromCurrencyAmountDenominated,
                                                                    uint256 [] memory _swapDate, address [] memory _swapper){
        uint256 size_ = swapHistory.length; 
        _fromCurrency       = new string[](size_);  
        _toCurrency         = new string[](size_);
        _fromCurrencyAmount = new uint256[](size_);
        _toCurrencyAmount   = new uint256[](size_);
        _swapDate           = new uint256[](size_);
        _swapper            = new address[](size_); 
        for(uint256 x = 0; x < size_; x++) {
            Swap memory swap_ = swapHistory[x];
            _fromCurrency[x]                    = swap_.fromCurrency;  
            _toCurrency[x]                      = swap_.toCurrency;
            _fromCurrencyAmount[x]              = swap_.fromAmount;
            _fromCurrencyAmountDenominated[x]   = swap_.fromAmountDenominated;
            _toCurrencyAmount[x]                = swap_.toAmount;
            _swapDate[x]                        = swap_.date;
            _swapper[x]                         = swap_.swapper;  
        
        }
        return (_fromCurrency, _toCurrency, _fromCurrencyAmount, _toCurrencyAmount, _fromCurrencyAmountDenominated, _swapDate, _swapper);
    }

    function swap(address _fromCurrency, address _toCurrency, uint256 _fromDenominated, uint256 _fromCurrencyAmount) override payable external returns (uint256 _toCurrencyAmount) {
        if(_fromCurrency == NATIVE) {
            _toCurrencyAmount = swaps.swap{value : _fromCurrencyAmount}(_fromCurrency, _toCurrency, _fromCurrencyAmount);
        }
        else { 
            IERC20 fromErc20 = IERC20(_fromCurrency);
            fromErc20.approve(address(swaps), _fromCurrencyAmount);
            _toCurrencyAmount = swaps.swap(_fromCurrency, _toCurrency,  _fromCurrencyAmount);
        }
    
        Swap memory swap_ = Swap({
                            fromCurrency : tokenNameByTokenAddress[_fromCurrency],
                            toCurrency : tokenNameByTokenAddress[_toCurrency],
                            fromAmount : _fromCurrencyAmount,
                            toAmount : _toCurrencyAmount,
                            fromAmountDenominated : _fromDenominated,
                            date : block.timestamp,
                            swapper : msg.sender
                            });
        swapHistory.push(swap_);
        return _toCurrencyAmount;
    }


    function deposit(uint256 _amount, uint256 _denominated, string memory _currency, address _erc20Address ) override  payable external returns (bool _deposited){
        if(_erc20Address == NATIVE) {            
            require(msg.value == _amount, " amount stated not equal to amount sent ");   
        }
        else {             
            IERC20 erc20 = IERC20(_erc20Address);
            erc20.transferFrom(msg.sender, self, _amount);  
                                         
        }  
        if(!hasBalanceByAddress[_erc20Address]) {
            tokenList.push(_erc20Address);
            tokenNameByTokenAddress[_erc20Address] = _currency; 
            hasBalanceByAddress[_erc20Address] = true;          
        }
        Deposit memory deposit_ = Deposit ({
                                    amount : _amount, 
                                    denominated : _denominated, 
                                    currency : _currency, 
                                    erc20 : _erc20Address,
                                    date : block.timestamp,
                                    payer : msg.sender
                                    });
        depositHistory.push(deposit_);

        return true; 
    }

    function withdraw(uint256 _amount, uint256 _denominated, string memory _currency, address _erc20Address, address payable _payee ) override  external returns (bool _withdrawn){
        if(_erc20Address == NATIVE){
            _payee.transfer(_amount);
            if(self.balance == 0) {
                tokenList = _erc20Address.remove(tokenList);
                hasBalanceByAddress[_erc20Address] = false;  
                delete tokenNameByTokenAddress[_erc20Address];
            }
        }
        else { 
            IERC20 erc20 = IERC20(_erc20Address);
            erc20.transfer(_payee, _amount);
            if(erc20.balanceOf(self) == 0) {
                tokenList = _erc20Address.remove(tokenList);
                hasBalanceByAddress[_erc20Address] = false;  
                delete tokenNameByTokenAddress[_erc20Address];
            }
        }

        Withdrawal memory withdrawal_ = Withdrawal({
                                                    amount : _amount,
                                                    denominated : _denominated, 
                                                    currency : _currency, 
                                                    erc20 : _erc20Address, 
                                                    payee : _payee, 
                                                    withdrawer : msg.sender, 
                                                    date : block.timestamp 
                                                    });
        withdrawalHistory.push(withdrawal_);
        return true; 
    }

    function invest(string memory _protocol, string memory _market, uint256 _amount, uint256 _denominated, string memory _currency, address _erc20) override external returns (bool _invested){
        IProtocol protocol_ = protocolByName[_protocol];
        require(!hasInvestmentByProtocol[_protocol], " protocol already has investment. ");
        if(_erc20 == NATIVE) {
            protocol_.enter{value : _amount}(_market, _amount, _erc20);
        }
        else { 
            IERC20 erc20_ = IERC20(_erc20);
            erc20_.approve(address(protocol_), _amount);
            protocol_.enter(_market,_amount, _erc20 );
        }
        Investment memory investment_ = Investment({
                                                protocol : protocol_.getName(), 
                                                market : _market,
                                                entryAmount : _amount, 
                                                entryAmountDenominated : _denominated,
                                                entryCurrency : _currency,
                                                entryErc20 : _erc20,
                                                entryDate : block.timestamp,
                                                exitDate : 0,
                                                exitReturn : 0,
                                                exitCurrency : ""
                                            });
        investmentByProtocol[_protocol] = investment_; 
        hasInvestmentByProtocol[_protocol] = true; 
        return true; 
    }

    function exit(string memory _protocol, string memory _market) override external returns (bool _exited, string memory _currency, uint256 _amount){
        IProtocol protocol_ = protocolByName[_protocol];
        require(hasInvestmentByProtocol[_protocol], " protocol has no investment. ");
        (uint256 exitDate_, uint256 exitAmount_, string memory exitCurrency_) = protocol_.exit(_market);
        Investment memory investment_ = investmentByProtocol[protocol_.getName()];
        investment_.exitDate = exitDate_;
        investment_.exitReturn = exitAmount_; 
        investment_.exitCurrency = exitCurrency_;
        investmentHistory.push(investment_);
        return (true, exitCurrency_, exitAmount_);
    }

    function addProtocol(address _protocolAddress) external returns (bool _added) {
        return addProtocolInternal(_protocolAddress);
    }

    function addApprovedAddress(address _address, string memory _name) external returns (bool _added) {
        if(!isApprovedByAddress[_address]){
            isApprovedByAddress[_address] = true; 
            ApprovedAddress memory approvedAddress_ = ApprovedAddress ({
                approvedAddress  : _address, 
                approvedBy : msg.sender, 
                date : block.timestamp, 
                name : _name
            });
            approvedAddressByAddress[_address] = approvedAddress_;
            approvedAddresses.push(approvedAddress_);
        }
        return true; 
    }

    // =================================== INTERNAL =========================================

    function addProtocolsInternal(address [] memory _protocolAddresses)  internal returns (bool _added) {
        for(uint256 y = 0; y < _protocolAddresses.length; y++) {
            addProtocolInternal(_protocolAddresses[y]);
        }
        return true; 
    }

    function addProtocolInternal(address _protocolAddress) internal returns (bool _added) {
        IProtocol protocol_ = IProtocol(_protocolAddress);
        string memory name_ = protocol_.getName(); 
        if(!knownByProtocol[name_]) {
            protocolByName[name_] = protocol_;
            protocols.push(protocol_);
        }
        return true; 
    }

}