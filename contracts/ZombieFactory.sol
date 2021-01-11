pragma solidity 0.8.0;

/**
 * @title Zombie Factory
 * @author Thanh-Quy Nguyen
 * @dev With natspecs norm
 */
contract ZombieFactory {
	uint256 dnaDigits = 16;
	uint256 dnaModulus = 10**dnaDigits;

	struct Zombie {
		string name;
		uint256 dna;
	}

	Zombie[] public zombies;

	function _createZombie(string memory _name, uint256 _dna) private {
		zombies.push(Zombie(_name, _dna));
	}
}
