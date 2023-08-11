local gt = getroottable();

if (!("EL_Player" in gt.Const))
{
	gt.Const.EL_Player <- {};
}

gt.Const.EL_Player <- {

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
