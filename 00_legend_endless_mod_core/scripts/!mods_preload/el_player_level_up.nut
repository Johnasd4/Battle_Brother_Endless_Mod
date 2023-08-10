local gt = getroottable();

::mods_registerMod("el_player_level_up", 1, "el_player_level_up");
::mods_queue(null, ">el_world_difficulty", function ()
{
	::mods_hookExactClass("skills/effects/legend_veteran_levels_effect", function ( o )
	{
		o.onUpdateLevel = function ()
		{
			local actor = this.getContainer().getActor();
			if (actor.getLevel() > this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1)
			{

				if (actor.m.Level >= this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1 &&
					(this.Const.EL_PlayerLevelUp.EL_PlayerLevelMax - actor.m.Level - 1) % this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart2PerkFrequency == 0)
				{
					++actor.m.PerkPoints;
				}
			}
		};
	});

	::mods_hookExactClass("entity/tactical/player", function(obj)
	{
		::mods_override(obj, "updateLevel", function ()
		{
			while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
			{
				if(this.m.Level < this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1){
					++this.m.PerkPoints;
				}
				else if(this.m.Level >= this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart1 &&
					    (this.Const.EL_PlayerLevelUp.EL_PlayerLevelMax - this.m.Level - 1) % this.Const.EL_PlayerLevelUp.EL_PlayerLevelPart2PerkFrequency == 0){
					++this.m.PerkPoints;
				}
				++this.m.Level;
				++this.m.LevelUps;
				++this.m.EL_BattleLevel;

				this.m.Skills.onUpdateLevel();

				if (this.m.Level == 11)
				{
					this.updateAchievement("OldAndWise", 1, 1);
				}

				if (this.m.Level == 11 && this.m.Skills.hasSkill("trait.player"))
				{
					this.updateAchievement("TooStubbornToDie", 1, 1);
				}
			}
		});

		::mods_override(obj, "fillAttributeLevelUpValues", function ( _amount, _maxOnly = false, _minOnly = false )
		{
			if (this.m.Attributes.len() == 0)
			{
				this.m.Attributes.resize(this.Const.Attributes.COUNT);

				for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
				{
					this.m.Attributes[i] = [];
				}
			}

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				for( local j = 0; j < _amount; j = ++j )
				{
					if (_minOnly)
					{
						this.m.Attributes[i].insert(0, 1);
					}
					else if (_maxOnly)
					{
						this.m.Attributes[i].insert(0, this.Const.AttributesLevelUp[i].Max[this.m.Talents[count]]);
					}
					else
					{
						this.m.Attributes[count].insert(0, this.Math.rand(this.Const.EL_PlayerLevelUp.EL_LevelUpAttributes[count].Min[this.m.Talents[count]],
																		  this.Const.EL_PlayerLevelUp.EL_LevelUpAttributes[count].Max[this.m.Talents[count]]));
					}
				}
			}
		});

		::mods_override(obj, "getAttributeLevelUpValues", function ()
		{
			if (this.m.Attributes.len() == 0)
			{
				for( local count = 0; count != this.Const.Attributes.COUNT; ++count )
				{
					this.m.Attributes[count].insert(0, this.Math.rand(this.Const.EL_PlayerLevelUp.EL_LevelUpAttributes[count].Min[this.m.Talents[count]],
																	  this.Const.EL_PlayerLevelUp.EL_LevelUpAttributes[count].Max[this.m.Talents[count]]));
				}
			}
			local base_properties = this.getBaseProperties();
			local ret = {
				hitpoints = base_properties.Hitpoints,
				hitpointsMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayHitpointsMax,
				hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
				bravery = base_properties.Bravery,
				braveryMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayBraveryMax,
				braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
				fatigue = base_properties.Stamina,
				fatigueMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayFatigueMax,
				fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
				initiative = base_properties.Initiative,
				initiativeMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayInitiativeMax,
				initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
				meleeSkill = base_properties.MeleeSkill,
				meleeSkillMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayMeleeSkillMax,
				meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
				rangeSkill = base_properties.RangedSkill,
				rangeSkillMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayRangeSkillMax,
				rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
				meleeDefense = base_properties.MeleeDefense,
				meleeDefenseMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayMeleeDefenseMax,
				meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
				rangeDefense = base_properties.RangedDefense,
				rangeDefenseMax = this.Const.EL_PlayerLevelUp.EL_PlayerDisplayRangeDefenseMax,
				rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
			};
			return ret;
		});
	});

	::mods_hookNewObject("entity/tactical/player", function(o) {
		::mods_override(o, "addXP", function ( _xp, _scale = true )
		{
			if (this.m.Level >= this.Const.LevelXP.len() || this.isGuest())
			{
				return;
			}

			if (_scale)
			{
				_xp = _xp * this.Const.Combat.GlobalXPMult;
			}

			// multiply xp if more than 12 fielded
			local roster = World.getPlayerRoster().getAll();
			local in_battle_num = 0;
			foreach(brother in roster)
			{
				in_battle_num++;
			}

			if(inBattle > this.Const.EL_PlayerLevelUp.EL_CombatXPMaxDivFactor){
				_xp *= in_battle_num / this.Const.EL_PlayerLevelUp.EL_CombatXPMaxDivFactor;
			}

			//multiply xp if player level is lower then the world level
			if(this.m.Level < this.World.Assets.m.EL_WorldLevel - this.Const.EL_PlayerLevelUp.EL_CombatXPBelowWorldLevelOffset){
				local mult_factor = 1 + this.Math.pow((this.World.Assets.m.EL_WorldLevel - this.m.Level - this.Const.EL_PlayerLevelUp.EL_CombatXPBelowWorldLevelOffset) * this.Const.EL_PlayerLevelUp.EL_CombatXPBelowWorldLevelMultFactor, 2);
				if(mult_factor > this.Const.EL_PlayerLevelUp.EL_CombatXPBelowWorldLevelMultFactorMax) {
					mult_factor = this.Const.EL_PlayerLevelUp.EL_CombatXPBelowWorldLevelMultFactorMax;
				}
				_xp *= mult_factor;
			}
			else if (this.m.Level > this.World.Assets.m.EL_WorldLevel + this.Const.EL_PlayerLevelUp.EL_CombatXPOverWorldLevelOffset){
				local mult_factor = 1.0/(1 + this.Math.pow((this.m.Level - this.World.Assets.m.EL_WorldLevel - this.Const.EL_PlayerLevelUp.EL_CombatXPOverWorldLevelOffset) * this.Const.EL_PlayerLevelUp.EL_CombatXPOverWorldLevelMultFactor, 2));
				if(mult_factor < this.Const.EL_PlayerLevelUp.EL_CombatXPOverWorldLevelMultFactorMin) {
					mult_factor = this.Const.EL_PlayerLevelUp.EL_CombatXPOverWorldLevelMultFactorMin;
				}
				_xp *= mult_factor;
			}

			// xp multiplying end
			if (this.m.XP + _xp * this.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
			{
				// Now, the XP will be wasted, hhhh
				//this.m.CombatStats.XPGained += this.Const.LevelXP[this.Const.LevelXP.len() - 1] - this.m.XP;
				this.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
				return;
			}
			this.m.XP += this.Math.floor(_xp * this.m.CurrentProperties.XPGainMult);
			this.m.CombatStats.XPGained += this.Math.floor(_xp * this.m.CurrentProperties.XPGainMult);
		});
	});


});
