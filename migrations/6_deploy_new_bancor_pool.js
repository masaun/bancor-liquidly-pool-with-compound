var NewBancorPool = artifacts.require("NewBancorPool");

/***
 * @notice - This is ContractAddress on Ropsten
 * @ref - https://support.bancor.network/hc/en-us/articles/360010410399-Ethereum-Ropsten-Network-
 * @ref - https://compound.finance/developers
 **/
const _contractRegistry = '0x8a69A7d7507F8c4a9dD5dEB9B687B30D2b30A011'
const _BNTtoken = '0x9C7d1F4a027C64Af951858FD0F9CB3C91e008829'
const _ERC20token = '0xad6d458402f60fd3bd25163575031acdce07538d'  // DAI on Ropsten
const _cDAI = '0x2b536482a01e620ee111747f8334b395a42a555e'        // cDAI on Ropsten

var SmartToken = artifacts.require("SmartToken")
//var BancorConverter = artifacts.require("BancorConverter")
//var BancorConverterFactory = artifacts.require("BancorConverterFactory")
const _smartToken = SmartToken.address
const _bancorConverter = '0x7ee55cD9AeFA96ED3450b93d23EED33A27826dA4'
//const _bancorConverterFactory = BancorConverterFactory.address
const _bancorConverterRegistry = '0x8bf88CFed154b0f6dbdC64cb35c829698b26c869'
var BancorConverterRegistryData = artifacts.require("BancorConverterRegistryData");
const _bancorConverterRegistryData = BancorConverterRegistryData.address;
const _bancorFormula = '0xbD2D011492E3b7bdc0d27b4aB2053f58FF6459d3'


module.exports = function(deployer) {
  deployer.deploy(
    NewBancorPool, 
    _contractRegistry,
    _BNTtoken,
    _ERC20token,
    _cDAI,
    _smartToken,
    _bancorConverter,
    //_bancorConverterFactory,
    _bancorConverterRegistry,
    _bancorConverterRegistryData,
    _bancorFormula    
  );
};
