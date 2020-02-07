var SmartToken = artifacts.require("SmartToken");
const _name = 'Test SmartToken'
const _symbol = 'TST'
const _decimals = 18

var _registry = '0x8bf88CFed154b0f6dbdC64cb35c829698b26c869'  // This is contractAddr of BancorConverterRegistry.sol
var BancorConverterRegistryData = artifacts.require("BancorConverterRegistryData");


module.exports = async function(deployer) {
  await deployer.deploy(SmartToken, _name, _symbol, _decimals);
  await deployer.deploy(BancorConverterRegistryData, _registry);
};
