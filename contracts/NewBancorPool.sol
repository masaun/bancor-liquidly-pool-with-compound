pragma solidity 0.4.26;

// Bancor-Protocol
import "./bancor-protocol/utility/ContractRegistry.sol";   // Step #1: Initial Setup
import "./bancor-protocol/token/SmartToken.sol";           // Step #2: Smart Relay Token Deployment
import "./bancor-protocol/converter/BancorConverter.sol";  // Step #3: Converter Deployment

// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants {

    ContractRegistry public contractRegistry;
    SmartToken public smartToken;
    BancorConverter public bancorConverter;

    address BNTtoken;
    address ERC20token;
    address cDAI;  // cToken from compound pool

    constructor(
        address _contractRegistry,
        address _BNTtoken,
        address _ERC20token,
        address _cDAI,
        address _smartToken,
        address _bancorConverter
    ) public {
        // Step #1: Initial Setup
        contractRegistry = ContractRegistry(_contractRegistry);
        BNTtoken = _BNTtoken;
        ERC20token = _ERC20token;
        cDAI = _cDAI;  // cToken from compound pool

        // Step #2: Smart Relay Token Deployment
        smartToken = SmartToken(_smartToken);

        // Step #3: Converter Deployment
        bancorConverter = BancorConverter(_bancorConverter);
    }


    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

    /***
     * @notice - Integrate pools with lending protocols (e.g., lend pool tokens to Compound) to hedge risk for stakers 
     * @ref - https://docs.bancor.network/user-guides/token-integration/how-to-create-a-bancor-liquidity-pool
     **/
    function integratePoolWithLendingProtocol(
        byte32 _contractName1, 
        byte32 _contractName2,
        address receiverAddr,
        uint256 amountOfSmartToken
    ) returns (bool) {
        // [In progress]: Integrate with lending pool of compound (cToken)

        // Step #1: Initial Setup
        address token1;
        address token2;

        token1 = contractRegistry.addressOf(_contractName1);
        token2 = contractRegistry.addressOf(_contractName2);

        // Step #2: Smart Relay Token Deployment
        smartToken.issue(msg.sender, amountOfSmartToken);
        smartToken.transfer(receiverAddr, amountOfSmartToken);

        // Step #3: Converter Deployment
        uint ratio = 10 // The case of this, I specify 10% as percentage of ratio. (After I need to divide by 100)
        bancorConverter.addConnector(ERC20token, ratio, true);

        // Step #4: Funding & Initial Supply
        uint256 fundedAmount = 100;
        bancorConverter.fund(fundedAmount);

        // Step #5: Activation
        

        // Step #6: Multisig Ownership

        // Step #7: Converters Registry Listing
    }

    

}
