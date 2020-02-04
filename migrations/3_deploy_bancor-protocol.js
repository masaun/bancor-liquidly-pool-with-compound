var SmartToken = artifacts.require("SmartToken");
var BancorConverter = artifacts.require("BancorConverter");
var BancorConverterFactory = artifacts.require("BancorConverterFactory");


module.exports = function(deployer) {
  deployer.deploy(
    SmartToken, 
    BancorConverter,
    BancorConverterFactory,
  );
};
