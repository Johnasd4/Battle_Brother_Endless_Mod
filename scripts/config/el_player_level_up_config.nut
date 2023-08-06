local gt = this.getroottable();

if (!("EL_PlayerLevelUp" in gt.Const))
{
	gt.Const.EL_PlayerLevelUp <- {};
}

gt.Const.EL_PlayerLevelUp <- {
    EL_PlayerLevelMax = 100,
    EL_PlayerLevelPart1 = 11,
    EL_PlayerLevelPart1Factor = 200,
    EL_PlayerLevelPart2Factor = 1.1,
    EL_PlayerLevelPart2PerkFrequency = 4,

    EL_PlayerDisplayHitpointsMax = 600,
    EL_PlayerDisplayBraveryMax = 600,
    EL_PlayerDisplayFatigueMax = 600,
    EL_PlayerDisplayInitiativeMax = 720,
    EL_PlayerDisplayMeleeSkillMax = 500,
    EL_PlayerDisplayRangeSkillMax = 500,
    EL_PlayerDisplayMeleeDefenseMax = 950,
    EL_PlayerDisplayRangeDefenseMax = 950,

    EL_CombatXPMaxDivFactor = 12.0,
    EL_CombatXPBelowWorldLevelMultFactor = 0.1,
    EL_CombatXPOverWorldLevelMultactor = 0.2
};

while (gt.Const.LevelXP.len() != 0)
{
    gt.Const.LevelXP.pop();
}

for( local level = 1, current_level_exp = 0, level_exp = 0; level <= gt.Const.EL_PlayerLevelUp.EL_PlayerLevelMax; ++level )
{
    level_exp += current_level_exp;
    if(level < gt.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1) {
        current_level_exp = (2 * level - 1) * gt.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1Factor;
    }
    else {
        current_level_exp *= gt.Const.EL_PlayerLevelUp.EL_PlayerLevelPart2Factor;
    }
	gt.Const.LevelXP.push(gt.Math.floor(level_exp));
}
