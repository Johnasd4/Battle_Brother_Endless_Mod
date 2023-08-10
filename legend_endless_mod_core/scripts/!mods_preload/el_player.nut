local gt = getroottable();

::mods_registerMod("el_player", 1, "el_player");
::mods_queue(null, ">el_world_difficulty", function ()
{
	::mods_hookExactClass("skills/effects/legend_veteran_levels_effect", function ( o )
	{
		local onUpdateLevel = o.onUpdateLevel;
		o.onUpdateLevel = function ()
		{
			local actor = this.getContainer().getActor();
			if (actor.getLevel() > this.Const.EL_Player.EL_PlayerLevelPart1)
			{

				if (actor.m.Level >= this.Const.EL_Player.EL_PlayerLevelPart1 &&
					(this.Const.EL_Player.EL_PlayerLevelMax - actor.m.Level - 1) % this.Const.EL_Player.EL_PlayerLevelPart2PerkFrequency[actor.EL_getRankLevel()] == 0)
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
				if(this.m.Level < this.Const.EL_Player.EL_PlayerLevelPart1){
					++this.m.PerkPoints;
				}
				else if(this.m.Level >= this.Const.EL_Player.EL_PlayerLevelPart1 &&
					    (this.Const.EL_Player.EL_PlayerLevelMax - this.m.Level - 1) % this.Const.EL_Player.EL_PlayerLevelPart2PerkFrequency[this.m.EL_RankLevel] == 0){
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
						this.m.Attributes[count].insert(0, this.Math.rand(this.Const.EL_Player.EL_LevelUpAttributes[count].Min[this.m.Talents[count]],
																		  this.Const.EL_Player.EL_LevelUpAttributes[count].Max[this.m.Talents[count]]));
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
					this.m.Attributes[count].insert(0, this.Math.rand(this.Const.EL_Player.EL_LevelUpAttributes[count].Min[this.m.Talents[count]],
																	  this.Const.EL_Player.EL_LevelUpAttributes[count].Max[this.m.Talents[count]]));
				}
			}
			local base_properties = this.getBaseProperties();
			local ret = {
				hitpoints = base_properties.Hitpoints,
				hitpointsMax = this.Const.EL_Player.EL_PlayerDisplayHitpointsMax,
				hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
				bravery = base_properties.Bravery,
				braveryMax = this.Const.EL_Player.EL_PlayerDisplayBraveryMax,
				braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
				fatigue = base_properties.Stamina,
				fatigueMax = this.Const.EL_Player.EL_PlayerDisplayFatigueMax,
				fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
				initiative = base_properties.Initiative,
				initiativeMax = this.Const.EL_Player.EL_PlayerDisplayInitiativeMax,
				initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
				meleeSkill = base_properties.MeleeSkill,
				meleeSkillMax = this.Const.EL_Player.EL_PlayerDisplayMeleeSkillMax,
				meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
				rangeSkill = base_properties.RangedSkill,
				rangeSkillMax = this.Const.EL_Player.EL_PlayerDisplayRangeSkillMax,
				rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
				meleeDefense = base_properties.MeleeDefense,
				meleeDefenseMax = this.Const.EL_Player.EL_PlayerDisplayMeleeDefenseMax,
				meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
				rangeDefense = base_properties.RangedDefense,
				rangeDefenseMax = this.Const.EL_Player.EL_PlayerDisplayRangeDefenseMax,
				rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
			};
			return ret;
		});

		::mods_override(o, "addXP", function ( _xp, _scale = true )
		{
			if (this.m.Level >= this.Const.LevelXP.len() || this.isGuest())
			{
				return;
			}

			_xp *= this.Const.EL_Player.EL_XPMult[this.m.EL_RankLevel];

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

			if(inBattle > this.Const.EL_Player.EL_CombatXPMaxDivFactor){
				_xp *= in_battle_num / this.Const.EL_Player.EL_CombatXPMaxDivFactor;
			}

			//multiply xp if player level is lower then the world level
			if(this.m.Level < this.World.Assets.m.EL_WorldLevel - this.Const.EL_Player.EL_CombatXPBelowWorldLevelOffset){
				local mult_factor = 1 + this.Math.pow((this.World.Assets.m.EL_WorldLevel - this.m.Level - this.Const.EL_Player.EL_CombatXPBelowWorldLevelOffset) * this.Const.EL_Player.EL_CombatXPBelowWorldLevelMultFactor, 2);
				if(mult_factor > this.Const.EL_Player.EL_CombatXPBelowWorldLevelMultFactorMax) {
					mult_factor = this.Const.EL_Player.EL_CombatXPBelowWorldLevelMultFactorMax;
				}
				_xp *= mult_factor;
			}
			else if (this.m.Level > this.World.Assets.m.EL_WorldLevel + this.Const.EL_Player.EL_CombatXPOverWorldLevelOffset){
				local mult_factor = 1.0/(1 + this.Math.pow((this.m.Level - this.World.Assets.m.EL_WorldLevel - this.Const.EL_Player.EL_CombatXPOverWorldLevelOffset) * this.Const.EL_Player.EL_CombatXPOverWorldLevelMultFactor, 2));
				if(mult_factor < this.Const.EL_Player.EL_CombatXPOverWorldLevelMultFactorMin) {
					mult_factor = this.Const.EL_Player.EL_CombatXPOverWorldLevelMultFactorMin;
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

		::mods_override(obj, "fillTalentValues", function ( _num, _force = false )
		{
			this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

			if (this.getBackground() != null && this.getBackground().isBackgroundType(this.Const.BackgroundType.Untalented) && !_force)
			{
				return;
			}

			local attributes = [];
			local weights = [];
			local totalWeight = 0;

			for( local i = 0; i < this.m.StarWeights.len(); i = i )
			{
				if (this.m.Talents[i] != 0)
				{
				}
				else if (this.getBackground() != null && this.getBackground().getExcludedTalents().find(i) != null)
				{
				}
				else
				{
					if (this.getFlags().has("PlayerZombie") && (i == this.Const.Attributes.Bravery || i == this.Const.Attributes.Fatigue || i == this.Const.Attributes.Initiative))
					{
						continue;
					}
					else if (this.getFlags().has("PlayerSkeleton") && (i == this.Const.Attributes.Bravery || i == this.Const.Attributes.Fatigue || i == this.Const.Attributes.Hitpoints))
					{
						continue;
					}

					local r = this.Math.rand(1, 100);

					if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[0])
					{
						this.m.Talents[i] = 0;
					}
					else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[1])
					{
						this.m.Talents[i] = 1;
					}
					else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[2])
					{
						this.m.Talents[i] = 2;
					}
					else
					{
						this.m.Talents[i] = 3;
					}
					this.m.Talents[i] += this.Const.EL_RebuildTalent.EL_RankToTalentBonus[this.m.EL_BattleLevel];
					attributes.push(i);
					weights.push(this.m.StarWeights[i]);
					totalWeight = totalWeight + this.m.StarWeights[i];
				}

				i = ++i;
			}

			for( local done = 0; done < _num; done = done )
			{
				local weight = this.Math.rand(1, totalWeight);
				local totalhere = 0;

				for( local i = 0; i < attributes.len(); i = i )
				{
					if (weight > totalhere && weight <= totalhere + weights[i])
					{
						local r = this.Math.rand(1, 100);
						local j = attributes[i];
						local temp_talent = this.Const.EL_RebuildTalent.EL_RankToTalentBonus[this.m.EL_BattleLevel];
						if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[1])
						{
							temp_talent += 1;
						}
						else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[2])
						{
							temp_talent += 2;
						}
						else
						{
							temp_talent += 3;
						}
						if(this.m.Talents[j] < temp_talent) {
							this.m.Talents[j] = temp_talent;
						}
						if(this.m.Talents[j] > this.Const.EL_RebuildTalent.EL_TalentMax) {
							this.m.Talents[j] = this.Const.EL_RebuildTalent.EL_TalentMax;
						}
						attributes.remove(i);
						totalWeight = totalWeight - weights[i];
						weights.remove(i);
						break;
					}
					else
					{
						totalhere = totalhere + weights[i];
					}

					i = ++i;
				}

				done = ++done;
			}

		});

		local setStartValuesEx = o.setStartValuesEx;
		o.setStartValuesEx = function ( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true )
		{
			local rank_1_chance = 0;
			local rank_2_chance = 0;
			if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank1ChanceWorldLevel[1]) {
				rank_1_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank1ChanceFactor[0] + this.Const.EL_Player.EL_Rank1ChanceOffset[0];
			}
			else if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank1ChanceWorldLevel[2]) {
				rank_1_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank1ChanceFactor[1] + this.Const.EL_Player.EL_Rank1ChanceOffset[1];
			}
			else if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank1ChanceWorldLevel[3]) {
				rank_1_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank1ChanceFactor[2] + this.Const.EL_Player.EL_Rank1ChanceOffset[2];
			}
			else {
				rank_1_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank1ChanceFactor[3] + this.Const.EL_Player.EL_Rank1ChanceOffset[3];
			}
			if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank2ChanceWorldLevel[1]) {
				rank_2_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank2ChanceFactor[0] + this.Const.EL_Player.EL_Rank2ChanceOffset[0];
			}
			else if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank2ChanceWorldLevel[2]) {
				rank_2_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank2ChanceFactor[1] + this.Const.EL_Player.EL_Rank2ChanceOffset[1];
			}
			else if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_Player.EL_Rank2ChanceWorldLevel[3]) {
				rank_2_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank2ChanceFactor[2] + this.Const.EL_Player.EL_Rank2ChanceOffset[2];
			}
			else {
				rank_2_chance = this.World.Assets.m.EL_WorldLevel * this.Const.EL_Player.EL_Rank2ChanceFactor[3] + this.Const.EL_Player.EL_Rank2ChanceOffset[3];
			}
			if(rank_2_chance * 10 >= this.Math.rand(1, 1000)) {
				this.m.EL_RankLevel = 2;
			}
			else if(rank_1_chance * 10 >= this.Math.rand(1, 1000)) {
				this.m.EL_RankLevel = 1;
			}
			this.m.CurrentProperties.DailyFood += this.Const.EL_Player.EL_PlayerExtraDailyFoodCost[tthis.m.EL_RankLevel];
			setStartValuesEx(_backgrounds, _addTraits, _gender, _addEquipment);
		}

	});


});
