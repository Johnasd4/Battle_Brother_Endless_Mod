local gt = this.getroottable();

if (!("EL_Item" in gt.Const))
{
	gt.Const.EL_Item <- {};
}

gt.Const.EL_Item <- {
	MaxLevel = 50,
	MaxRankLevel = {
		Normal = 2,
		Named = 3,
		Only = 4
	},
	Colour = [
		"#646464",//gray
		"#006400",//green
		"#0000cc",//blue
		"#6400cc",//purple
		"#be5f00",//orange
		"#640000",//red
		"#aa00ff"//pink
	],
	Type = {
		Normal = 0,
		Premium = 1,
		Fine = 2,
		Epic = 3,
		Legendary = 4,
		Rare = 5,
		Special = 6
	},
	ArmorType = {
		UnlayeredArmor = -1,
		BaseArmor = 0,
		ArmorUpgrade = 1
	}
};

gt.Const.CharacterProperties.EL_DamageBodyArmorReduction <- 0;
gt.Const.CharacterProperties.EL_DamageHeadArmorReduction <- 0;
gt.Const.CharacterProperties.EL_DamageBodyRegularReduction <- 0;
gt.Const.CharacterProperties.EL_DamageHeadRegularReduction <- 0;