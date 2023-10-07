local gt = getroottable();

::mods_registerMod("el_armor", 1, "el_armor");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/armor/armor", function ( o )
	{
        o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;

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
			_out.writeI32(this.m.EL_BaseNoRankStaminaModifier);
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
            this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
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

		//Initialize equipment based on level and rank after generating items
        o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, 4);
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_init();
				EL_updateRankLevelProperties();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.m.Condition = this.Math.floor(this.m.ConditionMax * percent);
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
				this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
				this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
				this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
				this.m.EL_Entrylist.clear();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function()
        {
			if(this.m.EL_Level == -1)
			{
				local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
				local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
				local random = this.Math.rand(1, 1000);

				if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Premium, level);
					//this.logInfo("物品升阶");
				}
				else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, level);
					//this.logInfo("物品升阶大成功");
				}
				else
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
			}
			if(this.m.EL_BaseWithRankConditionMax == 0) {
				this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			}
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
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
            this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * this.Const.EL_Armor.EL_RankValue[this.m.EL_RankLevel];
			local isReduceWeight = this.Math.rand(0, 1);
			if(this.m.EL_RankLevel >= 1 && this.m.EL_RankLevel != 4)
			{
				local available = [];
				local weightList = [];
				local weightSum = 0;
				foreach	(func in this.Const.EL_Armor.EL_RankPropertiesInitFunctions)
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
				foreach	(func in this.Const.EL_Armor.EL_RankPropertiesInitFunctions)
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

        o.EL_init <- function()
	    {
			this.m.EL_BaseNoRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseNoRankValue = this.m.Value;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
            this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseWithRankValue = this.m.Value;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
        }

		o.EL_getUpgradeEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level <= 100)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.UpgradeFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			}
			return result;
		}

		o.EL_getDisassembleEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.DisassembleFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			return result;
		}

		o.EL_getRecraftEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.RecraftFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel));
			}
			return result;
		}
	});
    ::mods_hookExactClass("items/legend_armor/legend_armor", function ( o )
	{
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
			this.doOnFunction("EL_getArmorEntryTooltip", [
				result
			]);
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

		o.EL_setLevel <- function( _EL_level )
		{
			if(this.m.EL_Level != -1)
			{
				foreach(upgrade in this.m.Upgrades)
				{
					if(upgrade != null)
					{
						upgrade.EL_setLevel(_EL_level);
					}
				}
				this.m.EL_Level = this.Math.max(0, this.Math.min(this.m.EL_Level, _EL_level));
				this.m.EL_CurrentLevel = this.m.EL_Level;
				EL_updateLevelProperties();
			}
		}

		o.EL_setCurrentLevel <- function( _EL_level )
		{
			if(this.m.EL_Level != -1)
			{
				foreach(upgrade in this.m.Upgrades)
				{
					if(upgrade != null)
					{
						upgrade.EL_setCurrentLevel(_EL_level);
					}
				}
				this.m.EL_CurrentLevel = this.Math.max(0, this.Math.min(this.m.EL_Level, _EL_level));
				EL_updateLevelProperties();
				this.m.Condition = (this.m.Condition > this.m.ConditionMax) ? this.m.ConditionMax : this.m.Condition;
			}
		}


		o.EL_setRankLevel <- function( _EL_rankLevel )
		{
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_setRankLevel(_EL_rankLevel);
				}
			}
			this.m.EL_RankLevel = _EL_rankLevel;
			EL_recraft();
		}

		o.EL_addRankLevel <- function()
		{
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_addRankLevel();
				}
			}
			++this.m.EL_RankLevel;
			EL_recraft();
		}
		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			local result = this.m.StaminaModifier - this.m.EL_BaseWithRankStaminaModifier;
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					result += upgrade.EL_getLevelAddtionStaminaModifier();
				}
			}
			return result;
		}

		//Initialize equipment based on level and rank after generating items
        o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.getCondition() * 1.0)/ this.getConditionMax();
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_generateByRankAndLevel(_EL_rankLevel, EL_level, EL_additionalRarityChance);
				}
			}
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, 4);
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_init();
				EL_updateRankLevelProperties();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

        o.EL_upgrade <- function()
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_upgrade();
				}
			}
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.m.EL_Level += 1;
				this.m.EL_CurrentLevel += 1;
				EL_updateLevelProperties();
			}
        }

		o.EL_disassemble <- function(_itemIndex)
		{
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_disassemble(_itemIndex);
				}
			}
			local stash = this.World.Assets.getStash();
			stash.remove(this);
		}

		o.EL_recraft <- function()
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_recraft();
				}
			}
			if(this.m.EL_RankLevel && this.m.EL_Level != -1)
			{
				this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
				this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
				this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
				this.m.EL_Entrylist.clear();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.getCondition <- function()
		{
			return this.Math.floor(this.getAddedValue("getCondition", this.m.Condition));
		}

		o.getConditionMax <- function()
		{
			return this.Math.floor(this.getAddedValue("getConditionMax", this.m.ConditionMax));
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			if(this.getCondition() < this.getConditionMax())
			{
				return "lv" + this.m.EL_Level + ":" + this.Math.floor(this.getCondition() / (this.getConditionMax() * 1.0) * 100) + "%";
			}
			return "lv" + this.m.EL_Level;
		}

		o.getAmountColor = function()
		{
			return this.Const.EL_Item.Colour[this.m.EL_RankLevel];
		}

		o.EL_getUpgradeEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level <= 100)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.UpgradeFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			}
			foreach(upgrade in this.m.Upgrades)
            {
				if(upgrade != null)
				{
					local array = upgrade.EL_getUpgradeEssence();
					for(local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
					{
						result[index] += array[index];
					}
				}
            }
			return result;
		}

		o.EL_getDisassembleEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.DisassembleFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			foreach(upgrade in this.m.Upgrades)
            {
				if(upgrade != null)
				{
					local array = upgrade.EL_getDisassembleEssence();
					for(local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
					{
						result[index] += array[index];
					}
				}
            }
			return result;
		}

		o.EL_getRecraftEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.RecraftFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel));
			}
			foreach(upgrade in this.m.Upgrades)
            {
				if(upgrade != null)
				{
					local array = upgrade.EL_getRecraftEssence();
					for(local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
					{
						result[index] += array[index];
					}
				}
            }
			//this.logInfo("result[0]" +result[0]+" result[1]" +result[1]+" result[2]" +result[2]+" result[3]" +result[3]+" result[4]" +result[4]);
			return result;
		}
	});

    ::mods_hookExactClass("items/legend_armor/legend_armor_upgrade", function ( o )
	{
		o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;

		local getTooltip = o.getTooltip;
		o.getTooltip = function ()
		{
			if(this.m.EL_Level == -1)
			{
				local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
				local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
				local random = this.Math.rand(1, 1000);

				if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Premium, level);
					//this.logInfo("物品升阶");
				}
				else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, level);
					//this.logInfo("物品升阶大成功");
				}
				else
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
			}
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
				result.insert(3, {
					id = 22,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Level: " + this.m.EL_CurrentLevel + "[/color](" + this.m.EL_Level + ")"
				});
			}
			else
			{
				result.insert(3, {
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

        o.getArmorTooltip = function ( _result )
	    {
	    	_result.push({
	    		id = 10,
	    		type = "text",
	    		icon = "",
	    		text = " "
	    	});
			if(this.m.EL_RankLevel == 0)
			{
				_result.push({
	    			id = 10,
	    			type = "text",
	    			icon = "ui/icons/armor_body.png",
	    			text = "[u]" + this.getName() + "[/u]"
	    		});
			}
			else
			{
				_result.push({
	    			id = 10,
	    			type = "text",
	    			icon = "ui/icons/armor_body.png",
	    			text = "[color=" + this.Const.EL_Item.Colour[this.m.EL_RankLevel] +"][u]" + this.getName() + "[/u][/color]"
	    		});
			}
	    	this.onArmorTooltip(_result);
	    }

		o.EL_getArmorEntryTooltip <- function ( _result )
	    {
	    	local _id = 64;
			foreach(entry in this.m.EL_Entrylist)
			{
				_result.push(entry.getTooltip(_id));
				++_id;
			}
	    	this.onArmorTooltip(_result);
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
			_out.writeI32(this.m.EL_BaseNoRankStaminaModifier);
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
            this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
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

		o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, 4);
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_init();
				EL_updateRankLevelProperties();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.m.Condition = this.Math.floor(this.m.ConditionMax * percent);
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
				this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
				this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
				this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
				this.m.EL_Entrylist.clear();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function()
        {
			if(this.m.EL_Level == -1)
			{
				local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
				local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
				local random = this.Math.rand(1, 1000);

				if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Premium, level);
					//this.logInfo("物品升阶");
				}
				else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, level);
					//this.logInfo("物品升阶大成功");
				}
				else
				{
					this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
			}
			if(this.m.EL_BaseWithRankConditionMax == 0) {
				this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			}
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
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
            this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * this.Const.EL_Armor.EL_RankValue[this.m.EL_RankLevel];
			local isReduceWeight = this.Math.rand(0, 1);
			if(this.m.EL_RankLevel >= 1 && this.m.EL_RankLevel != 4)
			{
				local available = [];
				local weightList = [];
				local weightSum = 0;
				foreach	(func in this.Const.EL_Armor.EL_RankPropertiesInitFunctions)
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
				foreach	(func in this.Const.EL_Armor.EL_RankPropertiesInitFunctions)
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

        o.EL_init <- function()
	    {
			this.m.EL_BaseNoRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseNoRankValue = this.m.Value;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
            this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseWithRankValue = this.m.Value;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
        }

		o.EL_getUpgradeEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level <= 100)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.UpgradeFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			}
			return result;
		}

		o.EL_getDisassembleEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.DisassembleFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			return result;
		}

		o.EL_getRecraftEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Armor.EL_Essence.SlotFactor * this.Const.EL_Armor.EL_Essence.RecraftFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel));
			}
			return result;
		}
	});
});
