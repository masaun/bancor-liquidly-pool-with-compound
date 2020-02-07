var SmartToken = artifacts.require("SmartToken");
const _name = 'Test SmartToken'
const _symbol = 'TST'
const _decimals = 18

const _registry = '0xFD95E724962fCfC269010A0c6700Aa09D5de3074'  // Ropsten（from：https://docs.bancor.network/user-guides/network-data-and-stats/ethereum-contract-addresses）
//const _registry = '0x8bf88CFed154b0f6dbdC64cb35c829698b26c869'  // Ropsten（from：https://support.bancor.network/hc/en-us/articles/360010410399-Ethereum-Ropsten-Network-）
var BancorConverterRegistryData = artifacts.require("BancorConverterRegistryData");


module.exports = async function(deployer) {
  await deployer.deploy(SmartToken, _name, _symbol, _decimals);
  await deployer.deploy(BancorConverterRegistryData, _registry);
};
