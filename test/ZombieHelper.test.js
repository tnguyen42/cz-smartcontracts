require("chai").should();

const { soliditySha3, toBN, toWei } = require("web3-utils");

const { expectRevert } = require("@openzeppelin/test-helpers");
const { inTransaction } = require("@openzeppelin/test-helpers/src/expectEvent");
const { web3 } = require("@openzeppelin/test-helpers/src/setup");

const ZombieHelper = artifacts.require("ZombieHelper");

contract("ZombieHelper", function ([user0, user1]) {
	beforeEach(async () => {
		this.ZombieHelper = await ZombieHelper.new();
	});

	describe("Creating zombies", () => {
		it("should be able to change the name of a zombie", async () => {
			await this.ZombieHelper.createRandomZombie("MyZombie", { from: user0 });
			await this.ZombieHelper.levelUp(0, {
				value: toWei("0.001", "ether"),
			});

			await this.ZombieHelper.changeName(0, "NewName", { from: user0 });
		});

		it("should revert when trying to change the name of a zombie below level 2", async () => {
			await this.ZombieHelper.createRandomZombie("MyZombie", { from: user0 });

			await expectRevert(
				this.ZombieHelper.changeName(0, "NewName", { from: user0 }),
				"Level of the zombie should be higher."
			);
		});
	});
});
