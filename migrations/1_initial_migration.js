const tokenSale = artifacts.require("tokenSale");

module.exports = function (deployer) {
  deployer.deploy(tokenSale);
};
