// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

interface ISwap { 
    
    function getName() view external returns (string memory _name);

    function swap(address _from, address _to, uint256 _fromAmount) payable external returns (uint256 _toAmount);

}