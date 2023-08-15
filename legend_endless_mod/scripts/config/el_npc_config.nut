local gt = this.getroottable();

if (!("EL_NPC" in gt.Const))
{
	gt.Const.EL_NPC <- {};
}

gt.Const.EL_NPC <- {

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

    EL_SubmitXPMultFactor = [
        1,
        3,
        10
    ],

    EL_ChampionXP = {
        Offset = [
            0,
            200,
            500
        ],
        MultFactor = [
            1,
            1.5,
            2.25
        ]
    },

    EL_ChampionCombatLevelOffset = [
        0,
        3,
        10
    ],

    EL_ChampionActionPointsOffset = [
        0,
        1,
        3
    ],

    EL_ChampionAttributes = {
        LevelToOffsetMult = [
            [0, 2, 3],
            [0, 0.2, 0.5],
            [0, 2, 3],
            [0, 1, 1.5],
            [0, 0.5, 0.75],
            [0, 0.5, 0.75],
            [0, 1, 1.5],
            [0, 1, 1.5]
        ],
        MultFactor = [
            [0, 1,5, 2.25],
            [0, 1,3, 1.7],
            [0, 1,5, 2.25],
            [0, 1,15, 1.3],
            [0, 1,15, 1.3],
            [0, 1,15, 1.3],
            [0, 1,2, 1.4],
            [0, 1,2, 1.4]
        ]
    },


};



