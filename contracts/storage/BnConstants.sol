pragma solidity 0.4.26;


/// @title Shared constants
contract BnConstants {

    /**
     * @notice In Exp terms, 1e18 is 1, or 100%
     */
    uint256 constant hundredPercent = 1e18;

    /**
     * @notice In Exp terms, 1e16 is 0.01, or 1%
     */
    uint256 constant onePercent = 1e16;

    bool constant CONFIRMED = true;

    uint8 constant EXAMPLE_VALUE = 1;

}
