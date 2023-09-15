local gt = this.getroottable();

if (!("EL_Item" in gt.Const))
{
	gt.Const.EL_Item <- {};
}

gt.Const.EL_Item <- {

	MaxLevel = 100,

	Colour = [
		"#646464",//gray
		"#006400",//green
		"#0000cc",//blue
		"#6400cc",//purple
		"#be5f00",//orange
		"#960000",//red
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
	}

};