local gt = this.getroottable();

if (!("EL_PlayerNPC" in gt.Const))
{
	gt.Const.EL_PlayerNPC <- {};
}

gt.Const.EL_PlayerNPC <- {

    EL_ExtraFatigueRecoveryDivFactor = 20,
    EL_ExtraFatigueRecoveryOffset = -3,

    EL_RankToMoraleMin = [
        0,
        1,
        2
    ]

};
