var BancorConverter = artifacts.require("BancorConverter");
var SmartToken = artifacts.require("SmartToken");
const _token = SmartToken.address
const _registry = '0x8a69A7d7507F8c4a9dD5dEB9B687B30D2b30A011'
const _maxConversionFee = 1
const _reserveToken = '0xad6d458402f60fd3bd25163575031acdce07538d'  // DAI on Ropsten
const _reserveRatio = 10

//var BancorConverterFactory = artifacts.require("BancorConverterFactory");


module.exports = async function(deployer) {
  await deployer.deploy(BancorConverter, _token, _registry, _maxConversionFee, _reserveToken, _reserveRatio);
  //await deployer.deploy(BancorConverterFactory);
};
