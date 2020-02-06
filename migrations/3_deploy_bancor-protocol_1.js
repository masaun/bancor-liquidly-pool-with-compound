var SmartToken = artifacts.require("SmartToken");
const _name = 'Test SmartToken'
const _symbol = 'TST'
const _decimals = 18

var BancorFormula = artifacts.require("BancorFormula");;


module.exports = async function(deployer) {
  await deployer.deploy(SmartToken, _name, _symbol, _decimals);
  await deployer.deploy(BancorFormula);
};
