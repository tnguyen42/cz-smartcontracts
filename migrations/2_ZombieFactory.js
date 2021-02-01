const ZombieFactory = artifacts.require("ZombieFactory.sol");

module.exports = function (deployer) {
	return deployer
		.then(() => {
			console.log("Deploying ZombieFactory...");
			return deployer.deploy(ZombieFactory);
		})
		.then(() => {
			console.log("ZombieFactory successfully deployed.");
		});
};
