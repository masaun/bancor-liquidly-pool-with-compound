pragma solidity 0.4.26;

// Bancor-Protocol
import "./bancor-protocol/utility/ContractRegistry.sol";          // Step #1: Initial Setup
import "./bancor-protocol/token/SmartToken.sol";                  // Step #2: Smart Relay Token Deployment
import "./bancor-protocol/converter/BancorConverter.sol";         // Step #3: Converter Deployment
import "./bancor-protocol/converter/BancorConverterFactory.sol";  // Step #5: Activation and Step #6: Multisig Ownership
import "./bancor-protocol/converter/BancorConverterRegistry.sol"; // Step #7: Converters Registry Listing

//import "./bancor-protocol/token/ERC20Token.sol";
import './bancor-protocol/token/interfaces/IERC20Token.sol';

// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants {

    ContractRegistry public contractRegistry;
    SmartToken public smartToken;
    //BancorConverter public bancorConverter;
    //BancorConverterFactory public bancorConverterFactory;
    BancorConverterRegistry public bancorConverterRegistry;

    IERC20Token public ierc20Token;

    address BNTtokenAddr;
    address ERC20tokenAddr;
    address cDAItokenAddr;  // cToken from compound pool


    constructor(
        address _contractRegistry,
        address _BNTtokenAddr,
        address _ERC20tokenAddr,
        address _cDAItokenAddr,
        address _smartToken,
        //address _bancorConverter,
        //address _bancorConverterFactory,
        address _bancorConverterRegistry
    ) 
        public
    {
        // Step #1: Initial Setup
        contractRegistry = ContractRegistry(_contractRegistry);
        BNTtokenAddr = _BNTtokenAddr;
        ERC20tokenAddr = _ERC20tokenAddr;
        cDAItokenAddr = _cDAItokenAddr;  // cToken from compound pool

        // Step #2: Smart Relay Token Deployment
        smartToken = SmartToken(_smartToken);

        // Step #3: Converter Deployment
        //bancorConverter = BancorConverter(_bancorConverter);

        // Step #5: Activation and Step #6: Multisig Ownership
        //bancorConverterFactory = BancorConverterFactory(_bancorConverterFactory);

        // Step #7: Converters Registry Listing
        bancorConverterRegistry = BancorConverterRegistry(_bancorConverterRegistry);
    }


    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

    /***
     * @notice - Integrate pools with lending protocols (e.g., lend pool tokens to Compound) to hedge risk for stakers 
     * https://docs.bancor.network/user-guides/token-integration/how-to-create-a-bancor-liquidity-pool
     **/
    function integratePoolWithLendingProtocol(
        bytes32 _contractName1, 
        //string _contractName2,
        address receiverAddr,
        uint256 amountOfSmartToken
    ) public returns (bool) {
        // [In progress]: Integrate with lending pool of compound (cToken)

        // Step #1: Initial Setup
        address token1;
        //address token2;

        token1 = contractRegistry.addressOf(_contractName1);
        //token2 = contractRegistry.addressOf(_contractName2);

        // Step #2: Smart Relay Token Deployment
        smartToken.issue(msg.sender, amountOfSmartToken);
        smartToken.transfer(receiverAddr, amountOfSmartToken);

        // Step #3: Converter Deployment
        //uint index = 0;
        //uint32 reserveRatio = 10; // The case of this, I specify 10% as percentage of ratio. (After I need to divide by 100)
        //uint32 _conversionFee = 1000;  // Fee: 1,000 (0.1%)
        //bancorConverter.addConnector(IERC20Token(ERC20tokenAddr), reserveRatio, true);
        //bancorConverter.setConversionFee(_conversionFee);

        // Step #4: Funding & Initial Supply
        //uint256 fundedAmount = 100;
        //bancorConverter.fund(fundedAmount);

        // Step #5: Activation
        // Step #6: Multisig Ownership
        //address _converterAddress;  // @notice - This variable is for receiving return value of createConverter() below
        //uint32 _maxConversionFee = 1;
        //_converterAddress = bancorConverterFactory.createConverter(smartToken, 
        //                                                           contractRegistry, 
        //                                                           _maxConversionFee, 
        //                                                           IERC20Token(ERC20tokenAddr), 
        //                                                           reserveRatio);

        // Step #7: Converters Registry Listing
        bancorConverterRegistry.addConverter(IBancorConverter(_converterAddress));
    }

}
