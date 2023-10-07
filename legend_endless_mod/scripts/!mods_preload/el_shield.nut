local gt = getroottable();

::mods_registerMod("el_shield", 1, "el_shield");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/shields/shield", function ( o )
	{
		o.m.EL_BaseNoRankMeleeDefense <- 0;
		o.m.EL_BaseNoRankRangedDefense <- 0;
		o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankMeleeDefense <- 0;
		o.m.EL_BaseWithRankRangedDefense <- 0;
		o.m.EL_BaseWithRankStaminaModifier <- 0;
		o.m.EL_BaseNoRankFatigueOnSkillUse <- 0;
		o.m.EL_BaseWithRankFatigueOnSkillUse <- 0;

		local getTooltip = o.getTooltip;
		o.getTooltip = function ()
		{
			local result = getTooltip();
			if(this.m.EL_RankLevel == 0)
			{
				result[0] = {
					id = 1,
					type = "title",
					text = this.getName()
				};
			}
			else
			{
				result[0] = {
					id = 1,
					type = "title",
					text = "[color=" + this.Const.EL_Item.Colour[this.m.EL_RankLevel] +"]" + this.getName() + "[/color]"
				};
			}
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(4, {
					id = 22,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Level: " + this.m.EL_CurrentLevel + "[/color](" + this.m.EL_Level + ")"
				});
			}
			else
			{
				result.insert(4, {
					id = 22,
					type = "text",
					text = "Level: " + this.m.EL_Level
				});
			}
			if (this.m.EL_Entrylist.len() != 0)
			{
				result.push({
					id = 60,
					type = "text",
					text = "——————————————"
				});
				local _id = 61;
				foreach(entry in this.m.EL_Entrylist)
				{
					result.push(entry.getTooltip(_id));
					++_id;
				}
			}
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.push({
					id = 75,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Current combatlevel cannot fully utilize the item's performance.[/color]"
				});
			}
			return result;
		}

		local onUpdateProperties = o.onUpdateProperties;
		o.onUpdateProperties = function ( _properties )
		{
			if (this.m.Condition == 0)
			{
				return;
			}
			local mult = 1.0;
			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
			{
				mult = 1.25;
			}
			_properties.MeleeDefense += this.Math.floor(this.m.MeleeDefense * mult);
			_properties.RangedDefense += this.Math.floor(this.m.RangedDefense * mult);
			local staminaMult = this.getContainer().getActor().getSkills().hasSkill("perk.brawny") ? 0.7 : 1.0;
			_properties.Stamina += this.Math.floor(this.m.StaminaModifier * staminaMult);
		}

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check_skill"));
            foreach(entry in this.m.EL_Entrylist)
			{
				this.EL_addEntry(entry);
			}
		}

		local onUnequip = o.onUnequip;
		o.onUnequip = function ()
		{
			onUnequip();
			//this.addSkill(this.new("scripts/skills/el_entrys/el_total_entry"));
			if( this.m.EL_CurrentLevel < this.m.EL_Level )
			{
				this.m.EL_CurrentLevel = this.m.EL_Level;
				EL_updateLevelProperties();
			}
		}

        local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize(_out);
			_out.writeU8(this.m.EL_Entrylist.len());
			if(this.m.EL_Entrylist.len() != 0)
			{
				foreach(entry in this.m.EL_Entrylist)
				{
					_out.writeI32(entry.ClassNameHash);
					entry.onSerialize(_out);
				}
			}
			_out.writeI32(this.m.FatigueOnSkillUse);
			_out.writeI32(this.m.EL_BaseNoRankFatigueOnSkillUse);
			_out.writeI32(this.m.EL_BaseWithRankFatigueOnSkillUse);

			_out.writeI32(this.m.EL_BaseNoRankMeleeDefense);
			_out.writeI32(this.m.EL_BaseNoRankRangedDefense);
			_out.writeI32(this.m.EL_BaseNoRankStaminaModifier);
			_out.writeI32(this.m.EL_BaseWithRankMeleeDefense);
			_out.writeI32(this.m.EL_BaseWithRankRangedDefense);
			_out.writeI32(this.m.EL_BaseWithRankStaminaModifier);
			_out.writeF32(this.m.Condition);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);
			this.m.EL_Entrylist.clear();

			local EL_EntrylistLen = _in.readU8();
			for( local i = 0; i != EL_EntrylistLen; ++i )
			{
				local entry = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
				entry.onDeserialize(_in);
				this.m.EL_Entrylist.push(entry);
			}

			this.m.FatigueOnSkillUse = _in.readI32();
			this.m.EL_BaseNoRankFatigueOnSkillUse = _in.readI32();
			this.m.EL_BaseWithRankFatigueOnSkillUse = _in.readI32();

			this.m.EL_BaseNoRankMeleeDefense = _in.readI32();
			this.m.EL_BaseNoRankRangedDefense = _in.readI32();
			this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
            this.m.EL_BaseWithRankMeleeDefense = _in.readI32();
			this.m.EL_BaseWithRankRangedDefense = _in.readI32();
			this.m.EL_BaseWithRankStaminaModifier = _in.readI32();
			EL_updateLevelProperties();
			this.m.Condition = _in.readF32();
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			if(this.m.Condition < this.m.ConditionMax)
			{
				return "lv" + this.m.EL_Level + ":" + this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * 100) + "%";
			}
			return "lv" + this.m.EL_Level;
		}

		o.getAmountColor = function()
		{
			return this.Const.EL_Item.Colour[this.m.EL_RankLevel];
		}

		o.EL_getBaseNoRankStaminaModifier <- function()
        {
			return this.m.EL_BaseNoRankStaminaModifier;
        }
		o.EL_setBaseNoRankStaminaModifier <- function( _EL_baseNoRankStaminaModifier )
        {
			this.m.EL_BaseNoRankStaminaModifier = _EL_baseNoRankStaminaModifier;
        }
		o.EL_getBaseWithRankStaminaModifier <- function()
        {
			return this.m.EL_BaseWithRankStaminaModifier;
        }
		o.EL_setBaseWithRankStaminaModifier <- function( _EL_baseWithRankStaminaModifier )
        {
			this.m.EL_BaseWithRankStaminaModifier = _EL_baseWithRankStaminaModifier;
        }
		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return this.m.StaminaModifier - this.m.EL_BaseWithRankStaminaModifier;
		}
		o.EL_getLevelString <- function()
		{
			if (this.m.EL_Level > -1)
			{
				return "LV[b]" + this.m.EL_Level + "[/b]";
			}
			return "";
		}

		o.EL_getLevelStringColour <- function()
		{
			if (this.m.EL_Level > -1)
			{
				return this.Const.EL_Item.Colour[this.m.EL_RankLevel];
			}
			return "#ffffff";
		}
        o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, 4);
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_init();
				EL_updateRankLevelProperties();
				this.Const.EL_Shield.EL_assignItemEntrys(this, this.Const.EL_Shield.EL_Entry.EntryNum.NormalShield[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.m.Condition = this.m.ConditionMax * percent;
        }

        o.EL_upgrade <- function()
        {
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.m.EL_Level += 1;
				this.m.EL_CurrentLevel += 1;
				EL_updateLevelProperties();
			}
        }

		o.EL_disassemble <- function(_itemIndex)
		{
			local stash = this.World.Assets.getStash();
			stash.remove(this);
		}

		o.EL_recraft <- function()
        {
			if(this.m.EL_RankLevel && this.m.EL_Level != -1)
			{
				this.m.FatigueOnSkillUse = this.m.EL_BaseNoRankFatigueOnSkillUse;
				this.m.EL_BaseWithRankMeleeDefense = this.m.EL_BaseNoRankMeleeDefense;
				this.m.EL_BaseWithRankRangedDefense = this.m.EL_BaseNoRankRangedDefense;
		  	    this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
				this.m.EL_Entrylist.clear();
				this.Const.EL_Shield.EL_assignItemEntrys(this, this.Const.EL_Shield.EL_Entry.EntryNum.NormalShield[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function()
        {
			if(this.m.EL_BaseWithRankConditionMax == 0) {
				this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			}
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Shield.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Shield.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.MeleeDefense = this.Math.ceil(this.m.EL_BaseWithRankMeleeDefense * (1 + this.Const.EL_Shield.EL_LevelFactor.MeleeDefense * this.m.EL_CurrentLevel));
			this.m.RangedDefense = this.Math.ceil(this.m.EL_BaseWithRankRangedDefense * (1 + this.Const.EL_Shield.EL_LevelFactor.RangedDefense * this.m.EL_CurrentLevel));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Shield.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			if(this.m.EL_Entrylist.len() != 0)
			{
				foreach(entry in this.m.EL_Entrylist)
				{
					entry.EL_onItemUpdate(this);
				}
			}
		}

		o.EL_updateRankLevelProperties <- function()
        {
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * gt.Const.EL_Shield.EL_RankValue[this.m.EL_RankLevel];
			local isReduceWeight = this.Math.rand(0, 1);
			if(this.m.EL_RankLevel >= 1 && this.m.EL_RankLevel != 4)
			{
				local available = [];
				local weightList = [];
				local weightSum = 0;
				foreach	(func in gt.Const.EL_Shield.EL_RankPropertiesInitFunctions)
				{
					if(func.ifUsable(this))
					{
						available.push(func.changeValues);
						weightList.push(func.weight);
						weightSum += func.weight;
					}
				}
				for( local count = 2; count != 0 && available.len() != 0; --count )
				{
					local roll = this.Math.rand(0, weightSum - weightList[0]);
					local number = 0;
					for( local index = 0; index < weightList.len(); ++index )
					{
						if(roll > weightList[index])
						{
							++number;
							roll -= weightList[index];
						}
						else
						{
							break;
						}
					}
					weightSum -= weightList[number];
					weightList.remove(number);
					available[number](this, isReduceWeight);
					available.remove(number);
				}
			}
			for(local index = 1; index < this.m.EL_RankLevel; ++index)
			{
				local available = [];
				foreach	(func in gt.Const.EL_Shield.EL_RankPropertiesInitFunctions)
				{
					if(func.ifUsable(this))
					{
						available.push(func.changeValues);
					}
				}
				for( local index = 0; index < available.len(); ++index )
				{
					available[index](this, isReduceWeight);
				}
			}
        }

		// o.EL_entryGenerate <- function( EL_additionalRarityChance = 0 )
		// {
		// 	local entryCount = this.Const.EL_Shield.EL_EntryCount[this.m.EL_RankLevel];
		// 	local isAdded = [];
		// 	for(local index = 0; index < this.Const.EL_Shield.EL_EntryID.COUNT; ++index)
		// 	{
		// 		isAdded.push(1);
		// 	}
		// 	local weightList = [];
		// 	local weightSum = 0;
		// 	for(local index = 0; index < 9/*this.Const.EL_Shield.EL_EntryID.COUNT*/; ++index)
		// 	{
		// 		weightList.push(this.Const.EL_Shield.EL_EntryWeight[index]);
		// 		weightSum += this.Const.EL_Shield.EL_EntryWeight[index];
		// 	}
		// 	local count = 0;
		// 	while(count < entryCount)
		// 	{
		// 		local roll = this.Math.rand(0, weightSum - weightList[0]);
		// 		local number = 0;
		// 		for(local index = 0; index < weightList.len(); ++index)
		// 		{
		// 			if(roll >= weightList[index])
		// 			{
		// 				++number;
		// 				roll -= weightList[index];
		// 			}
		// 			else
		// 			{
		// 				break;
		// 			}
		// 		}
		// 		if(isAdded[number])
		// 		{
		// 			isAdded[number] = 0;
		// 			++count;
		// 			local entry = this.new(this.Const.EL_Shield.EL_EntryRoute[number]);
		// 			entry.setItem(this);
		// 			this.m.EL_Entrylist.push(entry);
		// 		}
		// 	}
		// }

        o.EL_init <- function()
	    {
			this.m.EL_BaseNoRankFatigueOnSkillUse = this.m.FatigueOnSkillUse;
			this.m.EL_BaseWithRankFatigueOnSkillUse = this.m.FatigueOnSkillUse;
			this.m.EL_BaseNoRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseNoRankValue = this.m.Value;
			this.m.EL_BaseNoRankMeleeDefense = this.m.MeleeDefense;
			this.m.EL_BaseNoRankRangedDefense = this.m.RangedDefense;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
			this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			this.m.EL_BaseWithRankValue = this.m.Value;
			this.m.EL_BaseWithRankMeleeDefense = this.m.MeleeDefense;
			this.m.EL_BaseWithRankRangedDefense = this.m.RangedDefense;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
        }

		o.EL_getUpgradeEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level < 100)
			{
				result[this.m.EL_RankLevel] +=  this.Const.EL_Shield.EL_Essence.SlotFactor * this.Const.EL_Shield.EL_Essence.UpgradeFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Shield.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			}
			return result;
		}

		o.EL_getDisassembleEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Shield.EL_Essence.SlotFactor * this.Const.EL_Shield.EL_Essence.DisassembleFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Shield.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			return result;
		}

		o.EL_getRecraftEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Shield.EL_Essence.SlotFactor * this.Const.EL_Shield.EL_Essence.RecraftFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Shield.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel));
			}
			return result;
		}
	});
});
