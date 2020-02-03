pragma solidity 0.4.26;

// Storage
import "./storage/MpStorage.sol";
import "./storage/MpConstants.sol";


contract NewBancorPool is MpStorage, MpConstants {

    constructor() public {}

    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

}
