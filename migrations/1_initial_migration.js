const Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};


// module.exports = function(deployer, network, accounts) {
//     if (network == "production")
//         deployer.deploy(artifacts.require("Migrations"));
// };
