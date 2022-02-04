pragma solidity ^0.5.0;


contract RandomNumberGenerator {
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

   function mintWithTokenURI(
        address to,
        uint256 tokenId,
        string memory tokenURI
    ) public returns (bool) {
        // to에게 tokenId(일련번호)를 발행하겠다.
        // 적힐 글자는 tokenURI
        tokenOwner[tokenId] = to;
        tokenURIs[tokenId] = tokenURI;

        // add token to the list
        _ownedTokens[to].push(tokenId);

        return true;
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
