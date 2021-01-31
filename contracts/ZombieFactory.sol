// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

/**
 * @title Zombie Factory
 * @author Thanh-Quy Nguyen
 * @dev With natspecs norm
 */
contract ZombieFactory {
	event NewZombie(uint256 zombieId, string name, uint256 dna);

	uint256 private dnaDigits = 16;
	uint256 internal dnaModulus = 10**dnaDigits;

	struct Zombie {
		string name;
		uint256 dna;
	}

	Zombie[] public zombies;

	mapping(uint256 => address) public zombieToOwner;
	mapping(address => uint256) private ownerZombieCount;

	/**
	 * @dev A function to create a new zombies
	 * @param _name The name of the new zombie
	 * @param _dna The dna of the new zombie
	 */
	function _createZombie(string memory _name, uint256 _dna) internal {
		zombies.push(Zombie(_name, _dna));
		uint256 id = zombies.length - 1;
		zombieToOwner[id] = msg.sender;
		ownerZombieCount[msg.sender]++;

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

		// rand generated using keccak
		// typecast it to make it a uint
		// rand % dnaModulus: we return the rest of the division of (rand / dnaModulus)
		// Since dnaModulus = 10 ^ 16
		// => We return the 16 last digits of rand

		return rand % dnaModulus;
	}

	/**
	 * @dev A public function to create a zombie
	 * @param _name The name of our zombie
	 */
	function createRandomZombie(string memory _name) public {
		require(
			ownerZombieCount[msg.sender] == 0,
			"Each user can only call this function when they have no zombie"
		);

		uint256 randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}
}
