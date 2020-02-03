pragma solidity 0.4.26;

// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants {

    constructor() public {}

    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

}
