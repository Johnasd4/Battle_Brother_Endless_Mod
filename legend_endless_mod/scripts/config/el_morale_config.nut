local gt = this.getroottable();

if (!("EL_Morale" in gt.Const))
{
	gt.Const.EL_Morale <- {};
}

gt.Const.EL_Morale <- {
    HeadCount = {
        Factor1 = 2,
        Factor2 = 2,
        Factor3 = 2
    },
    Hit = {
        PersentPurCheck = 20,
        Factor1 = 10,
        Factor2 = 0.5,
        Factor3 = 2
    },
    Death = {
        BaseOffset = 0,
        RankFactor = 25,
        CombatLevelFactor = 1.04,
        DistanceFactor = 3
    },
    Move = {
        BaseOffset = 50,
        RankFactor = 25,
        CombatLevelFactor = 1.04,
    },
    Fleeing = {
        BaseOffset = 25,
        RankFactor = 25,
        CombatLevelFactor = 1.04,
        DistanceFactor = 3
    },

    Effect = {
        BraveryOffset = [-30, -20, -10, 0, 10, 0],
        InitiativeOffset = [-30, -20, -10, 0, 10, 0],
        MeleeSkillOffset = [-30, -20, -10, 0, 10, 0],
        RangedSkillOffset = [-30, -20, -10, 0, 10, 0],
        MeleeDefenseOffset = [-30, -20, -10, 0, 10, 0],
        RangedDefenseOffset = [-30, -20, -10, 0, 10, 0],
        FatigueOnSkillUseOffset = [3, 2, 1, 0, -1, 0],
        DamageDirectMult = [0.7, 0.8, 0.9, 1, 1.1, 1],
        DamageReceivedTotalMult = [1.3, 1.2, 1.1, 1, 0.9, 1],
    }
}
