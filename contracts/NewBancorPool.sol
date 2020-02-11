pragma solidity 0.4.26;

// Bancor-Protocol
import "./bancor-protocol/utility/ContractRegistry.sol";            // Step #1: Initial Setup
//import "./bancor-protocol/utility/ContractRegistryClient.sol";
import "./bancor-protocol/token/SmartToken.sol";                    // Step #2: Smart Relay Token Deployment
import "./bancor-protocol/token/SmartTokenController.sol";          // Step #7: Converters Registry Listing
import "./bancor-protocol/token/interfaces/ISmartToken.sol";        // Step #7: Converters Registry Listing
import "./bancor-protocol/converter/BancorConverter.sol";         // Step #3: Converter Deployment
import "./bancor-protocol/converter/BancorConverterFactory.sol";  // Step #5: Activation and Step #6: Multisig Ownership
import "./bancor-protocol/converter/interfaces/IBancorConverter.sol";
import "./bancor-protocol/converter/interfaces/IBancorConverterFactory.sol";

import "./bancor-protocol/converter/BancorConverterRegistry.sol";   // Step #7: Converters Registry Listing
import "./bancor-protocol/converter/BancorConverterRegistryData.sol";

//import "./bancor-protocol/token/ERC20Token.sol";
import './bancor-protocol/token/interfaces/IERC20Token.sol';

import './bancor-protocol/utility/Managed.sol';
import './bancor-protocol/converter/BancorFormula.sol';


// Compound and CToken
import "./compound-protocol/interfaces/ICErc20.sol";
//import "./compound-protocol/CErc20.sol";



// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants, Managed {

    ContractRegistry public contractRegistry;

    SmartToken public smartToken;
    BancorConverter public bancorConverter;
    BancorConverterFactory public bancorConverterFactory;
    BancorConverterRegistry public bancorConverterRegistry;

    BancorFormula public bancorFormula;

    IERC20Token public iErc20;  // i.e). DAI
    ICErc20 public iCErc20;     // i.e). cDAI（cToken）from compound pool

    address contractRegistryAddr;

    address BNTtokenAddr;
    address ERC20tokenAddr;  // i.e). DAI
    address cDAItokenAddr;   // i.e). cDAI（cToken）from compound pool

    address smartTokenAddr;

    address bancorConverterAddr;

    constructor(
        address _contractRegistry,
        address _BNTtokenAddr,
        address _ERC20tokenAddr,
        address _cDAItokenAddr,
        address _smartToken,
        address _bancorConverter,
        //address _bancorConverterFactory,
        address _bancorConverterRegistry,
        address _bancorFormula
    ) 
        public
    {
        // Step #1: Initial Setup
        contractRegistry = ContractRegistry(_contractRegistry);

        contractRegistryAddr = _contractRegistry;

        BNTtokenAddr = _BNTtokenAddr;
        ERC20tokenAddr = _ERC20tokenAddr;
        cDAItokenAddr = _cDAItokenAddr;  // cToken from compound pool

        smartTokenAddr = _smartToken;

        bancorConverterAddr = _bancorConverter;

        iErc20 = IERC20Token(ERC20tokenAddr);   // DAI on Ropsten
        iCErc20 = ICErc20(cDAItokenAddr);       // cDAI on Ropsten
        //iCErc20 = ICErc20(0x2B536482a01E620eE111747F8334B395a42A555E);  // cDAI on Ropsten

        // Step #2: Smart Relay Token Deployment
        smartToken = SmartToken(_smartToken);

        // Step #3: Converter Deployment
        bancorConverter = BancorConverter(_bancorConverter);

        // Step #5: Activation and Step #6: Multisig Ownership
        //bancorConverterFactory = BancorConverterFactory(_bancorConverterFactory);

        // Step #7: Converters Registry Listing
        bancorConverterRegistry = BancorConverterRegistry(_bancorConverterRegistry);
    }


    function testFunc() public returns (uint256 _hundredPercent) {
        return BnConstants.hundredPercent;
    }

    function testFuncCallBancorNetworkContractAddr() public view returns (address _bancorNetwork) {
        address bancorNetwork;
        bancorNetwork = contractRegistry.addressOf('BancorNetwork');
        return bancorNetwork;
    }


    /***
     * @notice - Mint cToken (Compound Token)
     * @dev - Reference from this link => https://compound.finance/developers/ctokens
     ***/
    function mintCToken(uint256 mintAmount, address recipient) public returns (bool) {
        iErc20.approve(address(cDAItokenAddr), mintAmount);   // approve the transfer
        iCErc20.mint(mintAmount);

        iCErc20.transfer(recipient, mintAmount);

        // [Ref]: 
        // Erc20 underlying = Erc20(_ERC20tokenAddr);  // get a handle for the underlying asset contract
        // CErc20 cToken = CErc20(cDAItokenAddr);      // get a handle for the corresponding cToken contract
        // underlying.approve(address(cToken), 100);   // approve the transfer
        // assert(cToken.mint(100) == 0);              // mint the cTokens and assert there is no error
        return BnConstants.CONFIRMED;
    }
    



    /***
     * @notice - Integrate bancor pools with lending protocols (Compound) to hedge risk for stakers 
     * https://docs.bancor.network/user-guides/token-integration/how-to-create-a-bancor-liquidity-pool
     **/
    function bancorPoolWithCompound(
        //bytes32 _contractName1, 
        //string _contractName2,
        address receiverAddr,
        uint256 amountOfSmartToken
    ) public returns (bool) {
        // [In progress]: Integrate with lending pool of compound (cToken)

        // Step #1: Initial Setup
        //address token1;
        //address token2;

        //token1 = contractRegistry.addressOf(_contractName1);
        //token2 = contractRegistry.addressOf(_contractName2);

        // Step #2: Smart Relay Token Deployment（Using smartToken of "cDAIBNT"）
        smartToken.issue(msg.sender, amountOfSmartToken);
        smartToken.transfer(receiverAddr, amountOfSmartToken);

        // Step #3: Converter Deployment
        uint index = 0;
        uint32 reserveRatio = 10; // The case of this, I specify 10% as percentage of ratio. (After I need to divide by 100)
        uint32 _conversionFee = 1000;  // Fee: 1,000 (0.1%)
        bancorConverter.addConnector(iErc20, reserveRatio, true);
        //bancorConverter.addConnector(IERC20Token(ERC20tokenAddr), reserveRatio, true);
        bancorConverter.setConversionFee(_conversionFee);

        // Step #4: Funding & Initial Supply
        uint256 fundedAmount = 100;
        bancorConverter.fund(fundedAmount);

        // Step #5: Activation
        // Step #6: Multisig Ownership
        address _converterAddress;  // @notice - This variable is for receiving return value of createConverter() below
        // uint32 _maxConversionFee = 1;
        // _converterAddress = bancorConverterFactory.createConverter(smartToken, 
        //                                                            contractRegistry, 
        //                                                            _maxConversionFee, 
        //                                                            token, 
        //                                                            reserveRatio);
        bancorConverter.transferOwnership(msg.sender);   // @dev - Reference from Managed.sol 
        bancorConverter.transferManagement(msg.sender);  // @dev - Reference from Managed.sol 
        _converterAddress = address(bancorConverter);

        // Step #7: Converters Registry Listing
        bancorConverterRegistry.addConverter(IBancorConverter(_converterAddress));
    }




    /***********************************************************
     * @notice - Internal function below
     ***********************************************************/

}
