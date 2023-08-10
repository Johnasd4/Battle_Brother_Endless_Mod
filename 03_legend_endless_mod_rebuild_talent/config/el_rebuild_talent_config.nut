local gt = getroottable();

if (!("EL_RebuildTalent" in gt.Const))
{
	gt.Const.EL_RebuildTalent <- {};
}

gt.Const.EL_RebuildTalent <- {

    EL_TalentMax = 3,

    EL_TalentChance = [
        40,
        70,
        90,
        100
    ],

    EL_RankToTalentBonus = [
        0,
        1,
        2
    ]

};
