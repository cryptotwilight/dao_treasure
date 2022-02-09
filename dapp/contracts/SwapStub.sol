// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./ISwap.sol";

contract SwapStub is ISwap { 
    
    function getName() override view external returns (string memory _name){
        return "swap Stub"; 
    }

    function swap(address _from, address _to, uint256 _fromAmount) override payable external returns (uint256 _toAmount){

        return _fromAmount * 2; 

    }

}