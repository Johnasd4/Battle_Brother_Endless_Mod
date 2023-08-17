local gt = getroottable();

::mods_registerMod("el_player", 1, "el_player");
::mods_queue(null, ">el_player_npc", function ()
{

	::mods_hookNewObject("entity/tactical/player", function( o )
	{

		o.getDailyFood = function ()
		{
			local food = this.Math.maxf(0.0, this.m.CurrentProperties.DailyFood);

			if (this.isInReserves() && !this.m.Skills.hasSkill("perk.legend_peaceful"))
			{
				food = food * 2;
			}

			food = food - this.World.State.getPlayer().getFoodModifier();
			food *= this.Const.EL_Player.EL_PlayerExtraDailyFoodMult[this.m.EL_RankLevel];
			return food;
		};

		o.updateLevel = function ()
		{
			while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
			{
				if(this.m.Level < this.Const.EL_Player.EL_PlayerLevelPart1){
					++this.m.PerkPoints;
				}
				else if(this.m.Level >= this.Const.EL_Player.EL_PlayerLevelPart1 &&
					    (this.Const.EL_Player.EL_PlayerLevelMax - this.m.Level - 1) % this.Const.EL_Player.EL_PlayerExtraPerkPointFrequency[this.m.EL_RankLevel] == 0){
					++this.m.PerkPoints;
				}
				++this.m.Level;
				++this.m.LevelUps;
				++this.m.BaseProperties.EL_CombatLevel;

				local background = this.getBackground();
				if(background.getNameOnly() == "Donkey") {

					background.m.Modifiers.Stash = this.Math.floor(this.Const.EL_PlayerOther.EL_DonkeyStash[rank] * (1 + this.Const.EL_PlayerOther.EL_DonkeyStashMultFactor * this.m.Level));

					background.m.Modifiers.Ammo = this.Const.EL_PlayerOther.EL_DonkeyAmmo[this.m.EL_RankLevel] * (1 + this.Const.EL_PlayerOther.EL_DonkeyAmmoMultFactor * this.m.Level);
					background.m.Modifiers.ArmorParts = this.Const.EL_PlayerOther.EL_DonkeyArmorParts[this.m.EL_RankLevel] * (1 + this.Const.EL_PlayerOther.EL_DonkeyArmorPartsMultFactor * this.m.Level);
					background.m.Modifiers.Meds = this.Const.EL_PlayerOther.EL_DonkeyMeds[this.m.EL_RankLevel] * (1 + this.Const.EL_PlayerOther.EL_DonkeyMedsMultFactor * this.m.Level);
					background.m.Modifiers.Stash = this.Const.EL_PlayerOther.EL_DonkeyStash[this.m.EL_RankLevel] * (1 + this.Const.EL_PlayerOther.EL_DonkeyStashMultFactor * this.m.Level);
					for(local i = 0; i < this.m.Modifiers.Terrain.len(); i++) {
						this.m.Modifiers.Terrain[i] = this.Const.EL_PlayerOther.EL_DonkeyTerrain[this.m.EL_RankLevel] * (1 + this.Const.EL_PlayerOther.EL_DonkeyTerrainMultFactor * this.m.Level);
					}

				}

				this.m.Skills.onUpdateLevel();

			}
		};

		o.fillAttributeLevelUpValues = function ( _amount, _maxOnly = false, _minOnly = false)
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
						this.m.Attributes[i].insert(0, this.Const.EL_Player.EL_LevelUpAttributes[i].Min[this.m.Talents[i]]);
					}
					else if (_maxOnly)
					{
						this.m.Attributes[i].insert(0, this.Const.EL_Player.EL_LevelUpAttributes[i].Max[this.m.Talents[i]]);
					}
					else
					{
						this.m.Attributes[i].insert(0, this.Math.rand(this.Const.EL_Player.EL_LevelUpAttributes[i].Min[this.m.Talents[i]],
																	  this.Const.EL_Player.EL_LevelUpAttributes[i].Max[this.m.Talents[i]]));
					}
					// this.logInfo("this.m.Attributes[" + i + "][0] = " + this.m.Attributes[i][0]);
					// this.logInfo("this.m.Attributes[" + i + "][0] min = " + this.Const.EL_Player.EL_LevelUpAttributes[i].Min[this.m.Talents[i]]);
					// this.logInfo("this.m.Attributes[" + i + "][0] max = " + this.Const.EL_Player.EL_LevelUpAttributes[i].Max[this.m.Talents[i]]);
				}
			}
		};

		o.getAttributeLevelUpValues = function ()
		{
			if (this.m.Attributes.len() == 0)
			{
				for( local i = 0; i != this.Const.Attributes.COUNT; ++i )
				{
					this.m.Attributes[i].insert(0, this.Math.rand(this.Const.EL_Player.EL_LevelUpAttributes[i].Min[this.m.Talents[i]],
																  this.Const.EL_Player.EL_LevelUpAttributes[i].Max[this.m.Talents[i]]));
					// this.logInfo("1 this.m.Attributes[" + i + "][0] = " + this.m.Attributes[i][0]);
					// this.logInfo("1 this.m.Attributes[" + i + "][0] min = " + this.Const.EL_Player.EL_LevelUpAttributes[i].Min[this.m.Talents[i]]);
					// this.logInfo("1 this.m.Attributes[" + i + "][0] max = " + this.Const.EL_Player.EL_LevelUpAttributes[i].Max[this.m.Talents[i]]);
				}
			}
			local base_properties = this.getBaseProperties();
			local ret = {
				hitpoints = base_properties.Hitpoints,
				hitpointsMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardHitpointsMax,
				hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
				bravery = base_properties.Bravery,
				braveryMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardBraveryMax,
				braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
				fatigue = base_properties.Stamina,
				fatigueMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardFatigueMax,
				fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
				initiative = base_properties.Initiative,
				initiativeMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardInitiativeMax,
				initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
				meleeSkill = base_properties.MeleeSkill,
				meleeSkillMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardMeleeSkillMax,
				meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
				rangeSkill = base_properties.RangedSkill,
				rangeSkillMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardRangeSkillMax,
				rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
				meleeDefense = base_properties.MeleeDefense,
				meleeDefenseMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardMeleeDefenseMax,
				meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
				rangeDefense = base_properties.RangedDefense,
				rangeDefenseMax = this.Const.EL_Player.EL_PlayerAddAttributesBoardRangeDefenseMax,
				rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
			};
			return ret;
		};

		o.addXP = function ( _xp, _scale = true )
		{
			if (this.m.Level >= this.Const.LevelXP.len() || this.isGuest())
			{
				return;
			}

			_xp *= this.Const.EL_Player.EL_PlayerXPMult[this.m.EL_RankLevel];

			if (_scale)
			{
				_xp = _xp * this.Const.Combat.GlobalXPMult;
			}

			// multiply xp if more than 12 fielded
			local roster = World.getPlayerRoster().getAll();
			local in_battle_num = 0;
			foreach(brotherther in roster)
			{
				in_battle_num++;
			}

			if(in_battle_num > this.Const.EL_Player.EL_CombatXPMaxDivFactor){
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
		};

		o.fillTalentValues = function ( _num, _force = false )
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

					if (r <= this.Const.EL_Player.EL_TalentChance[0])
					{
						this.m.Talents[i] = 0;
					}
					else if (r <= this.Const.EL_Player.EL_TalentChance[1])
					{
						this.m.Talents[i] = 1;
					}
					else if (r <= this.Const.EL_Player.EL_TalentChance[2])
					{
						this.m.Talents[i] = 2;
					}
					else
					{
						this.m.Talents[i] = 3;
					}
					this.m.Talents[i] += this.Const.EL_Player.EL_RankToTalentBonus[this.m.EL_RankLevel];
					if(this.m.Talents[i] > this.Const.EL_Player.EL_TalentMax) {
						this.m.Talents[i] = this.Const.EL_Player.EL_TalentMax;
					}
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
						local temp_talent = this.Const.EL_Player.EL_RankToTalentBonus[this.m.EL_RankLevel];
						if (r <= this.Const.EL_Player.EL_TalentChance[1])
						{
							temp_talent += 1;
						}
						else if (r <= this.Const.EL_Player.EL_TalentChance[2])
						{
							temp_talent += 2;
						}
						else
						{
							temp_talent += 3;
						}
						if(temp_talent > this.Const.EL_Player.EL_TalentMax) {
							temp_talent = this.Const.EL_Player.EL_TalentMax;
						}
						if(this.m.Talents[j] < temp_talent) {
							this.m.Talents[j] = temp_talent;
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

		};

		local setStartValuesEx = o.setStartValuesEx;
		o.setStartValuesEx = function ( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true, _EL_rankLevel = -1 )
		{
			if(_EL_rankLevel == -1) {
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
			}
			else{
				this.m.EL_RankLevel = _EL_rankLevel;
			}
			setStartValuesEx(_backgrounds, _addTraits, _gender, _addEquipment);
			// this.logInfo("rank : " + this.m.EL_RankLevel);
			// this.logInfo("rank_1_chance : " + rank_1_chance);
			// this.logInfo("rank_2_chance : " + rank_2_chance);
			//this.logInfo("HiringCost : " + this.m.HiringCost);


			this.Const.EL_Player.EL_AddRandomPerkTreeToPlayer(this, this.Const.EL_Player.EL_RankToExtraPerks[this.m.EL_RankLevel]);

		};

		o.getTryoutCost = function ()
		{
			return this.m.CurrentProperties.DailyWage * this.Const.EL_Player.EL_TryoutCostMultFactor;
		};
		o.getXPForNextLevel = function ()
		{
			if (this.m.Level >= this.Const.LevelXP.len() - 10 && ("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getBackground().getID() == "background.slave")
			{
				return this.Const.LevelXP[this.Const.LevelXP.len() - 10];
			}
			else
			{
				return this.m.Level < this.Const.LevelXP.len() ? this.Const.LevelXP[this.m.Level] : this.Const.LevelXP[this.Const.LevelXP.len() - 1];
			}
		};

	});

	::mods_hookExactClass("skills/backgrounds/character_background", function ( o )
	{
		o.adjustHiringCostBasedOnEquipment = function ()
		{
			local actor = this.getContainer().getActor();
			// local hiring_cost_mult = 0;
			// //this.logInfo("HiringCost 1 : " + this.m.HiringCost);
			// if (this.m.HiringCost <= this.Const.EL_Player.EL_HiringCostPricePart2) {
			// 	hiring_cost_mult = this.Const.EL_Player.EL_HiringCostFactorPart1;
			// 	actor.m.HiringCost = this.m.HiringCost * hiring_cost_mult;
			// }
			// else if (this.m.HiringCost <= this.Const.EL_Player.EL_HiringCostPricePart3) {
			// 	actor.m.HiringCost = this.Math.pow(this.m.HiringCost / 10.0, this.Const.EL_Player.EL_HiringCostFactorPart2);
			// }
			// else if (this.m.HiringCost <= this.Const.EL_Player.EL_HiringCostPricePart4) {
			// 	hiring_cost_mult = this.Const.EL_Player.EL_HiringCostFactorPart3 +
			// 		(this.m.HiringCost - this.Const.EL_Player.EL_HiringCostPricePart3) * 1.0 *
			// 		(this.Const.EL_Player.EL_HiringCostFactorPart3 - this.Const.EL_Player.EL_HiringCostFactorPart4) /
			// 		(this.Const.EL_Player.EL_HiringCostPricePart3 - this.Const.EL_Player.EL_HiringCostPricePart4);
			// 		actor.m.HiringCost = this.m.HiringCost * hiring_cost_mult;
			// }
			// else if (this.m.HiringCost <= this.Const.EL_Player.EL_HiringCostPricePart5) {
			// 	hiring_cost_mult = this.Const.EL_Player.EL_HiringCostFactorPart4 +
			// 		(this.m.HiringCost - this.Const.EL_Player.EL_HiringCostPricePart4) * 1.0 *
			// 		(this.Const.EL_Player.EL_HiringCostFactorPart4 - this.Const.EL_Player.EL_HiringCostFactorPart5) /
			// 		(this.Const.EL_Player.EL_HiringCostPricePart4 - this.Const.EL_Player.EL_HiringCostPricePart5);
			// 		actor.m.HiringCost = this.m.HiringCost * hiring_cost_mult;
			// }
			// else{
			// 	hiring_cost_mult = this.Const.EL_Player.EL_HiringCostFactorPart5;
			// 	actor.m.HiringCost = this.m.HiringCost * hiring_cost_mult;
			// }
			//this.logInfo("HiringCost 2 : " + actor.m.HiringCost);
			//this.logInfo("hiring_cost_mult 2 : " + hiring_cost_mult);
			local items = actor.getItems().getAllItems();
			local cost = 0;
			foreach( i in items )
			{
				cost = cost + i.getValue();
			}
			actor.m.HiringCost = this.m.HiringCost;

			actor.m.HiringCost *= this.Const.EL_Player.EL_PlayerExtraHiringCostMult[actor.m.EL_RankLevel];
			actor.m.HiringCost += this.Const.EL_Player.EL_PlayerExtraHiringCostOffset[actor.m.EL_RankLevel];
			actor.m.HiringCost *= (1 + this.Const.EL_Player.EL_HiringCostLevelMultFactor * this.m.Level);
			actor.m.HiringCost += cost * this.Const.EL_Player.EL_HiringCostItemCostMultFactor;
			actor.m.HiringCost = this.Math.ceil(actor.m.HiringCost);
		};

		o.calculateAdditionalRecruitmentLevels = function ()
		{
			return this.Math.rand(0, this.World.Assets.m.EL_WorldLevel);
		};

		o.onAdded = function ()
		{
			if (this.m.DailyCost > 0)
			{
				this.m.DailyCost += 1;
			}

			this.m.Level += this.calculateAdditionalRecruitmentLevels();

			local actor = this.getContainer().getActor();
			actor.m.Background = this;
			actor.m.Ethnicity = this.m.Ethnicity;

			if (!this.m.IsNew)
			{
				return;
			}

			if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
			{
				return;
			}

			this.m.IsNew = false;

			if (this.m.LastNames.len() == 0 && this.m.Ethnicity == 1)
			{
				this.m.LastNames = this.Const.Strings.SouthernNamesLast;
			}

			if (actor.getTitle() == "" && this.m.LastNames.len() != 0 && this.Math.rand(0, 1) == 1)
			{
				actor.setTitle(this.m.LastNames[this.Math.rand(0, this.m.LastNames.len() - 1)]);
			}

			if (actor.getTitle() == "" && this.m.Titles.len() != 0 && this.Math.rand(0, 3) == 3)
			{
				actor.setTitle(this.m.Titles[this.Math.rand(0, this.m.Titles.len() - 1)]);
			}

			if (actor.getNameOnly() == "")
			{
				local names = this.m.Names;

				if (names == null || this.m.Names.len() == 0)
				{
					names = this.Const.Strings.CharacterNames;

					if (this.m.Ethnicity == 1)
					{
						names = this.Const.Strings.SouthernNames;
					}
					else if (this.m.Ethnicity == 2)
					{
						names = this.Const.Strings.BarbarianNames;
					}

					if (this.isBackgroundType(this.Const.BackgroundType.Female))
					{
						names = this.Const.Strings.CharacterNamesFemale;

						if (this.m.Ethnicity == 1)
						{
							names = this.Const.Strings.SouthernFemaleNames;
						}
						else if (this.m.Ethnicity == 2)
						{
							names = this.Const.Strings.CharacterNamesFemaleNorse;
						}
					}
				}

				actor.setName(names[this.Math.rand(0, names.len() - 1)]);
			}

			if (this.m.Level <= 11)
			{
				actor.m.PerkPoints = this.m.Level - 1;
			}
			else
			{
				actor.m.PerkPoints = 10;
			}
			actor.m.PerkPoints = this.m.Level - 1 + this.Const.EL_Player.EL_PlayerExtraPerkPoints[actor.m.EL_RankLevel];
			actor.m.LevelUps = this.m.Level - 1;
			actor.m.Level = this.m.Level;
			actor.m.BaseProperties.EL_CombatLevel = this.m.Level + this.Const.EL_Player.EL_PlayerExtraCombatLevel[actor.m.EL_RankLevel];
			actor.m.XP = this.Const.LevelXP[this.m.Level - 1];
		};

		o.onUpdate = function ( _properties )
		{
			if (this.m.DailyCost == 0 || this.getContainer().hasSkill("trait.player"))
			{
				_properties.DailyWage = 0;
			}
			else
			{
				if (this.isBackgroundType(this.Const.BackgroundType.ConvertedCultist))
				{
					this.m.DailyCost = 4;
				}
				//this.logInfo("DailyCost 1 : " + this.m.DailyCost);
				//this.logInfo("DailyWage 1 : " + _properties.DailyWage);
				local actor = this.getContainer().getActor();
				local wage = this.Math.round(this.m.DailyCost * this.m.DailyCostMult);
				_properties.DailyWage += wage * (1 + actor.getLevel() * this.Const.EL_Player.EL_DailyCostLevelMultFactor);
				_properties.DailyWage *= this.Const.EL_Player.EL_PlayerExtraDailyCostMult[actor.EL_getRankLevel()];
				_properties.DailyWage = this.Math.ceil(_properties.DailyWage);
				//this.logInfo("DailyWage 2 : " + _properties.DailyWage);

			}

			if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getID() != "background.slave")
			{
				_properties.XPGainMult *= 0.9;
			}
		};

		o.buildAttributes = function ( _tag = null, _attrs = null )
		{
			local a = [];

			if (_tag == "zombie")
			{
				a = {
					Hitpoints = [
						65,
						75
					],
					Bravery = [
						30,
						40
					],
					Stamina = [
						90,
						100
					],
					MeleeSkill = [
						42,
						52
					],
					RangedSkill = [
						27,
						37
					],
					MeleeDefense = [
						0,
						0
					],
					RangedDefense = [
						0,
						0
					],
					Initiative = [
						85,
						95
					]
				};
			}
			else if (_tag == "skeleton")
			{
				a = {
					Hitpoints = [
						50,
						60
					],
					Bravery = [
						30,
						40
					],
					Stamina = [
						90,
						100
					],
					MeleeSkill = [
						42,
						52
					],
					RangedSkill = [
						27,
						37
					],
					MeleeDefense = [
						0,
						5
					],
					RangedDefense = [
						0,
						5
					],
					Initiative = [
						90,
						100
					]
				};
			}
			else
			{
				a = {
					Hitpoints = [
						50,
						60
					],
					Bravery = [
						30,
						40
					],
					Stamina = [
						90,
						100
					],
					MeleeSkill = [
						47,
						57
					],
					RangedSkill = [
						32,
						42
					],
					MeleeDefense = [
						0,
						5
					],
					RangedDefense = [
						0,
						5
					],
					Initiative = [
						100,
						110
					]
				};
			}

			local c = this.onChangeAttributes();

			local rank = this.getContainer().getActor().EL_getRankLevel();

			a.Hitpoints[0] += c.Hitpoints[0];
			a.Hitpoints[1] += c.Hitpoints[1];
			a.Bravery[0] += c.Bravery[0];
			a.Bravery[1] += c.Bravery[1];
			a.Stamina[0] += c.Stamina[0];
			a.Stamina[1] += c.Stamina[1];
			a.MeleeSkill[0] += c.MeleeSkill[0];
			a.MeleeSkill[1] += c.MeleeSkill[1];
			a.MeleeDefense[0] += c.MeleeDefense[0];
			a.MeleeDefense[1] += c.MeleeDefense[1];
			a.RangedSkill[0] += c.RangedSkill[0];
			a.RangedSkill[1] += c.RangedSkill[1];
			a.RangedDefense[0] += c.RangedDefense[0];
			a.RangedDefense[1] += c.RangedDefense[1];
			a.Initiative[0] += c.Initiative[0];
			a.Initiative[1] += c.Initiative[1];

			if(rank == 1) {
				a.Hitpoints[0] = this.Math.round((a.Hitpoints[0] + a.Hitpoints[1]) * 0.5);
				a.Bravery[0] = this.Math.round((a.Bravery[0] + a.Bravery[1]) * 0.5);
				a.Stamina[0] = this.Math.round((a.Stamina[0] + a.Stamina[1]) * 0.5);
				a.MeleeSkill[0] = this.Math.round((a.MeleeSkill[0] + a.MeleeSkill[1]) * 0.5);
				a.MeleeDefense[0] = this.Math.round((a.MeleeDefense[0] + a.MeleeDefense[1]) * 0.5);
				a.RangedSkill[0] = this.Math.round((a.RangedSkill[0] + a.RangedSkill[1]) * 0.5);
				a.RangedDefense[0] = this.Math.round((a.RangedDefense[0] + a.RangedDefense[1]) * 0.5);
				a.Initiative[0] = this.Math.round((a.Initiative[0] + a.Initiative[1]) * 0.5);
			}
			else if(rank == 2) {
				a.Hitpoints[0] = a.Hitpoints[1];
				a.Bravery[0] = a.Bravery[1];
				a.Stamina[0] = a.Stamina[1];
				a.MeleeSkill[0] = a.MeleeSkill[1];
				a.MeleeDefense[0] = a.MeleeDefense[1];
				a.RangedSkill[0] = a.RangedSkill[1];
				a.RangedDefense[0] = a.RangedDefense[1];
				a.Initiative[0] = a.Initiative[1];
			}


			// this.logInfo("rank : " + rank);
			// this.logInfo("Hitpoints : " + a.Hitpoints[0] + " " + a.Hitpoints[1]);
			// this.logInfo("Bravery : " + a.Bravery[0] + " " + a.Bravery[1]);
			// this.logInfo("Stamina : " + a.Stamina[0] + " " + a.Stamina[1]);
			// this.logInfo("MeleeSkill : " + a.MeleeSkill[0] + " " + a.MeleeSkill[1]);
			// this.logInfo("MeleeDefense : " + a.MeleeDefense[0] + " " + a.MeleeDefense[1]);
			// this.logInfo("RangedSkill : " + a.RangedSkill[0] + " " + a.RangedSkill[1]);
			// this.logInfo("RangedDefense : " + a.RangedDefense[0] + " " + a.RangedDefense[1]);
			// this.logInfo("Initiative : " + a.Initiative[0] + " " + a.Initiative[1]);

			if (_attrs != null)
			{
				a.Hitpoints[0] += _attrs.Hitpoints[0];
				a.Hitpoints[1] += _attrs.Hitpoints[1];
				a.Bravery[0] += _attrs.Bravery[0];
				a.Bravery[1] += _attrs.Bravery[1];
				a.Stamina[0] += _attrs.Stamina[0];
				a.Stamina[1] += _attrs.Stamina[1];
				a.MeleeSkill[0] += _attrs.MeleeSkill[0];
				a.MeleeSkill[1] += _attrs.MeleeSkill[1];
				a.MeleeDefense[0] += _attrs.MeleeDefense[0];
				a.MeleeDefense[1] += _attrs.MeleeDefense[1];
				a.RangedSkill[0] += _attrs.RangedSkill[0];
				a.RangedSkill[1] += _attrs.RangedSkill[1];
				a.RangedDefense[0] += _attrs.RangedDefense[0];
				a.RangedDefense[1] += _attrs.RangedDefense[1];
				a.Initiative[0] += _attrs.Initiative[0];
				a.Initiative[1] += _attrs.Initiative[1];
			}

			local b = this.getContainer().getActor().getBaseProperties();
			b.ActionPoints = 9;
			local Hitpoints1 = this.Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
			local Bravery1 = this.Math.rand(a.Bravery[0], a.Bravery[1]);
			local Stamina1 = this.Math.rand(a.Stamina[0], a.Stamina[1]);
			local MeleeSkill1 = this.Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
			local RangedSkill1 = this.Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
			local MeleeDefense1 = this.Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
			local RangedDefense1 = this.Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
			local Initiative1 = this.Math.rand(a.Initiative[0], a.Initiative[1]);
			local Hitpoints2 = this.Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
			local Bravery2 = this.Math.rand(a.Bravery[0], a.Bravery[1]);
			local Stamina2 = this.Math.rand(a.Stamina[0], a.Stamina[1]);
			local MeleeSkill2 = this.Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
			local RangedSkill2 = this.Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
			local MeleeDefense2 = this.Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
			local RangedDefense2 = this.Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
			local Initiative2 = this.Math.rand(a.Initiative[0], a.Initiative[1]);
			local HitpointsAvg = this.Math.round((Hitpoints1 + Hitpoints2) / 2);
			local BraveryAvg = this.Math.round((Bravery1 + Bravery2) / 2);
			local StaminaAvg = this.Math.round((Stamina1 + Stamina2) / 2);
			local MeleeSkillAvg = this.Math.round((MeleeSkill1 + MeleeSkill2) / 2);
			local RangedSkillAvg = this.Math.round((RangedSkill1 + RangedSkill2) / 2);
			local MeleeDefenseAvg = this.Math.round((MeleeDefense1 + MeleeDefense2) / 2);
			local RangedDefenseAvg = this.Math.round((RangedDefense1 + RangedDefense2) / 2);
			local InitiativeAvg = this.Math.round((Initiative1 + Initiative2) / 2);
			b.Hitpoints = HitpointsAvg;
			b.Bravery = BraveryAvg;
			b.Stamina = StaminaAvg;
			b.MeleeSkill = MeleeSkillAvg;
			b.RangedSkill = RangedSkillAvg;
			b.MeleeDefense = MeleeDefenseAvg;
			b.RangedDefense = RangedDefenseAvg;
			b.Initiative = InitiativeAvg;
			this.getContainer().getActor().m.CurrentProperties = clone b;
			this.getContainer().getActor().setHitpoints(b.Hitpoints);
			local weighted = [];

			if (a.Hitpoints[1] == a.Hitpoints[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.Hitpoints - a.Hitpoints[0]) * 100.0 / (a.Hitpoints[1] - a.Hitpoints[0])));
			}

			if (a.Bravery[1] == a.Bravery[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.Bravery - a.Bravery[0]) * 100.0 / (a.Bravery[1] - a.Bravery[0])));
			}

			if (a.Stamina[1] == a.Stamina[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.Stamina - a.Stamina[0]) * 100.0 / (a.Stamina[1] - a.Stamina[0])));
			}

			if (a.MeleeSkill[1] == a.MeleeSkill[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.MeleeSkill - a.MeleeSkill[0]) * 100.0 / (a.MeleeSkill[1] - a.MeleeSkill[0])));
			}

			if (a.RangedSkill[1] == a.RangedSkill[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.RangedSkill - a.RangedSkill[0]) * 100.0 / (a.RangedSkill[1] - a.RangedSkill[0])));
			}

			if (a.MeleeDefense[1] == a.MeleeDefense[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.MeleeDefense - a.MeleeDefense[0]) * 100.0 / (a.MeleeDefense[1] - a.MeleeDefense[0])));
			}

			if (a.RangedDefense[1] == a.RangedDefense[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.RangedDefense - a.RangedDefense[0]) * 100.0 / (a.RangedDefense[1] - a.RangedDefense[0])));
			}

			if (a.Initiative[1] == a.Initiative[0])
			{
				weighted.push(50);
			}
			else
			{
				weighted.push(this.Math.floor((b.Initiative - a.Initiative[0]) * 100.0 / (a.Initiative[1] - a.Initiative[0])));
			}

			return weighted;
		};

		o.getAttributesTooltip = function ()
		{
			if (this.getContainer().getActor().getLevel() >= this.Const.EL_Player.EL_PlayerLevelMax)
			{
				return [];
			}

			local EL_calculateAttribute = function ( _level, _attribute, _maximum = false )
			{
				local brother = this.getContainer().getActor();
				local attributeMin = this.Const.EL_Player.EL_LevelUpAttributes[_attribute].Min[brother.m.Talents[_attribute]];
				local attributeMax = this.Const.EL_Player.EL_LevelUpAttributes[_attribute].Max[brother.m.Talents[_attribute]];

				local levelUps = this.Math.max(_level - brother.getLevel() + brother.getLevelUps(), 0);
				local attributeValue = _maximum ? attributeMax * levelUps : attributeMin * levelUps;

				switch(_attribute)
				{
				case this.Const.Attributes.Hitpoints:
					return attributeValue + brother.getBaseProperties().Hitpoints;
					break;

				case this.Const.Attributes.Bravery:
					return attributeValue + brother.getBaseProperties().Bravery;
					break;

				case this.Const.Attributes.Fatigue:
					return attributeValue + brother.getBaseProperties().Stamina;
					break;

				case this.Const.Attributes.Initiative:
					return attributeValue + brother.getBaseProperties().Initiative;
					break;

				case this.Const.Attributes.MeleeSkill:
					return attributeValue + brother.getBaseProperties().MeleeSkill;
					break;

				case this.Const.Attributes.RangedSkill:
					return attributeValue + brother.getBaseProperties().RangedSkill;
					break;

				case this.Const.Attributes.MeleeDefense:
					return attributeValue + brother.getBaseProperties().MeleeDefense;
					break;

				case this.Const.Attributes.RangedDefense:
					return attributeValue + brother.getBaseProperties().RangedDefense;
					break;

				default:
					return 0;
					break;
				}
			};
			local a = {
				Hitpoints = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Hitpoints),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Hitpoints, true)
				],
				Bravery = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Bravery),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Bravery, true)
				],
				Fatigue = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Fatigue),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Fatigue, true)
				],
				Initiative = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Initiative),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.Initiative, true)
				],
				MeleeSkill = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.MeleeSkill),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.MeleeSkill, true)
				],
				RangedSkill = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.RangedSkill),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.RangedSkill, true)
				],
				MeleeDefense = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.MeleeDefense),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.MeleeDefense, true)
				],
				RangedDefense = [
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.RangedDefense),
					EL_calculateAttribute(this.Const.EL_Player.EL_PlayerLevelMax, this.Const.Attributes.RangedDefense, true)
				]
			};
			local bufferHealth = "";
			local bufferFatigue = "";
			local bufferBravery = "";
			local bufferInitiative = "";

			if (a.Hitpoints[0] >= 100)
			{
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Hitpoints[1] >= 100)
			{
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Fatigue[0] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Fatigue[1] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Bravery[0] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Bravery[1] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferInitiative = bufferInitiative + "&nbsp;&nbsp;";
			}

			if (a.Initiative[0] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
			}

			if (a.Initiative[1] >= 100)
			{
				bufferHealth = bufferHealth + "&nbsp;&nbsp;";
				bufferFatigue = bufferFatigue + "&nbsp;&nbsp;";
				bufferBravery = bufferBravery + "&nbsp;&nbsp;";
			}

			local tooltip = [
				{
					id = 103,
					type = "hint",
					text = "Projection of this character\'s base attribute ranges calculated as if that attribute is improved on every level up from current level to " + this.Const.EL_Player.EL_PlayerLevelMax + "."
				},
				{
					id = 104,
					type = "hint",
					text = "[img]gfx/ui/icons/health_va11.png[/img] " + a.Hitpoints[0] + " to " + a.Hitpoints[1] + bufferHealth + "&nbsp;&nbsp;&nbsp;[img]gfx/ui/icons/melee_skill_va11.png[/img] " + a.MeleeSkill[0] + " to " + a.MeleeSkill[1]
				},
				{
					id = 105,
					type = "hint",
					text = "[img]gfx/ui/icons/fatigue_va11.png[/img] " + a.Fatigue[0] + " to " + a.Fatigue[1] + bufferFatigue + "&nbsp;&nbsp;&nbsp;[img]gfx/ui/icons/ranged_skill_va11.png[/img] " + a.RangedSkill[0] + " to " + a.RangedSkill[1]
				},
				{
					id = 106,
					type = "hint",
					text = "[img]gfx/ui/icons/bravery_va11.png[/img] " + a.Bravery[0] + " to " + a.Bravery[1] + bufferBravery + "&nbsp;&nbsp;&nbsp;[img]gfx/ui/icons/melee_defense_va11.png[/img] " + a.MeleeDefense[0] + " to " + a.MeleeDefense[1]
				},
				{
					id = 107,
					type = "hint",
					text = "[img]gfx/ui/icons/initiative_va11.png[/img] " + a.Initiative[0] + " to " + a.Initiative[1] + bufferInitiative + "&nbsp;&nbsp;&nbsp;[img]gfx/ui/icons/ranged_defense_va11.png[/img] " + a.RangedDefense[0] + " to " + a.RangedDefense[1]
				}
			];
			return tooltip;
		};

	});

	::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function ( o )
	{
		local addCharacterToUIData = o.addCharacterToUIData;
		o.addCharacterToUIData = function( _entity, _target )
		{
			addCharacterToUIData(_entity, _target);
			if(_entity.getLevel() < this.Const.EL_Player.EL_PlayerLevelMax) {
				_target.xpValue = _entity.getXP() - this.Const.LevelXP[_entity.getLevel()];
				_target.xpValueMax = this.Const.LevelXP[_entity.getLevel() + 1] - this.Const.LevelXP[_entity.getLevel()];
			}
			else {
				_target.xpValue = this.Const.LevelXP[this.Const.EL_Player.EL_PlayerLevelMax] - this.Const.LevelXP[this.Const.EL_Player.EL_PlayerLevelMax - 1];
				_target.xpValueMax = this.Const.LevelXP[this.Const.EL_Player.EL_PlayerLevelMax] - this.Const.LevelXP[this.Const.EL_Player.EL_PlayerLevelMax - 1];
			}
		}
	});


});
