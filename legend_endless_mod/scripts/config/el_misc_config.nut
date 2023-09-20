local gt = this.getroottable();

if (!("EL_Misc" in gt.Const))
{
	gt.Const.EL_Misc <- {};
}

gt.Const.EL_Misc <- {

	EL_Core = {
        XPChance = [
            [50, 100, 200, 400, 800],//Hitpoints
            [1, 5, 20, 50, 100],//Bravery
            [20, 50, 100, 200, 400],//Fatigue
            [20, 50, 100, 200, 400],//Initiative
            [5, 20, 50, 100, 200],//MeleeSkill
            [5, 20, 50, 100, 200],//RangedSkill
            [5, 20, 50, 100, 200],//MeleeDefense
            [5, 20, 50, 100, 200],//RangedDefense
        ],
        Value = [100, 200, 500, 1200, 2500],
        ValueIncreacePurXP = 0.1

    }

};