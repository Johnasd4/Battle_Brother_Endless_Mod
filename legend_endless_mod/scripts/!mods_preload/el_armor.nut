local gt = getroottable();

::mods_registerMod("el_armor", 1, "el_armor");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/armor/armor", function ( o )
	{
        o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;
		o.m.EL_DamageBodyArmorReduction <- 0;
		o.m.EL_BaseWithRankDamageBodyArmorReduction <- 0;
		o.m.EL_DamageRegularReduction <- 0;
		o.m.EL_BaseWithRankDamageRegularReduction <- 0;

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
			result.insert(4, {
				id = 22,
				type = "text",
				text = "Rank Level: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Level: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "Level: " + this.m.EL_Level
				});
			}
			if(this.m.EL_DamageBodyArmorReduction)
			{
				result.insert(8, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "Armor condition fixation reduces damage: " + this.m.EL_DamageBodyArmorReduction
				});
			}
			if(this.m.EL_DamageRegularReduction)
			{
				result.insert(8, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Hitpoints fixation reduces damage: " + this.m.EL_DamageRegularReduction
				});
			}
			if (this.m.EL_EntryList.len() != 0)
			{
				result.push({
					id = 60,
					type = "text",
					text = "——————————————"
				});
				local tool_tip_id = 61;
				foreach(entry in this.m.EL_EntryList)
				{
					local tool_tip = entry.getTooltip(tool_tip_id);
					if(tool_tip != null)
					{
						result.push(tool_tip);
						++tool_tip_id;
					}
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
			_properties.EL_DamageBodyArmorReduction += this.EL_getDamageBodyArmorReduction();
			_properties.DamageRegularReduction += this.EL_getDamageRegularReduction();
			onUpdateProperties(_properties);
		}

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check_skill"));
			foreach(entry in this.m.EL_EntryList)
			{
				this.EL_addEntry(entry);
			}
		}

		local onUnequip = o.onUnequip;
		o.onUnequip = function ()
		{
			onUnequip();
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
		}

        local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize(_out);
			_out.writeI32(this.m.EL_BaseNoRankStaminaModifier);
			_out.writeI32(this.m.EL_BaseWithRankStaminaModifier);
			_out.writeI32(this.m.EL_DamageBodyArmorReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageBodyArmorReduction);
			_out.writeI32(this.m.EL_DamageRegularReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageRegularReduction);
			_out.writeF32(this.m.Condition);
		}


		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);
            this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
            this.m.EL_BaseWithRankStaminaModifier = _in.readI32();
			this.m.EL_DamageBodyArmorReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageBodyArmorReduction = _in.readI32();
			this.m.EL_DamageRegularReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageRegularReduction = _in.readI32();
			EL_updateLevelProperties();
            this.m.Condition = _in.readF32();
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			if(this.m.EL_Level == -1)
			{
				return "lv0";
				this.Const.EL_Item_Other.EL_OtherItemInit(this);
			}
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
		o.EL_getDamageBodyArmorReduction <- function()
        {
			return this.m.EL_DamageBodyArmorReduction;
        }
		o.EL_setDamageBodyArmorReduction <- function( _EL_damageBodyArmorReduction )
        {
			this.m.EL_DamageBodyArmorReduction = _EL_damageBodyArmorReduction;
        }
		o.EL_getBaseWithRankDamageBodyArmorReduction <- function()
        {
			return this.m.EL_BaseWithRankDamageBodyArmorReduction;
        }
		o.EL_setBaseWithRankDamageBodyArmorReduction <- function( _EL_baseWithRankDamageBodyArmorReduction )
        {
			this.m.EL_BaseWithRankDamageBodyArmorReduction = _EL_baseWithRankDamageBodyArmorReduction;
        }
		o.EL_getDamageRegularReduction <- function()
        {
			return this.m.EL_DamageRegularReduction;
        }
		o.EL_setDamageRegularReduction <- function( _EL_damageRegularReduction )
        {
			this.m.EL_DamageRegularReduction = _EL_damageRegularReduction;
        }
		o.EL_getBaseWithRankDamageRegularReduction <- function()
        {
			return this.m.EL_BaseWithRankDamageRegularReduction;
        }
		o.EL_setBaseWithRankDamageRegularReduction <- function( _EL_baseWithRankDamageRegularReduction )
        {
			this.m.EL_BaseWithRankDamageRegularReduction = _EL_baseWithRankDamageRegularReduction;
        }
		
		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return this.m.StaminaModifier - this.m.EL_BaseWithRankStaminaModifier;
		}
		o.EL_getRankLevelMax <- function()
		{
			return this.Const.EL_Item.MaxRankLevel.Normal;
		}
		o.EL_getArmorType <- function()
		{
			return this.Const.EL_Item.ArmorType.UnlayeredArmor;
		}
		o.EL_entryListSort <- function()
		{
			this.m.EL_EntryList.sort(function ( _a, _b )
			{
				if (_a.getID() > _b.getID())
				{
					return -1;
				}
				else if (_a.getID() < _b.getID())
				{
					return 1;
				}
				return 0;
			});
		}
		o.EL_getBlockedSlotNum <- function()
		{
			return this.Const.Items.ArmorUpgrades.COUNT;
		}

		//Initialize equipment based on level and rank after generating items
        o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, this.EL_getRankLevelMax());
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_recordBaseNoRankProperties();
				this.Const.EL_Armor.EL_updateRankLevelProperties(this);
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
				EL_entryListSort();
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

        o.EL_upgradeLevel <- function()
        {
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				this.m.EL_Level += 1;
				this.m.EL_CurrentLevel = this.m.EL_Level;
				EL_updateLevelProperties();
			}
        }

        o.EL_upgradeRank <- function()
        {
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				++this.m.EL_RankLevel;
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onUpgradeRank();
				}
				this.Const.EL_Armor.EL_updateRankLevelProperties(this);
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor [this.m.EL_RankLevel]);
				EL_entryListSort();
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				++this.m.EL_StrengthenEntryNum;
			}
			EL_updateLevelProperties();
        }

		o.EL_disassemble <- function(_itemIndex)
		{
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
			local stash = this.World.Assets.getStash();
			stash.remove(this);
		}

		o.EL_recraft <- function()
        {
			if(this.m.EL_RankLevel && this.m.EL_Level != -1)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				EL_init();
				this.m.EL_EntryList.clear();
				this.m.EL_RankPropertiesImproveIndex.clear();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
				EL_entryListSort();
			}
        }

		o.EL_updateLevelProperties <- function()
        {
			if(this.m.EL_BaseWithRankConditionMax == 0) {
				this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			}
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			if(this.m.EL_EntryList.len() != 0)
			{
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onItemUpdate(this);
				}
			}
		}

        o.EL_init <- function()
	    {
			this.m.EL_DamageRegularReduction = 0;
			this.m.EL_DamageBodyArmorReduction = 0;
			this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
			this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
        }

		o.EL_recordBaseNoRankProperties <- function()
	    {
			this.m.EL_BaseNoRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseNoRankValue = this.m.Value;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
            this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseWithRankValue = this.m.Value;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
        }

		o.EL_getUpgradeLevelEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level < 100)
			{
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getUpgradeRankEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				local rank_level = EL_getRankLevel() + 1;
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) 
										* (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Armor.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else
			{
				result[this.m.EL_RankLevel] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
											 * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getRecraftEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				local rank_level = this.Math.min(this.m.EL_RankLevel, this.Const.EL_Item.Type.Epic);
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)))
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
			result.insert(4, {
				id = 22,
				type = "text",
				text = "Rank Level: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Level: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "Level: " + this.m.EL_Level
				});
			}
			if(this.m.EL_DamageBodyArmorReduction)
			{
				result.insert(7, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "Armor condition fixation reduces damage: " + this.m.EL_DamageBodyArmorReduction
				});
			}
			if(this.m.EL_DamageRegularReduction)
			{
				result.insert(7, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Hitpoints fixation reduces damage: " + this.m.EL_DamageRegularReduction
				});
			}
			if (this.m.EL_EntryList.len() != 0)
			{
				result.push({
					id = 60,
					type = "text",
					text = "——————————————"
				});
				local tool_tip_id = 61;
				foreach(entry in this.m.EL_EntryList)
				{
					local tool_tip = entry.getTooltip(tool_tip_id);
					if(tool_tip != null)
					{
						result.push(tool_tip);
						++tool_tip_id;
					}
				}
			}
			// this.doOnFunction("EL_getArmorEntryTooltip", [
			// 	result
			// ]);
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
		
		local getAddedValue = o.getAddedValue;
		o.getAddedValue = function ( _function, _base, _all = false )
		{
			if(this.Const.EL_Armor.EL_isDecorativeUpgrade(this))
			{
				return _base;
			}
			return getAddedValue(_function, _base, _all);
		}

		local onUpdateProperties = o.onUpdateProperties;
		o.onUpdateProperties = function ( _properties )
		{
			_properties.EL_DamageBodyArmorReduction += this.EL_getDamageBodyArmorReduction();
			_properties.DamageRegularReduction += this.EL_getDamageRegularReduction();
			onUpdateProperties(_properties);
		}

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check_skill"));
			foreach(entry in this.m.EL_EntryList)
			{
				this.EL_addEntry(entry);
			}
		}

		local onUnequip = o.onUnequip;
		o.onUnequip = function ()
		{
			onUnequip();
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
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
		o.EL_getDamageBodyArmorReduction <- function()
        {
			local result = this.m.EL_DamageBodyArmorReduction;
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					result += upgrade.EL_getDamageBodyArmorReduction();
				}
			}
			return result;
        }
		o.EL_getDamageRegularReduction <- function()
        {
			local result = this.m.EL_DamageRegularReduction;
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					result += upgrade.EL_getDamageRegularReduction();
				}
			}
			return result;
        }
		o.EL_getArmorType <- function()
		{
			return this.Const.EL_Item.ArmorType.BaseArmor;
		}
		o.EL_getBlockedSlotNum <- function()
		{
			local num = 0;
			for( local i = 0; i < this.Const.Items.ArmorUpgrades.COUNT; ++i )
			{
				if(this.m.Blocked[i] == true)
				{
					++num;
				}
			}
			return num;
		}
		
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
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, this.EL_getRankLevelMax());
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_recordBaseNoRankProperties();
				this.Const.EL_Armor.EL_updateRankLevelProperties(this);
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
				EL_entryListSort();
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

        o.EL_upgradeLevel <- function()
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return;
				}
			}
			this.armor.EL_upgradeLevel();
        }

        o.EL_upgradeRank <- function()
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return;
				}
			}
			this.armor.EL_upgradeRank();
			EL_entryListSort();
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
			this.armor.EL_disassemble(_itemIndex);
		}

		o.EL_recraft <- function()
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return;
				}
			}
			this.armor.EL_recraft();
			EL_entryListSort();
        }

		o.EL_updateLevelProperties <- function() 
        {
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					upgrade.EL_updateLevelProperties(true);
				}
			}
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.EL_DamageRegularReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageRegularReduction * (1 + this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction * this.m.EL_CurrentLevel));
			this.m.EL_DamageBodyArmorReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageBodyArmorReduction * (1 + this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null && upgrade.m.EL_EntryList.len() != 0)
				{
					for( local index = 0; index < upgrade.m.EL_StrengthenEntryNum && index < upgrade.m.EL_EntryList.len(); ++index )
					{
						upgrade.m.EL_EntryList[index].EL_strengthen();
					}
					foreach(entry in upgrade.m.EL_EntryList)
					{
						entry.EL_onItemUpdate(this);
					}
				}
			}
			if(this.m.EL_EntryList.len() != 0)
			{
				for( local index = 0; index < this.m.EL_StrengthenEntryNum && index < this.m.EL_EntryList.len(); ++index )
				{
					this.m.EL_EntryList[index].EL_strengthen();
				}
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onItemUpdate(this);
				}
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
			if(this.m.EL_Level == -1)
			{
				return "lv0";
				this.Const.EL_Item_Other.EL_OtherItemInit(this);
			}
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
		

		o.EL_getUpgradeLevelEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return result;
				}
			}
			if(this.m.EL_Level < 100)
			{
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getUpgradeRankEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return result;
				}
			}
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				local rank_level = EL_getRankLevel() + 1;
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) 
										* (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Armor.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else
			{
				result[this.m.EL_RankLevel] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
											 * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			foreach(upgrade in this.m.Upgrades)
            {
				if(upgrade != null)
				{
					local array = upgrade.EL_getDisassembleEquipmentEssenceNum();
					for(local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
					{
						result[index] += array[index];
					}
				}
            }
			return result;
		}

		o.EL_getRecraftEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					return result;
				}
			}
			if(this.m.EL_RankLevel)
			{
				local rank_level = this.Math.min(this.m.EL_RankLevel, this.Const.EL_Item.Type.Epic);
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)))
			}
			return result;
		}
	});

    ::mods_hookExactClass("items/legend_armor/legend_armor_upgrade", function ( o )
	{
		o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;
		o.m.EL_DamageBodyArmorReduction <- 0;
		o.m.EL_BaseWithRankDamageBodyArmorReduction <- 0;
		o.m.EL_DamageRegularReduction <- 0;
		o.m.EL_BaseWithRankDamageRegularReduction <- 0;

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
			result.insert(3, {
				id = 22,
				type = "text",
				text = "Rank Level: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(4, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Level: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(4, {
					id = 23,
					type = "text",
					text = "Level: " + this.m.EL_Level
				});
			}
			if(this.m.EL_DamageBodyArmorReduction)
			{
				result.insert(7, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "Armor condition fixation reduces damage: " + this.m.EL_DamageBodyArmorReduction
				});
			}
			if(this.m.EL_DamageRegularReduction)
			{
				result.insert(7, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Hitpoints fixation reduces damage: " + this.m.EL_DamageRegularReduction
				});
			}
			if (this.m.EL_EntryList.len() != 0)
			{
				result.push({
					id = 60,
					type = "text",
					text = "——————————————"
				});
				local tool_tip_id = 61;
				foreach(entry in this.m.EL_EntryList)
				{
					local tool_tip = entry.getTooltip(tool_tip_id);
					if(tool_tip != null)
					{
						result.push(tool_tip);
						++tool_tip_id;
					}
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
				if(this.m.EL_CurrentLevel < this.m.EL_Level)
				{
					_result.push({
						id = 10,
						type = "text",
						icon = "ui/icons/armor_body.png",
						text = this.getName() + " (" + this.EL_getRankLevel() + "/" + this.EL_getRankLevelMax() + ") [color=" + this.Const.UI.Color.NegativeValue + "] (" + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + ")[/color]"
					});
				}
				else
				{
					_result.push({
						id = 10,
						type = "text",
						icon = "ui/icons/armor_body.png",
						text = this.getName() + " (" + this.EL_getRankLevel() + "/" + this.EL_getRankLevelMax() + ") (" + this.m.EL_Level + ")"
					});
				}
			}
			else
			{
				if(this.m.EL_CurrentLevel < this.m.EL_Level)
				{
					_result.push({
						id = 10,
						type = "text",
						icon = "ui/icons/armor_body.png",
						text = "[color=" + this.Const.EL_Item.Colour[this.m.EL_RankLevel] +"]" + this.getName() + " (" + this.EL_getRankLevel() + "/" + this.EL_getRankLevelMax() + ")[/color][color=" + this.Const.UI.Color.NegativeValue + "](" + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + ")[/color]"
					});
				}
				else
				{
					_result.push({
						id = 10,
						type = "text",
						icon = "ui/icons/armor_body.png",
						text = "[color=" + this.Const.EL_Item.Colour[this.m.EL_RankLevel] +"]" + this.getName() + " (" + this.EL_getRankLevel() + "/" + this.EL_getRankLevelMax() + ") (" + this.m.EL_Level + ")[/color]"
					});
				}
			}
			local _id = 64;
			foreach(entry in this.m.EL_EntryList)
			{
				_result.push(entry.getTooltip(_id));
				++_id;
			}
	    	this.onArmorTooltip(_result);
	    }

		// o.EL_getArmorEntryTooltip <- function ( _result )
	    // {
	    // 	local _id = 64;
		// 	foreach(entry in this.m.EL_EntryList)
		// 	{
		// 		_result.push(entry.getTooltip(_id));
		// 		++_id;
		// 	}
	    // 	this.onArmorTooltip(_result);
	    // }

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check_skill"));
            foreach(entry in this.m.EL_EntryList)
			{
				this.EL_addEntry(entry);
			}
		}

		local onUnequip = o.onUnequip;
		o.onUnequip = function ()
		{
			onUnequip();
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
		}

        local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize(_out);
			_out.writeI32(this.m.EL_BaseNoRankStaminaModifier);
			_out.writeI32(this.m.EL_BaseWithRankStaminaModifier);
			_out.writeI32(this.m.EL_DamageBodyArmorReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageBodyArmorReduction);
			_out.writeI32(this.m.EL_DamageRegularReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageRegularReduction);
			_out.writeF32(this.m.Condition);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);
            this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
            this.m.EL_BaseWithRankStaminaModifier = _in.readI32();
			this.m.EL_DamageBodyArmorReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageBodyArmorReduction = _in.readI32();
			this.m.EL_DamageRegularReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageRegularReduction = _in.readI32();
			EL_updateLevelProperties();
            this.m.Condition = _in.readF32();
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			if(this.m.EL_Level == -1)
			{
				return "lv0";
				this.Const.EL_Item_Other.EL_OtherItemInit(this);
			}
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
		o.EL_getBaseWithRankVision <- function()
        {
			return this.m.EL_BaseNoRankVision;
        }
		o.EL_setBaseWithRankVision <- function( _EL_baseWithRankVision )
        {
			this.m.EL_BaseNoRankVision = _EL_baseWithRankVision;
        }
		o.EL_getDamageBodyArmorReduction <- function()
        {
			return this.m.EL_DamageBodyArmorReduction;
        }
		o.EL_setDamageBodyArmorReduction <- function( _EL_damageBodyArmorReduction )
        {
			this.m.EL_DamageBodyArmorReduction = _EL_damageBodyArmorReduction;
        }
		o.EL_getBaseWithRankDamageBodyArmorReduction <- function()
        {
			return this.m.EL_BaseWithRankDamageBodyArmorReduction;
        }
		o.EL_setBaseWithRankDamageBodyArmorReduction <- function( _EL_baseWithRankDamageBodyArmorReduction )
        {
			this.m.EL_BaseWithRankDamageBodyArmorReduction = _EL_baseWithRankDamageBodyArmorReduction;
        }
		o.EL_getDamageRegularReduction <- function()
        {
			return this.m.EL_DamageRegularReduction;
        }
		o.EL_setDamageRegularReduction <- function( _EL_damageRegularReduction )
        {
			this.m.EL_DamageRegularReduction = _EL_damageRegularReduction;
        }

		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return this.m.StaminaModifier - this.m.EL_BaseWithRankStaminaModifier;
		}
		o.EL_getRankLevelMax <- function()
		{
			return this.Const.EL_Item.MaxRankLevel.Normal;
		}
		o.EL_getArmorType <- function()
		{
			return this.Const.EL_Item.ArmorType.ArmorUpgrade;
		}
		o.EL_getBlockedSlotNum <- function()
		{
			return 0;
		}

		o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
        {
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, this.EL_getRankLevelMax());
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				EL_recordBaseNoRankProperties();
				this.Const.EL_Armor.EL_updateRankLevelProperties(this);
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

        o.EL_upgradeLevel <- function()
        {
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				this.m.EL_Level += 1;
				this.m.EL_CurrentLevel = this.m.EL_Level;
				EL_updateLevelProperties();
			}
        }

        o.EL_upgradeRank <- function()
        {
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				++this.m.EL_RankLevel;
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onUpgradeRank();
				}
				this.Const.EL_Armor.EL_updateRankLevelProperties(this);
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor [this.m.EL_RankLevel]);
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				++this.m.EL_StrengthenEntryNum;
			}
			EL_updateLevelProperties();
        }

		o.EL_disassemble <- function(_itemIndex)
		{
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
			local stash = this.World.Assets.getStash();
			stash.remove(this);
		}

		o.EL_recraft <- function()
        {
			if(this.m.EL_RankLevel && this.m.EL_Level != -1)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				EL_init();
				this.m.EL_EntryList.clear();
				this.m.EL_RankPropertiesImproveIndex.clear();
				this.Const.EL_Armor.EL_assignItemEntrys(this, this.Const.EL_Armor.EL_Entry.EntryNum.NormalArmor[this.m.EL_RankLevel]);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function( _isItemUpdate = false )
        {
			if(this.Const.EL_Armor.EL_isDecorativeUpgrade(this))
			{
				this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
				local entryNum = this.Const.EL_Armor.EL_Entry.EntryNum.DecorativeArmor[this.m.EL_RankLevel] * this.m.EL_CurrentLevel;
				for(local num = 0.0; num < this.m.EL_EntryList.len(); ++num)
				{
					this.m.EL_EntryList[num].EL_setCurrentLevel(entryNum - num);
				}
			}
			else
			{
				this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
				this.m.EL_DamageRegularReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageRegularReduction * (1 + this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction * this.m.EL_CurrentLevel));
				this.m.EL_DamageBodyArmorReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageBodyArmorReduction * (1 + this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction * this.m.EL_CurrentLevel));
				this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Armor.EL_LevelFactor.Value * this.m.EL_Level));
				this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
				if(this.getType() == this.Const.Items.ArmorUpgrades.Attachment)
				{
					local entryNum = this.Const.EL_Armor.EL_Entry.EntryNum.DecorativeArmor[this.m.EL_RankLevel] * this.m.EL_CurrentLevel;
					for(local num = 0.0; num < this.m.EL_EntryList.len(); ++num)
					{
						this.m.EL_EntryList[num].EL_setCurrentLevel(entryNum - num);
					}
				}
			}
			if(this.m.EL_EntryList.len() != 0 && !_isItemUpdate )
			{
				for( local index = 0; index < this.m.EL_StrengthenEntryNum && index < this.m.EL_EntryList.len(); ++index )
				{
					this.m.EL_EntryList[index].EL_strengthen();
				}
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onItemUpdate(this);
				}
			}
		}

        o.EL_init <- function()
	    {
			this.m.EL_DamageRegularReduction = 0;
			this.m.EL_DamageBodyArmorReduction = 0;
			this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
			this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
        }

		o.EL_recordBaseNoRankProperties <- function()
	    {
			this.m.EL_BaseNoRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseNoRankValue = this.m.Value;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
            this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
		    this.m.EL_BaseWithRankValue = this.m.Value;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
        }

		o.EL_getUpgradeLevelEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_Level < 100)
			{
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getUpgradeRankEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				local rank_level = EL_getRankLevel() + 1;
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) 
										* (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Armor.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Armor.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else
			{
				result[this.m.EL_RankLevel] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.DisassembleFactor
											 * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getRecraftEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				local rank_level = this.Math.min(this.m.EL_RankLevel, this.Const.EL_Item.Type.Epic);
				local min_calculate_weight = this.Const.EL_Armor.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Armor.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.floor(this.Const.EL_Armor.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Armor.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Armor.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)))
			}
			return result;
		}
	});
});
