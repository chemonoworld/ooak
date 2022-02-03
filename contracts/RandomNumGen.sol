// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract RandomNumGen {
    uint256[] public remainingTokenList;
    mapping (uint256 => address) public tokenOwner;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(address => bool) private _addressExist;

    constructor(uint tokenNum){
        for(uint i=0; i<tokenNum; i++) {
            remainingTokenList.push(i+1);
        }
    }

    function mintWithRandomToken(address to) public returns (uint) {
        require(_addressExist[to] == false, "already have token");

        uint rand = _generateRandomNum();
        uint256 tokenId = remainingTokenList[rand];
        uint256 endTokenId = remainingTokenList[remainingTokenList.length-1];
        remainingTokenList[rand] = endTokenId;
        remainingTokenList.pop();

        _ownedTokens[to].push(tokenId);
        _addressExist[to] = true;
        
        return rand;
    }

    function _generateRandomNum() private returns (uint) {
        uint256 coinbase = ((uint256(keccak256(abi.encodePacked(block.coinbase)))));
        uint256 sender = ((uint256(keccak256(abi.encodePacked(msg.sender)))));

        uint256 seed = uint256(keccak256(abi.encodePacked(
        block.timestamp + block.difficulty +
        coinbase +
        block.gaslimit + 
        sender +
        block.number
        )));
        uint256 len = remainingTokenList.length;
        uint rand = seed % len;
        return rand;
    }

    function _removeTokenFromList(address from, uint256 tokenId) private {
        uint256 len = _ownedTokens[from].length-1;
        for(uint256 i=0; i<_ownedTokens[from].length;i++) {
            if (tokenId == _ownedTokens[from][i]) {
                // swap
                _ownedTokens[from][i] = _ownedTokens[from][len];
                _ownedTokens[from][len] = tokenId;
                break;
            }
        }
        _ownedTokens[from].pop();
    }

    function ownedTokens(address owner) public view returns (uint256[] memory) {
        return _ownedTokens[owner];
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(
            owner != address(0),
            "KIP17: balance query for the zero address"
        );
        return _ownedTokens[owner].length;
    }
}