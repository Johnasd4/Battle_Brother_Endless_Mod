local gt = getroottable();

::mods_registerMod("el_player_other", 1, "el_player_other");
::mods_queue(null, ">el_player", function ()
{
	::mods_hookExactClass("skills/backgrounds/legend_puppet_background", function ( o )
	{
		o.adjustHiringCostBasedOnEquipment = function ()
		{
            this.character_background.adjustHiringCostBasedOnEquipment();
		};
	});

	::mods_hookExactClass("skills/effects/legend_veteran_levels_effect", function ( o )
	{
		o.onUpdateLevel = function ()
		{
			local actor = this.getContainer().getActor();
			if (actor.getLevel() > this.Const.EL_Player.EL_PlayerLevelPart1)
			{

				if (actor.m.Level >= this.Const.EL_Player.EL_PlayerLevelPart1 &&
					(this.Const.EL_Player.EL_PlayerLevelMax - actor.m.Level - 1) % this.Const.EL_Player.EL_PlayerExtraPerkPointFrequency[actor.EL_getRankLevel()] == 0)
				{
					++actor.m.PerkPoints;
				}
			}
		};
	});

	::mods_hookExactClass("skills/backgrounds/legend_donkey_background", function ( o )
	{
		local onAdded = o.onAdded;
		o.onAdded = function ()
		{
			onAdded();
			local player = this.getContainer().getActor();
			this.m.Modifiers.Ammo = this.Const.EL_PlayerOther.EL_DonkeyAmmo[player.EL_getRankLevel()] * (1 + this.Const.EL_PlayerOther.EL_DonkeyAmmoMultFactor * player.getLevel());
			this.m.Modifiers.ArmorParts = this.Const.EL_PlayerOther.EL_DonkeyArmorParts[player.EL_getRankLevel()] * (1 + this.Const.EL_PlayerOther.EL_DonkeyArmorPartsMultFactor * player.getLevel());
			this.m.Modifiers.Meds = this.Const.EL_PlayerOther.EL_DonkeyMeds[player.EL_getRankLevel()] * (1 + this.Const.EL_PlayerOther.EL_DonkeyMedsMultFactor * player.getLevel());
			this.m.Modifiers.Stash = this.Const.EL_PlayerOther.EL_DonkeyStash[player.EL_getRankLevel()] * (1 + this.Const.EL_PlayerOther.EL_DonkeyStashMultFactor * player.getLevel());
			for(local i = 0; i < this.m.Modifiers.Terrain.len(); i++) {
				this.m.Modifiers.Terrain[i] = this.Const.EL_PlayerOther.EL_DonkeyTerrain[player.EL_getRankLevel()] * (1 + this.Const.EL_PlayerOther.EL_DonkeyTerrainMultFactor * player.getLevel());
			}
		};
	});

});
