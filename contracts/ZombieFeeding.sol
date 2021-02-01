// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <=0.8.0;

import "./ZombieFactory.sol";

abstract contract KittyInterface {
	function getKitty(uint256 _id)
		external
		view
		virtual
		returns (
			bool isGestating,
			bool isReady,
			uint256 cooldownIndex,
			uint256 nextActionAt,
			uint256 siringWithId,
			uint256 birthTime,
			uint256 matronId,
			uint256 sireId,
			uint256 generation,
			uint256 genes
		);
}

/**
 * @title Zombie Feeding
 * @author Thanh-Quy Nguyen
 * @dev With natspecs norm
 */

contract ZombieFeeding is ZombieFactory {
	KittyInterface public kittyContract;

	function setKittyContractAddress(address _address) external onlyOwner {
		kittyContract = KittyInterface(_address);
	}

	/**
	 * @dev A public function that will process the multiplication of a zombie based on its feeding. Only the owner of the zombie can feed it.
	 * @param _zombieId The id of the zombie to be fed
	 * @param _targetDna The DNA of the target
	 * @param _species The species of the food
	 */
	function feedAndMultiply(
		uint256 _zombieId,
		uint256 _targetDna,
		string memory _species
	) internal {
		require(
			msg.sender == zombieToOwner[_zombieId],
			"Only the owner of the zombie can feed it"
		);
		Zombie storage myZombie = zombies[_zombieId];

		require(_isReady(myZombie));

		_targetDna = _targetDna % dnaModulus;
		uint256 newDna = (myZombie.dna + _targetDna) / 2;
		if (
			keccak256(abi.encodePacked(_species)) ==
			keccak256(abi.encodePacked("kitty"))
		) {
			newDna = newDna - (newDna % 100) + 99;
		}
		_createZombie("NoName", newDna);
		_triggerCooldown(myZombie);
	}

	/**
	 * @dev A public function that will allow a zombie to feed on kitty
	 * @param _zombieId The id of the zombie to be fed
	 * @param _kittyId The id of the kitty (from the CryptoKitties smart contract)
	 */
	function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
		uint256 kittyDna;

		(, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
		feedAndMultiply(_zombieId, kittyDna, "kitty");
	}
}
