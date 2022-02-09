//SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.8.0 <0.9.0;


library LTresoreria {



    function isContained(address a, address [] memory b ) pure internal returns (bool) {
        for(uint256 x = 0; x < b.length; x++){
            if(a == b[x]) {
                return true; 
            }
        }
        return false; 
    }
    
    function append(address [] memory a, address[] memory b) pure internal returns (address [] memory) {
        uint256 total = a.length + b.length; 
        address [] memory c = new address[](total); 
        uint256 y = 0; 
        uint256 z = 0; 
        for(uint256 x = 0; x < total; x++) {
            if(x < a.length) {
                c[x] = a[y];
                y++;
            }
            else { 
                c[x] = b[z];
                z++;
            }
        }
        return c; 
    }

    function remove(address a, address[] memory b) pure internal returns (address [] memory){
        address [] memory c = new address[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            address d = b[x];
            if( a != d){     
                if(y == c.length){ // i.e. element not found
                    return b; 
                }
                c[y] = d; 
                y++;
           
            }
        }
        return c; 
    }

    function append(string [] memory a, string[] memory b) pure internal returns (string [] memory) {
        uint256 total = a.length + b.length; 
        string [] memory c = new string[](total); 
        uint256 y = 0; 
        uint256 z = 0; 
        for(uint256 x = 0; x < total; x++) {
            if(x < a.length) {
                c[x] = a[y];
                y++;
            }
            else { 
                c[x] = b[z];
                z++;
            }
        }
        return c; 
    }

    function append(uint256 [] memory a, uint256[] memory b) pure internal returns (uint256 [] memory) {
        uint256 total = a.length + b.length; 
        uint256 [] memory c = new uint256[](total); 
        uint256 y = 0; 
        uint256 z = 0; 
        for(uint256 x = 0; x < total; x++) {
            if(x < a.length) {
                c[x] = a[y];
                y++;
            }
            else { 
                c[x] = b[z];
                z++;
            }
        }
        return c; 
    }
}