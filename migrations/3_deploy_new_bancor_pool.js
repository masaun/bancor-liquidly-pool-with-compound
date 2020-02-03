var NewBancorPool = artifacts.require("NewBancorPool");

/***
 * @notice - contract address of ContractRegistry on Ropsten
 * @ref - https://support.bancor.network/hc/en-us/articles/360010410399-Ethereum-Ropsten-Network-
 **/
const _contractRegistry = '0x8a69A7d7507F8c4a9dD5dEB9B687B30D2b30A011'
const _BNTtoken = '0x9C7d1F4a027C64Af951858FD0F9CB3C91e008829'
const _ERC20token = ''


module.exports = function(deployer) {
  deployer.deploy(NewBancorPool, _contractRegistry);
};
