pragma solidity ^0.5.0;


contract RandomNumberGenerator {
    uint[1000] tokenIds; // tokenId : 1~1000
    uint preSaleQuantity = 1000;
    uint remainingTokenCount = preSaleQuantity;

    function _generateRandomNumber (uint requiredSeed) public view returns (uint) {
        require(remainingTokenCount > 0);
        return uint(keccak256(abi.encodePacked(requiredSeed, blockhash(block.number), msg.sender))) % remainingTokenCount;
    }

    function _initiateNameTagId () private {
        for (uint i=0 ; i <preSaleQuantity ; i++)
        {
            tokenIds[i] = i + 1;
        }
    }
    
    function _draw (uint requiredSeed) public returns (uint) {
        require(remainingTokenCount > 0);
        uint randNum =  _generateRandomNumber(requiredSeed);
        uint drawNum = tokenIds[randNum]; 
        tokenIds[randNum] = tokenIds[remainingTokenCount - 1];
        // + mint
        remainingTokenCount--;
        return (drawNum);
    }
    

    constructor () public {
        //initiate pre-sale nft tokenId
        _initiateNameTagId();
    }
}
