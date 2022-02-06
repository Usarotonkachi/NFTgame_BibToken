const BibToken = artifacts.require("BibToken");

module.exports = function (deployer) {
  deployer.deploy(BibToken, "BibTokens", "BIBS");
};