this.el_archaeologist_scenario_4 <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		OnInitOrigin = false,
		CanHire = false
	},
	function create()
	{
		this.m.ID = "scenario.el_archaeologist_scenario_4";
		this.m.Name = "无尽-真相追求者（传奇）";
		this.m.Description = "[p=c][img]gfx/ui/events/event_17.png[/img][/p][p]著名的考古学家周卓，想要追寻世界的真相，然而这种禁忌的知识是具有生命的，知道的越多，受到的影响越大，对此周卓并不在意，他愿意为此付出一切。\n\n[color=#bcad8c]独有机制:[/color] 每隔 5 天会发掘一部分世界的真相，会对全队造成永久的影响。\n[color=#bcad8c]人嫌狗弃:[/color] 初始人数上限为3，声望获取速度为66%，招募费用与工资为原本的150%。\n[color=#bcad8c]世界真相（传奇）:[/color] 世界真相会带来正面影响和较大的负面影响。\n[color=#bcad8c]化身:[/color] 如果周卓死了，战役就结束了。[/p]";
		this.m.Difficulty = 1;
		this.m.Order = -5;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(3);
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local bro = roster.create("scripts/entity/tactical/player");
		bro.m.HireTime = this.Time.getVirtualTimeF();
		bro.setStartValuesEx([
			"el_archaeologist_background"
		], true, -1, true, 2);
		bro.getBackground().buildDescription();
		bro.m.BaseProperties.ActionPoints = 9;
		bro.m.BaseProperties.Hitpoints = 60;
		bro.m.BaseProperties.Bravery = 100;
		bro.m.BaseProperties.Stamina = 100;
		bro.m.BaseProperties.Initiative = 50;
		bro.m.BaseProperties.MeleeSkill = 50;
		bro.m.BaseProperties.RangedSkill = 50;
		bro.m.BaseProperties.MeleeDefense = 0;
		bro.m.BaseProperties.RangedDefense = 0;
		local talents = bro.getTalents();
		for (local i = 0; i < talents.len(); i++)
		{
			talents[i] = 4;
		}
		bro.setPlaceInFormation(4);
		bro.getFlags().set("IsPlayerCharacter", true);
		bro.getSkills().add(this.new("scripts/skills/el_traits/el_archaeologist_trait"));
		bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		this.World.Flags.set("ELArchaeologistDifficulty", this.Const.Difficulty.Legendary);
		this.World.Assets.m.BusinessReputation = -500;
		this.World.Assets.m.Money = 5000;
		this.World.Assets.m.ArmorParts = 20;
		this.World.Assets.m.Medicine = 20;
		this.World.Assets.m.Ammo = 20;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}

			i = ++i;
			i = i;
		}

		local randomVillageTile = randomVillage.getTile();
		this.World.Flags.set("HomeVillage", randomVillage.getName());
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(112);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(40.0, "Considered local heroes for keeping the village safe");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.BusinessReputationRate = 0.66;
	}

	function onUpdateHiringRoster( _roster )
	{
		local bros = _roster.getAll();
		foreach( i, bro in bros )
		{
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 1.5);
			bro.getBaseProperties().DailyWageMult *= 1.5;
		}
	}
});