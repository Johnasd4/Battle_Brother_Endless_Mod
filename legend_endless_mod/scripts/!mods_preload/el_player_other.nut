local gt = getroottable();

::mods_registerMod("el_player_other", 1, "el_player_other");
::mods_queue(null, "el_player", function ()
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
			if (actor.getLevel() > this.Const.EL_Player.EL_PlayerLevel.Part1)
			{

				if (actor.m.Level >= this.Const.EL_Player.EL_PlayerLevel.Part1 &&
					(this.Const.EL_Player.EL_PlayerLevel.Max - actor.m.Level - 1) % this.Const.EL_Player.EL_Champion.PerkPointFrequency[actor.EL_getRankLevel()] == 0)
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
			local actor = this.getContainer().getActor();
			actor.m.BaseModifiers.Ammo = this.Const.EL_PlayerOther.EL_Donkey.Ammo[player.EL_getRankLevel()];
			actor.m.BaseModifiers.ArmorParts = this.Const.EL_PlayerOther.EL_Donkey.ArmorParts[player.EL_getRankLevel()];
			actor.m.BaseModifiers.Meds = this.Const.EL_PlayerOther.EL_Donkey.Meds[player.EL_getRankLevel()];
			actor.m.BaseModifiers.Stash = this.Const.EL_PlayerOther.EL_Donkey.Stash[player.EL_getRankLevel()];
			onAdded();
		};
	});


	::mods_hookExactClass("skills/actives/unleash_animal", function ( o )
	{
		local addAnimalSkills = o.addAnimalSkills;
		o.addAnimalSkills = function(entity)
		{
			addAnimalSkills(entity);
			local actor = this.getContainer().getActor();
			local actor_properties = actor.getCurrentProperties();
			local animal_properties = entity.getBaseProperties();
			entity.EL_generateNPCAttributesByLevel(actor.getLevel());
			//entity.EL_setRankLevel(actor.EL_getRankLevel);
			animal_properties.DamageRegularMult *= 1 + this.Const.EL_PlayerOther.EL_Animal.DamageMultPurLevel * entity.EL_getNPCLevel();
			animal_properties.EL_CombatLevel = entity.EL_getNPCLevel();
			entity.getSkills().update();
			entity.setHitpoints(entity.getHitpointsMax());
		}
	});

});
