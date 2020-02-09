var SmartToken = artifacts.require("SmartToken");
const _name = 'cDAIBNT Token'
const _symbol = 'cDAIBNT'
const _decimals = 18


module.exports = async function(deployer) {
  await deployer.deploy(SmartToken, _name, _symbol, _decimals);
};
