local gt = this.getroottable();

if (!("EL_PlayerOther" in gt.Const))
{
	gt.Const.EL_PlayerOther <- {};
}

gt.Const.EL_PlayerOther <- {

    EL_DogDamageMultFactor = 0.04,
    EL_DogArmorMultFactor = [
        0.04,
        0.04
    ],
    EL_DogPropertiesMultFactor = [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1
    ],

    EL_DonkeyAmmoMultFactor = 0.04,
    EL_DonkeyArmorPartsMultFactor = 0.04,
    EL_DonkeyMedsMultFactor = 0.04,
    EL_DonkeyStashMultFactor = 0.04,
    EL_DonkeyTerrainMultFactor = 0.04,

    EL_DonkeyAmmo = [
        100,
        200,
        500
    ],
    EL_DonkeyArmorParts = [
        60,
        120,
        300
    ],
    EL_DonkeyMeds = [
        60,
        120,
        300
    ],
    EL_DonkeyStash = [
        30,
        60,
        150
    ],
    EL_DonkeyTerrain = [
        0.1,
        0.2,
        0.5
    ],
};
