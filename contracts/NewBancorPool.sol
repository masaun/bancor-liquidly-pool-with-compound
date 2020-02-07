pragma solidity 0.4.26;

// Bancor-Protocol
import "./bancor-protocol/utility/ContractRegistry.sol";          // Step #1: Initial Setup
import "./bancor-protocol/utility/ContractRegistryClient.sol";
import "./bancor-protocol/token/SmartToken.sol";                  // Step #2: Smart Relay Token Deployment
import "./bancor-protocol/token/SmartTokenController.sol";                   // Step #7: Converters Registry Listing
import "./bancor-protocol/token/interfaces/ISmartToken.sol";                  // Step #7: Converters Registry Listing
//import "./bancor-protocol/converter/BancorConverter.sol";         // Step #3: Converter Deployment
//import "./bancor-protocol/converter/BancorConverterFactory.sol";  // Step #5: Activation and Step #6: Multisig Ownership
import "./bancor-protocol/converter/interfaces/IBancorConverterFactory.sol";

import "./bancor-protocol/converter/BancorConverterRegistry.sol"; // Step #7: Converters Registry Listing
import "./bancor-protocol/converter/BancorConverterRegistryData.sol";

//import "./bancor-protocol/token/ERC20Token.sol";
import './bancor-protocol/token/interfaces/IERC20Token.sol';

import './bancor-protocol/utility/Managed.sol';
import './bancor-protocol/converter/BancorFormula.sol';


// Storage
import "./storage/BnStorage.sol";
import "./storage/BnConstants.sol";


