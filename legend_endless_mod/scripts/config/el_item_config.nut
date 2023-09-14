local gt = this.getroottable();

if (!("EL_Item" in gt.Const))
{
	gt.Const.EL_Item <- {};
}

gt.Const.EL_Item <- {
    EL_ItemLevelMax = 100,

	EL_RankColour = [
		"#646464",//灰
		"#006400",//绿
		"#0000cc",//蓝
		"#6400cc",//紫
		"#be5f00",//橙
		"#960000",//红
		"#aa00ff"// 粉
	]
};