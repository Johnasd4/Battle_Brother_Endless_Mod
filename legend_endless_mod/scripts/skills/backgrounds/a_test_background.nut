this.a_test_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMin;
		this.character_background.create();
		this.m.ID = "background.a_test";
		this.m.Name = "Test";
		this.m.Icon = "ui/backgrounds/background_58.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "Test.";
		this.m.BadEnding = "Test.";
		this.m.HiringCost = 30000;
		this.m.DailyCost = 100;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.fear_nobles",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.slack",
			"trait.frail",
			"trait.gift_of_people",
			"trait.seductive"
		];
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = 5;
		this.m.BackgroundType = this.Const.BackgroundType.Combat;
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Notorious;
		this.m.Modifiers.Ammo = 0;
		this.m.Modifiers.ArmorParts = 0;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[3];
			this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[3];
			this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[3];
			this.m.Modifiers.Scout = this.Const.LegendMod.ResourceModifiers.Scout[3];
			this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[3];
		this.m.Modifiers.Terrain = [
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0,
			4.0
		];
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.AxeTree,
				this.Const.Perks.HammerTree,
				this.Const.Perks.MaceTree,
				this.Const.Perks.CleaverTree,
               	this.Const.Perks.TwoHandedTree

			],
			Defense = [
				this.Const.Perks.HeavyArmorTree,
				this.Const.Perks.MediumArmorTree,
                this.Const.Perks.LightArmorTree
			],
			Traits = [
 				this.Const.Perks.ViciousTree,
				this.Const.Perks.FitTree,
				this.Const.Perks.CalmTree,
				this.Const.Perks.TrainedTree,
				this.Const.Perks.TalentedTree,
                this.Const.Perks.LargeTree,
                this.Const.Perks.IntelligentTree,
                this.Const.Perks.IndestructibleTree,
               	this.Const.Perks.SturdyTree
			],
			Enemy = [],
			Class = [this.Const.Perks.WildlingProfessionTree],
			Magic = []
		};
	}

	function setGender( _gender = -1 )
	{
		if (_gender == -1)
		{
			_gender = 0;
		}

		if (_gender != 1)
		{
			return;
		}

		this.m.Faces = this.Const.Faces.AllWhiteFemale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.AllFemale;
		this.addBackgroundType(this.Const.BackgroundType.Female);
		this.m.GoodEnding = "%name% the barbarian took all the coin she earned with the company and ventured north. With her money, she gathered a band of warriors and conquered so many tribes that, last you heard, she had been ordained \'queen of the north\'.";
		this.m.BadEnding = "With things the way they were, %name% departed. Last you heard she was traveling north. Penniless with little to her name but an axe, and not looking anything like the natives or speaking their tongue, you figure the barbarian did not get far. Based upon what you\'ve seen happen to her ilk, she\'s either been killed already or captured as a slave.";
	}

	function onBuildDescription()
	{
		if (this.isBackgroundType(this.Const.BackgroundType.Female))
		{
			return "{%name% survived the battle between yourself and her own tribe of warriors. She offered herself to your company or to your sword. Impressed by his bravery, you chose to take her in. A foreign brute, she hardly speaks your native tongue and she is not well liked by the rest of the company. But if anything can bond two people it is fighting beside one another, killing when it counts, and drinking the night away at the tavern.}";
		}
		else
		{
			return "{%name% survived the battle between yourself and his own tribe of warriors. He offered himself to your company or to your sword. Impressed by his bravery, you chose to take him in. A foreign brute, he hardly speaks your native tongue and he is not well liked by the rest of the company. But if anything can bond two men it is fighting beside one another, killing when it counts, and drinking the night away at the tavern.}";
		}
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoos = [
			3,
			4,
			5,
			6
		];

		if (this.Math.rand(1, 100) <= 66)
		{
			this.m.Tattoo = tattoos[this.Math.rand(0, tattoos.len() - 1)];
			local tattoo_body = actor.getSprite("tattoo_body");
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_head = actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				30,
				25
			],
			Bravery = [
				20,
				15
			],
			Stamina = [
				50,
				45
			],
			MeleeSkill = [
				10,
				5
			],
			RangedSkill = [
				-40,
				-45
			],
			MeleeDefense = [
				10,
				5
			],
			RangedDefense = [
				10,
				5
			],
			Initiative = [
				-100,
				-95
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});

