local gt = getroottable();

if (!("EL_RebuildTalent" in gt.Const))
{
	gt.Const.EL_RebuildTalent <- {};
}

gt.Const.EL_RebuildTalent <- {

    EL_TalentChance = [
        40,
        70,
        90,
        100
    ]

};
