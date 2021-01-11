// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

/**
 * @title Zombie Factory
 * @author Thanh-Quy Nguyen
 * @dev With natspecs norm
 */
contract ZombieFactory {
	event NewZombie(uint256 zombieId, string name, uint256 dna);

	uint256 dnaDigits = 16;
	uint256 dnaModulus = 10**dnaDigits;

	struct Zombie {
		string name;
		uint256 dna;
	}

	Zombie[] public zombies;

	/**
	 * @dev A function to create a new zombies
	 * @param _name The name of the new zombie
	 * @param _dna The dna of the new zombie
	 */
	function _createZombie(string memory _name, uint256 _dna) private {
		zombies.push(Zombie(_name, _dna));
		emit NewZombie(zombies.length - 1, _name, _dna);
	}

	/**
	 * @dev A function to generate a random dna (uint) from a string
	 * @param _str An input string
	 */
	function _generateRandomDna(string memory _str)
		private
		view
		returns (uint256)
	{
		uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
		return rand % dnaModulus;
	}

	/**
	 * @dev A public function to create a zombie
	 * @param _name The name of our zombie
	 */
	function createRandomZombie(string memory _name) public {
		uint256 randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}
}
