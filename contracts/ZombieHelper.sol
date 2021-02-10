// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <=0.8.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
	uint256 levelUpFee = 0.001 ether;

	/**
	 * @dev A modifier to limit the actions depending on the level of a given zombie
	 * @param _level The minimum level required for the zombie
	 * @param _zombieId The id of the zombie to which the action will be applied to / will depend on
	 */
	modifier aboveLevel(uint256 _level, uint256 _zombieId) {
		require(
			zombies[_zombieId].level >= _level,
			"Level of the zombie should be higher."
		);
		_;
	}

	/**
	 * @dev A function to allow renaming a zombie.
	 * A zombie can only be renamed above level 2
	 * @param _zombieId The id of the zombie to be renamed
	 * @param _newName The new name of the zombie
	 */
	function changeName(uint256 _zombieId, string calldata _newName)
		external
		aboveLevel(2, _zombieId)
		ownerOf(_zombieId)
	{
		require(
			msg.sender == zombieToOwner[_zombieId],
			"Only the owner of the zombie can change its name"
		);
		zombies[_zombieId].name = _newName;
	}

	/**
	 * @dev A function to change the DNA of a zombie. A zombie can only be renamed above level 20.
	 * @param _zombieId The id of the zombie to be renamed
	 * @param _newDna The new DNA of the zombie
	 */
	function changeDna(uint256 _zombieId, uint256 _newDna)
		external
		aboveLevel(20, _zombieId)
		ownerOf(_zombieId)
	{
		require(
			msg.sender == zombieToOwner[_zombieId],
			"Only the owner of the zombie can change its name"
		);
		zombies[_zombieId].dna = _newDna;
	}

	/**
	 * @dev A function to get all the zombies owned by a given owner
	 * @param _owner The address of the owner
	 * @return The zombies owned by the _owner
	 */
	function getZombiesByOwner(address _owner)
		external
		view
		returns (uint256[] memory)
	{
		uint256[] memory result = new uint256[](ownerZombieCount[_owner]);

		uint256 counter = 0;

		for (uint256 i = 0; i < zombies.length; i++) {
			if (zombieToOwner[i] == _owner) {
				result[counter] = i;
				counter++;
			}
		}

		return result;
	}

	/**
	 * @dev A function to allow a player to pay a fee in exchange of zombie level up
	 * @param _zombieId The id of the zombie to be leveled up
	 */
	function levelUp(uint256 _zombieId) external payable {
		require(
			msg.value == levelUpFee,
			"Ethers send doesn't match the levelUpFee"
		);
		zombies[_zombieId].level++;
	}

	/**
	 * @dev A function allowing the owner of the smart contract to withdraw all the funds at the contract's address
	 */
	function withdraw() external onlyOwner {
		address payable _owner = payable(owner());
		_owner.transfer(address(this).balance);
	}

	/**
	 * @dev A function allowing the owner of the smart contract to change the fee to level up a zombie
	 * @param _fee The new value of the fee
	 */
	function setLevelUpFee(uint256 _fee) external onlyOwner {
		levelUpFee = _fee;
	}
}
