local gt = this.getroottable();

if (!("EL_PlayerLevelUp" in gt.Const))
{
	gt.Const.EL_PlayerLevelUp <- {};
}

gt.Const.EL_PlayerLevelUp <- {

    EL_PlayerLevelMax = 100,
    //Part1(level < 11), XP = 200 * level ^ 2
    EL_PlayerLevelPart1 = 11,
    EL_PlayerLevelPart1Factor = 200,
    //Part2, XP(level) = XP(level - 1) * 1.1
    EL_PlayerLevelPart2Factor = 1.1,
    EL_PlayerLevelPart2PerkFrequency = 4,

    EL_PlayerDisplayHitpointsMax = 600,
    EL_PlayerDisplayBraveryMax = 120,
    EL_PlayerDisplayFatigueMax = 600,
    EL_PlayerDisplayInitiativeMax = 720,
    EL_PlayerDisplayMeleeSkillMax = 500,
    EL_PlayerDisplayRangeSkillMax = 500,
    EL_PlayerDisplayMeleeDefenseMax = 950,
    EL_PlayerDisplayRangeDefenseMax = 950,

    EL_CombatXPMaxDivFactor = 12.0,
    // XP * (1 + (WorldLevel - Level - 5) * 0.2) ^ 2 (Level < WorldLevel - 5)
    EL_CombatXPBelowWorldLevelOffset = 5,
    EL_CombatXPBelowWorldLevelMultFactor = 0.2,
    // XP / (1 + (Level - WorldLevel - 0) * 0.2) ^ 2 (Level > WorldLevel - 0)
    EL_CombatXPOverWorldLevelOffset = 0,
    EL_CombatXPOverWorldLevelMultactor = 0.2

    EL_Attributes = {
        Hitpoints = 0,
        Bravery = 1,
        Fatigue = 2,
        Initiative = 3,
        MeleeSkill = 4,
        RangedSkill = 5,
        MeleeDefense = 6,
        RangedDefense = 7,
        COUNT = 8
    },

    EL_LevelUpAttributes = [
        {//Hitpoints
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//Bravery
            Min = [0, 1, 1, 3],
            Max = [1, 1, 2, 4]
        },
        {//Fatigue
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//Initiative
            Min = [3, 4, 5, 5],
            Max = [5, 5, 5, 6]
        },
        {//MeleeSkill
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        },
        {//RangedSkill
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//MeleeDefense
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        },
        {//RangedDefense
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        }
    ]

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


