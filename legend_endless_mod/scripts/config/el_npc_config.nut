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
        XP = 8,
        CombatLevel = 9,
        MovePoints = 10,
        COUNT = 11
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
    }.

    EL_ChampionCombatLevelOffset = [
        0,
        3,
        10
    ].

    EL_ChampionAttributes = {
        LevelToOffsetMult = [
            [0,2,3],
            []
        ],
        MultFactor = [
            []
        ]
    },


};



