const SmartContract = artifacts.require("SmartContract"); // Change this to what your Contract Name is in Solidity

module.exports = function (deployer) {
  deployer.deploy(SmartContract, "Lolpops", "POPS", "https://gateway.pinata.cloud/ipfs/QmQumiBhgGq8gn4tgpUrFdNESuU7gvzrQohafiWyhdUYoq/"); //
};
