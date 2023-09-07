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
			local player = this.getContainer().getActor();
			this.m.BaseModifiers.Ammo = this.Const.EL_PlayerOther.EL_Donkey.Ammo[player.EL_getRankLevel()];
			this.m.BaseModifiers.ArmorParts = this.Const.EL_PlayerOther.EL_Donkey.ArmorParts[player.EL_getRankLevel()];
			this.m.BaseModifiers.Meds = this.Const.EL_PlayerOther.EL_Donkey.Meds[player.EL_getRankLevel()];
			this.m.BaseModifiers.Stash = this.Const.EL_PlayerOther.EL_Donkey.Stash[player.EL_getRankLevel()];
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
			//entity.EL_setRankLevel(actor.EL_getRankLevel);
			animal_properties.Hitpoints = actor_properties.Hitpoints;
			animal_properties.HitpointsMult = actor_properties.HitpointsMult;
			animal_properties.Bravery = actor_properties.Bravery;
			animal_properties.BraveryMult = actor_properties.BraveryMult;
			animal_properties.Stamina = actor_properties.Stamina;
			animal_properties.StaminaMult = actor_properties.StaminaMult;
			animal_properties.Initiative = actor_properties.Initiative;
			animal_properties.InitiativeMult = actor_properties.InitiativeMult;
			animal_properties.MeleeSkill = actor_properties.MeleeSkill;
			animal_properties.MeleeSkillMult = actor_properties.MeleeSkillMult;
			animal_properties.RangedSkill = actor_properties.RangedSkill;
			animal_properties.RangedSkillMult = actor_properties.RangedSkillMult;
			animal_properties.MeleeDefense = actor_properties.MeleeDefense;
			animal_properties.MeleeDefenseMult = actor_properties.MeleeDefenseMult;
			animal_properties.RangedDefense = actor_properties.RangedDefense;
			animal_properties.RangedDefenseMult = actor_properties.RangedDefenseMult;
			animal_properties.DamageRegularMin = actor_properties.DamageRegularMin * this.Const.EL_PlayerOther.EL_Animal.DamageMult;
			animal_properties.DamageRegularMax = actor_properties.DamageRegularMax * this.Const.EL_PlayerOther.EL_Animal.DamageMult;
			animal_properties.DamageRegularMult = actor_properties.DamageRegularMult;
			animal_properties.EL_CombatLevel = actor_properties.EL_CombatLevel;
			entity.getSkills().update();
			entity.setHitpoints(entity.getHitpointsMax());
		}
	});

});
