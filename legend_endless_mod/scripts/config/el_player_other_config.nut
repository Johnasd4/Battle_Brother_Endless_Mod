local gt = this.getroottable();

if (!("EL_PlayerOther" in gt.Const))
{
	gt.Const.EL_PlayerOther <- {};
}

gt.Const.EL_PlayerOther <- {

    EL_Donkey = {
        AmmoMult = 0.04,
        ArmorPartsMult = 0.04,
        MedsMult = 0.04,
        StashMult = 0.04,
        TerrainMult = 0.04,
        Ammo = [
            100,
            200,
            500
        ],
        ArmorParts = [
            60,
            120,
            300
        ],
        Meds = [
            60,
            120,
            300
        ],
        Stash = [
            30,
            60,
            150
        ],
        Terrain = [
            0.1,
            0.2,
            0.5
        ]
    }
};
