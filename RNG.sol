pragma solidity ^0.5.0;

import "./KIP17Token.sol";

contract RandomNumberGenerator is KIP17MetadataMintable {
    uint[1000] remainingTokenList; // tokenId : 1~1000
    uint preSaleQuantity = 1000;
    uint remainingTokenCount = preSaleQuantity;

    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => string) public tokenURIs;
    mapping(address => uint256[]) private _ownedTokens;

    function _generateRandomNumber (uint requiredSeed) public view returns (uint) {
        require(remainingTokenCount > 0);
        return uint(keccak256(abi.encodePacked(requiredSeed, blockhash(block.number), msg.sender))) % remainingTokenCount;
    }

    
    function draw (uint requiredSeed, address to, uint256 tokenId, string memory tokenURI) public returns (uint) {
        require(remainingTokenCount > 0);
        uint randNum =  _generateRandomNumber(requiredSeed);
        uint drawNum = remainingTokenList[randNum]; 
        remainingTokenList[randNum] = remainingTokenList[remainingTokenCount - 1];
        remainingTokenCount--;

        mintWithTokenURI(to, tokenId, tokenURI);
        return (drawNum);
    }


    function _initiateRemainingTokenList () private {
        for (uint i=0 ; i <preSaleQuantity ; i++)
        {
            remainingTokenList[i] = i + 1;
        }
    }

    constructor () public {
        //initiate pre-sale nft tokenId
        _initiateRemainingTokenList();
    }
}

contract KIP17TEST is
    KIP17Full,
    KIP17Mintable,
    KIP17MetadataMintable,
    KIP17Burnable,
    KIP17Pausable,
    RandomNumberGenerator
{
    constructor(string memory name, string memory symbol)
        public
        KIP17Full(name, symbol)
    {}
}
