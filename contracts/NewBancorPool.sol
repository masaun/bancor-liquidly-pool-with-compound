pragma solidity 0.4.26;

// Bancor-Protocol
import "./bancor-protocol/utility/ContractRegistry.sol";


// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants {

    ContractRegistry public contractRegistry;

    address BNTtoken;
    address ERC20token;
    address cDAI;  // cToken from compound pool

    constructor(
        address _contractRegistry,
        address _BNTtoken,
        address _ERC20token,
        address _cDAI
    ) public {
        contractRegistry = ContractRegistry(_contractRegistry);

        BNTtoken = _BNTtoken;
        ERC20token = _ERC20token;
        cDAI = _cDAI;  // cToken from compound pool
    }


    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

    /***
     * @notice - Integrate pools with lending protocols (e.g., lend pool tokens to Compound) to hedge risk for stakers 
     * @ref - https://docs.bancor.network/user-guides/token-integration/how-to-create-a-bancor-liquidity-pool
     **/
    function integratePoolWithLendingProtocol() returns (bool) {
        // Integrate with lending pool of compound (cToken)


    }

    

}
