var BancorConverterFactory = artifacts.require("BancorConverterFactory");


module.exports = async function(deployer) {
  await deployer.deploy(BancorConverterFactory);
};
