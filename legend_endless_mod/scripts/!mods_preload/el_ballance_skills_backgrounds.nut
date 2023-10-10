local gt = getroottable();

::mods_registerMod("el_ballance_skills_backgrounds", 1, "el_ballance_skills_backgrounds");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("skills/backgrounds/legend_donkey_background", function ( o )
	{
		local onAdded = o.onAdded;
		o.onAdded = function ()
		{
			local actor = this.getContainer().getActor();
			this.m.Modifiers.Ammo = this.Const.EL_PlayerOther.EL_Donkey.Ammo[actor.EL_getRankLevel()];
			this.m.Modifiers.ArmorParts = this.Const.EL_PlayerOther.EL_Donkey.ArmorParts[actor.EL_getRankLevel()];
			this.m.Modifiers.Meds = this.Const.EL_PlayerOther.EL_Donkey.Meds[actor.EL_getRankLevel()];
			this.m.Modifiers.Stash = this.Const.EL_PlayerOther.EL_Donkey.Stash[actor.EL_getRankLevel()];
			onAdded();
		};
	});

	::mods_hookExactClass("skills/backgrounds/legend_puppet_background", function ( o )
	{
		o.adjustHiringCostBasedOnEquipment = function ()
		{
            this.character_background.adjustHiringCostBasedOnEquipment();
		};
	});


});
