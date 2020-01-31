pragma solidity 0.4.26;

import "./BnObjects.sol";
import "./BnEvents.sol";


// shared storage
contract BnStorage is BnObjects, BnEvents {

    mapping (uint => ExampleObject) examples;

}

