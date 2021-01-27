// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

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
	function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
		require(
			msg.sender == zombieToOwner[_zombieId],
			"Only the owner of the zombie can feed it"
		);
		Zombie storage myZombie = zombies[_zombieId];

		_targetDna = _targetDna % dnaModulus;
		uint256 newDna = (myZombie.dna + _targetDna) / 2;
		_createZombie("NoName", newDna);
	}
}
