pragma solidity >=0.7.0 <0.9.0;

contract RNG {
    uint256 private number = 1;

    function getRandomNumber() public returns (uint) {
        uint randomNumber;
        bytes memory first = abi.encodePacked(msg.sender);

        uint total = 0;
        for(uint i=0;i < 32;i++){
            total *= uint(uint8(first[i]))+1;
        }
        for(uint i=0;i < 32;i++){
            total += uint(uint8(first[i]));
        }

        randomNumber = (number * total) % 1000; //이전 사람의 number 곱하기 새로운 sum
        number = total; //다음 사람을 위해 새로 number 저장

        return randomNumber;
    }

}