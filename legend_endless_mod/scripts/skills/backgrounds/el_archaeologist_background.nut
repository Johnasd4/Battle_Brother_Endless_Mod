this.el_archaeologist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMin;
		this.character_background.create();
		this.m.ID = "background.el_archaeologist";
		this.m.Name = "周卓";
		this.m.Icon = "ui/backgrounds/background_47.png";
		this.m.BackgroundDescription = "周卓非常执着于探索世界的真相，但这种禁忌知识获取往往伴随着可怕的代价，等待周卓将会是何种结局？是葬身荒野，亦或是成为神明？";
		this.m.GoodEnding = "";
		this.m.BadEnding = "";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.strong",
			"trait.tough",
			"trait.superstitious",
			"trait.spartan",
			"trait.aggressive"
		];
		this.m.Titles = [
			"世界探索者"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Saintly;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BackgroundType = this.Const.BackgroundType.OffendedByViolence | this.Const.BackgroundType.Crusader | this.Const.BackgroundType.Educated;
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[1];
		this.m.Modifiers.Training = this.Const.LegendMod.ResourceModifiers.Training[2];
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.DaggerTree,
				this.Const.Perks.StaffTree,
				this.Const.Perks.ThrowingTree,
				this.Const.Perks.SpearTree
			],
			Defense = [
				this.Const.Perks.LightArmorTree
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.DeviousTree,
				this.Const.Perks.OrganisedTree,
				this.Const.Perks.InspirationalTree
			],
			Enemy = [],
			Class = [],
			Magic = [
				this.Const.Perks.PhilosophyMagicTree
			]
		};
	}

	function isExcluded( _id )
	{
		return true;
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
		this.m.GoodEnding = "Test Backgrond good ending.";
		this.m.BadEnding = "Test Backgrond bad ending.";
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
	}

});

