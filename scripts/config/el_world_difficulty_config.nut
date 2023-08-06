local gt = getroottable();

if (!("EL_WorldDifficulty" in gt.Const))
{
	gt.Const.EL_WorldDifficulty <- {};
}

gt.Const.EL_WorldDifficulty <- {

    EL_WorldDifficultySelectDistanceDay = 40,

    EL_WorldLevelMin = 0,
    EL_WorldLevelMax = 100,
    EL_WorldLevelLevelUpBaseDay = 7,
    EL_WorldLevelLevelUpMultFactor = 1.03,

    EL_WorldStrengthMin = 40,
    EL_WorldStrengthOffsetBase = 0,

    EL_WorldLevelDay = [],

    EL_WorldStrengthAddSpeed = [
        10,
        6,
        4,
        3
    ],

    EL_WorldStrengthAddSpeedChangeDay = [
        0,
        15,
        50,
        100
    ],

    EL_WorldStrengthOffset = [],

    EL_WorldDifficultyStartMultFactor = [
        0.4,
        0.6,
        0.8,
        1
    ],

    EL_WorldDifficultyEventMultFactor = [
        0.1,
        0.4,
        0.7,
        1,
        1.5,
        2.2,
        3.3,
        5,
        7.5,
        10
    ]

};

//World level
for( local level = 0, current_level_day_needed = this.Const.EL_WorldDifficulty.EL_WorldLevelLevelUpBaseDay, level_day_need = 0;
    level < this.Const.EL_WorldDifficulty.EL_WorldLevelMax; ++level )
{
	level_day_need += current_level_day_needed;
    current_level_day_needed *= this.Const.EL_WorldDifficulty.EL_WorldLevelLevelUpMultFactor;
    this.Const.EL_WorldDifficulty.EL_WorldLevelDay.push(level_day_need);
}

//World stength
this.Const.EL_WorldDifficulty.EL_WorldStrengthOffset.push(this.Const.EL_WorldDifficulty.EL_WorldStrengthOffsetBase);
for( local count = 0, offset = this.Const.EL_WorldDifficulty.EL_WorldStrengthOffsetBase;
	 count < this.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeed.len() - 1; ++count )
{

    offset += this.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeed[count] *
              this.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay[count + 1]
                               this.Const.EL_WorldDifficulty.EL_WorldLevelLevelUpMultFactor;
	this.Const.EL_WorldDifficulty.EL_WorldStrengthOffset.push(offset);
}
