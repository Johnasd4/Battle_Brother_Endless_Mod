this.el_test_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.el_test";
		this.m.Name = "Test Scenario Name";
		this.m.Description = "Test description.";
		this.m.Difficulty = 1;
		this.m.Order = -1000;
		this.m.IsFixedLook = true;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(12);
		this.m.RosterTierMax = this.Const.Roster.getTierForSize(21);
		this.m.StartingBusinessReputation = 1000;
	}

	function isValid()
	{
		return true;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local bro = roster.create("scripts/entity/tactical/player");
		bro.m.HireTime = this.Time.getVirtualTimeF();
		bro.setName("Test Name 0");
		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"el_test_background"
		]);
		bros[0].m.HireTime = this.Time.getVirtualTimeF();
		bros[0].getBackground().buildDescription(true);
		bros[0].setTitle("测试");
		bros[0].setName("Test Name 0");
		bros[0].setPlaceInFormation(4);
		bros[0].getFlags().set("IsPlayerCharacter", true);
//		bros[0].getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		bros[0].m.LevelUps = 0;
//		bros[0].setVeteranPerks(2);
		bros[0].m.BaseProperties.ActionPoints = 1000;
		bros[0].m.BaseProperties.Hitpoints = 1000;
		bros[0].m.BaseProperties.Bravery = 1000;
		bros[0].m.BaseProperties.Stamina = 1000;
		bros[0].m.BaseProperties.Initiative = 1000;
		bros[0].m.BaseProperties.MeleeSkill = 1000;
		bros[0].m.BaseProperties.RangedSkill = 1000;
		bros[0].m.BaseProperties.MeleeDefense = 1000;
		bros[0].m.BaseProperties.RangedDefense = 1000;
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Flags.set("HasLegendCampTraining", true);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.m.Money = 999999;
		this.World.Assets.m.ArmorParts = 99;
		this.World.Assets.m.Medicine = 99;
		this.World.Assets.m.Ammo = 99;
	}

	function onSpawnPlayer()
	{
		local randomVillage;
		local northernmostY = 0;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			local v = this.World.EntityManager.getSettlements()[i];

			if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
			{
				northernmostY = v.getTile().SquareCoords.Y;
				randomVillage = v;
			}
		}
		randomVillage.setLastSpawnTimeToNow();
		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 2), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 2));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 2), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 2));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(6);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/barbarians_02.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.half_giant_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.BusinessReputationRate = 0.3;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}


});