contract NewBancorPool is BnStorage, BnConstants, Managed, ContractRegistryClient {

    ContractRegistry public contractRegistry;
    ContractRegistryClient public contractRegistryClient;

    SmartToken public smartToken;
    //BancorConverter public bancorConverter;
    //BancorConverterFactory public bancorConverterFactory;
    BancorConverterRegistry public bancorConverterRegistry;
    BancorConverterRegistryData public bancorConverterRegistryData;

    BancorFormula public bancorFormula;

    IERC20Token public token;

    address BNTtokenAddr;
    address ERC20tokenAddr;
    address cDAItokenAddr;   // cToken from compound pool

    address smartTokenAddr;

    address BANCOR_CONVERTER_REGISTRY_DATA;
    address BANCOR_FORMULA;  // ContractAddress of BancorFormula.sol


    constructor(
        address _contractRegistry,
        //address _contractRegistryClient,
        address _BNTtokenAddr,
        address _ERC20tokenAddr,
        address _cDAItokenAddr,
        address _smartToken,
        //address _bancorConverter,
        //address _bancorConverterFactory,
        address _bancorConverterRegistry,
        address _bancorConverterRegistryData,
        address _bancorFormula
    ) 
        public
    {
        // Step #1: Initial Setup
        contractRegistry = ContractRegistry(_contractRegistry);
        //contractRegistryClient = ContractRegistryClient(_contractRegistryClient);

        BNTtokenAddr = _BNTtokenAddr;
        ERC20tokenAddr = _ERC20tokenAddr;
        cDAItokenAddr = _cDAItokenAddr;  // cToken from compound pool

        smartTokenAddr = _smartToken;

        BANCOR_CONVERTER_REGISTRY_DATA = _bancorConverterRegistryData;
        BANCOR_FORMULA = _bancorFormula;

        token = IERC20Token(ERC20tokenAddr);

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

    function testFuncCallBancorNetworkContractAddr() public view returns (address _bancorNetwork) {
        address bancorNetwork;
        bancorNetwork = contractRegistry.addressOf('BancorNetwork');
        return bancorNetwork;
    }

    function testFuncCallBancorConverterFactoryContractAddr() public view returns (IBancorConverterFactory) {
        //address bancorConverterFactory;
        IBancorConverterFactory bancorConverterFactory = IBancorConverterFactory(addressOf(BANCOR_CONVERTER_FACTORY));
        //bancorConverterFactory = contractRegistry.addressOf('BancorConverterFactory');
        return bancorConverterFactory;
    }
    
    function testFuncCallBancorConverterUpgraderContractAddr() public view returns (address _bancorConverterUpgrader) {
        address bancorConverterUpgrader;
        bancorConverterUpgrader = contractRegistry.addressOf('BancorConverterUpgrader');
        return bancorConverterUpgrader;
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
        uint32 reserveRatio = 10; // The case of this, I specify 10% as percentage of ratio. (After I need to divide by 100)
        //uint32 _conversionFee = 1000;  // Fee: 1,000 (0.1%)

        addConnector(IERC20Token(ERC20tokenAddr), reserveRatio, true);
        //bancorConverter.addConnector(IERC20Token(ERC20tokenAddr), reserveRatio, true);
        //bancorConverter.setConversionFee(_conversionFee);

        // Step #4: Funding & Initial Supply
        uint256 fundedAmount = 100;
        fund(fundedAmount);
        //bancorConverter.fund(fundedAmount);

        // Step #5: Activation
        // Step #6: Multisig Ownership
        address _converterAddress;  // @notice - This variable is for receiving return value of createConverter() below
        uint32 _maxConversionFee = 1;
        // _converterAddress = bancorConverterFactory.createConverter(smartToken, 
        //                                                            contractRegistry, 
        //                                                            _maxConversionFee, 
        //                                                            token, 
        //                                                            reserveRatio);

        // Step #7: Converters Registry Listing
        bancorConverterRegistry.addConverter(IBancorConverter(_converterAddress));
    }




    /***********************************************************
     * @notice - Internal function from BancorConverter.sol
     ***********************************************************/
    uint32 private constant RATIO_RESOLUTION = 1000000;
    uint64 private constant CONVERSION_FEE_RESOLUTION = 1000000;

    /**
      * @dev version number
    */
    uint16 public version = 25;

    IWhitelist public conversionWhitelist;          // whitelist contract with list of addresses that are allowed to use the converter
    IERC20Token[] public reserveTokens;             // ERC20 standard token addresses (prior version 17, use 'connectorTokens' instead)

    struct Reserve {
        uint256 virtualBalance;         // reserve virtual balance
        uint32 ratio;                   // reserve ratio, represented in ppm, 1-1000000
        bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
        bool isSaleEnabled;             // is sale of the reserve token enabled, can be set by the owner
        bool isSet;                     // used to tell if the mapping element is defined
    }
    mapping (address => Reserve) public reserves;   // reserve token addresses -> reserve data (prior version 17, use 'connectors' instead)
    
    uint32 private totalReserveRatio = 0;           // used to efficiently prevent increasing the total reserve ratio above 100%
    uint32 public maxConversionFee = 0;             // maximum conversion fee for the lifetime of the contract,
                                                    // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
    uint32 public conversionFee = 0;                // current conversion fee, represented in ppm, 0...maxConversionFee
    bool public conversionsEnabled = true;          // deprecated, backward compatibility


    // event Conversion(
    //     address indexed _fromToken,
    //     address indexed _toToken,
    //     address indexed _trader,
    //     uint256 _amount,
    //     uint256 _return,
    //     int256 _conversionFee
    // );

    event PriceDataUpdate(
        address indexed _connectorToken,
        uint256 _tokenSupply,
        uint256 _connectorBalance,
        uint32 _connectorWeight
    );

    event SmartTokenAdded(address indexed _smartToken);
    event LiquidityPoolAdded(address indexed _liquidityPool);
    event ConvertibleTokenAdded(address indexed _convertibleToken, address indexed _smartToken);


    // validates reserve ratio
    modifier validReserveRatio(uint32 _ratio) {
        require(_ratio > 0 && _ratio <= RATIO_RESOLUTION);
        _;
    }

    // allows execution only on a multiple-reserve converter
    modifier multipleReservesOnly {
        require(reserveTokens.length > 1);
        _;
    }


    function addConnector(IERC20Token _token, uint32 _weight, bool /*_enableVirtualBalance*/) public {
        addReserve(_token, _weight);
    }

    function addReserve(IERC20Token _token, uint32 _ratio)
        public
        ownerOnly
        //inactive
        //validAddress(_token)
        //notThis(_token)
        validReserveRatio(_ratio)
    {
        //require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= RATIO_RESOLUTION); // validate input

        reserves[_token].ratio = _ratio;
        reserves[_token].isVirtualBalanceEnabled = false;
        reserves[_token].virtualBalance = 0;
        reserves[_token].isSaleEnabled = true;
        reserves[_token].isSet = true;
        reserveTokens.push(_token);
        totalReserveRatio += _ratio;
    }    


    /**
      * @dev updates the current conversion fee
      * can only be called by the manager
      * 
      * @param _conversionFee new conversion fee, represented in ppm
    */
    // event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);

    // function setConversionFee(uint32 _conversionFee)
    //     public
    //     ownerOrManagerOnly
    // {
    //     require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
    //     emit ConversionFeeUpdate(conversionFee, _conversionFee);
    //     conversionFee = _conversionFee;
    // }


    /**
      * @dev buys the token with all reserve tokens using the same percentage
      * for example, if the caller increases the supply by 10%,
      * then it will cost an amount equal to 10% of each reserve token balance
      * note that the function can be called only when conversions are enabled
      * 
      * @param _amount  amount to increase the supply by (in the smart token)
    */
    function fund(uint256 _amount)
        public
        multipleReservesOnly
    {
        uint256 supply = smartToken.totalSupply();
        IBancorFormula formula = IBancorFormula(BANCOR_FORMULA);

        // iterate through the reserve tokens and transfer a percentage equal to the ratio between _amount
        // and the total supply in each reserve from the caller to the converter
        IERC20Token reserveToken;
        uint256 reserveBalance;
        uint256 reserveAmount;
        for (uint16 i = 0; i < reserveTokens.length; i++) {
            reserveToken = reserveTokens[i];
            reserveBalance = reserveToken.balanceOf(this);
            reserveAmount = formula.calculateFundCost(supply, reserveBalance, totalReserveRatio, _amount);

            Reserve storage reserve = reserves[reserveToken];

            // transfer funds from the caller in the reserve token
            ensureTransferFrom(reserveToken, msg.sender, this, reserveAmount);

            // dispatch price data update for the smart token/reserve
            emit PriceDataUpdate(reserveToken, supply + _amount, reserveBalance + reserveAmount, reserve.ratio);
        }

        // issue new funds to the caller in the smart token
        smartToken.issue(msg.sender, _amount);
    }

    function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
        // We must assume that functions `transfer` and `transferFrom` do not return anything,
        // because not all tokens abide the requirement of the ERC20 standard to return success or failure.
        // This is because in the current compiler version, the calling contract can handle more returned data than expected but not less.
        // This may change in the future, so that the calling contract will revert if the size of the data is not exactly what it expects.
        uint256 prevBalance = _token.balanceOf(_to);
        if (_from == address(this))
            INonStandardERC20(_token).transfer(_to, _amount);
        else
            INonStandardERC20(_token).transferFrom(_from, _to, _amount);
        uint256 postBalance = _token.balanceOf(_to);
        require(postBalance > prevBalance);
    }



    function addConverter() external {
        // validate input
        //require(isConverterValid(_converter));

        BancorConverterRegistryData converterRegistryData = BancorConverterRegistryData(BANCOR_CONVERTER_REGISTRY_DATA);
        uint reserveTokenCount = connectorTokenCount();

        // add the smart token
        addSmartToken(converterRegistryData, smartTokenAddr);
        if (reserveTokenCount > 1)
            addLiquidityPool(converterRegistryData, smartTokenAddr);
        else
            addConvertibleToken(converterRegistryData, smartTokenAddr, smartTokenAddr);

        // add all reserve tokens
        for (uint i = 0; i < reserveTokenCount; i++)
            addConvertibleToken(converterRegistryData, reserveTokens[i], token);
    }

    function connectorTokenCount() public view returns (uint16) {
        return reserveTokenCount();
    }

    function reserveTokenCount() public view returns (uint16) {
        return uint16(reserveTokens.length);
    }

    function addSmartToken(IBancorConverterRegistryData _converterRegistryData, address _smartToken) internal {
        _converterRegistryData.addSmartToken(_smartToken);
        emit SmartTokenAdded(_smartToken);
    }

    function addLiquidityPool(IBancorConverterRegistryData _converterRegistryData, address _liquidityPool) internal {
        _converterRegistryData.addLiquidityPool(_liquidityPool);
        emit LiquidityPoolAdded(_liquidityPool);
    }

    function addConvertibleToken(IBancorConverterRegistryData _converterRegistryData, address _convertibleToken, address _smartToken) internal {
        _converterRegistryData.addConvertibleToken(_convertibleToken, _smartToken);
        emit ConvertibleTokenAdded(_convertibleToken, _smartToken);
    }
}
