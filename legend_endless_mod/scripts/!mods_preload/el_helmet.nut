local gt = getroottable();

::mods_registerMod("el_helmet", 1, "el_helmet");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/helmets/helmet", function ( o )
	{
        o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;
		o.m.EL_BaseNoRankVision <-0;
		o.m.EL_DamageHeadArmorReduction <- 0;
		o.m.EL_BaseWithRankDamageHeadArmorReduction <- 0;
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
				text = "等阶: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]等级: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "等级: " + this.m.EL_Level
				});
			}
			if(this.m.EL_DamageHeadArmorReduction)
			{
				result.insert(8, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "头盔耐久固定减伤: " + this.m.EL_DamageHeadArmorReduction
				});
			}
			if(this.m.EL_DamageRegularReduction)
			{
				result.insert(8, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "血量固定减伤:  " + this.m.EL_DamageRegularReduction
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]当前人物的战斗等级无法发挥装备全部性能。[/color]"
				});
			}
			return result;
		}

		local onUpdateProperties = o.onUpdateProperties;
		o.onUpdateProperties = function ( _properties )
		{
			_properties.EL_DamageHeadArmorReduction += this.EL_getDamageHeadArmorReduction();
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
			_out.writeI8(this.m.EL_BaseNoRankVision);
			_out.writeI8(this.m.Vision);
			_out.writeI32(this.m.EL_DamageHeadArmorReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageHeadArmorReduction);
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
			this.m.EL_BaseNoRankVision = _in.readI8();
			this.m.Vision = _in.readI8();
			this.m.EL_DamageHeadArmorReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageHeadArmorReduction = _in.readI32();
			this.m.EL_DamageRegularReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageRegularReduction = _in.readI32();
			if(this.m.EL_Level != -1)
			{
				this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			}
            this.m.Condition = _in.readF32();
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			this.Const.EL_Item_Other.EL_otherItemInit(this);
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
		o.EL_getDamageHeadArmorReduction <- function()
        {
			return this.m.EL_DamageHeadArmorReduction;
        }
		o.EL_setDamageHeadArmorReduction <- function( _EL_damageHeadArmorReduction )
        {
			this.m.EL_DamageHeadArmorReduction = _EL_damageHeadArmorReduction;
        }
		o.EL_getBaseWithRankDamageHeadArmorReduction <- function()
        {
			return this.m.EL_BaseWithRankDamageHeadArmorReduction;
        }
		o.EL_setBaseWithRankDamageHeadArmorReduction <- function( _EL_baseWithRankDamageHeadArmorReduction )
        {
			this.m.EL_BaseWithRankDamageHeadArmorReduction = _EL_baseWithRankDamageHeadArmorReduction;
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
			return this.Const.Items.HelmetUpgrades.COUNT;
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
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet[this.m.EL_RankLevel]);
				EL_entryListSort();
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

		o.EL_addRankLevel <- function()
		{
			++this.m.EL_RankLevel;
			EL_init();
			foreach(entry in this.m.EL_EntryList)
			{
				entry.EL_onUpgradeRank();
			}
			this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
			this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet [this.m.EL_RankLevel]);
			EL_entryListSort();
		}

        o.EL_upgradeLevel <- function()
        {
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				this.m.IsBought = false;
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
				this.m.IsBought = false;
				++this.m.EL_RankLevel;
				EL_init();
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onUpgradeRank();
				}
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet [this.m.EL_RankLevel]);
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
				this.m.IsBought = false;
				EL_init();
				this.m.EL_EntryList.clear();
				this.m.EL_RankPropertiesImproveIndex.clear();
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet[this.m.EL_RankLevel]);
				EL_updateLevelProperties();
				EL_entryListSort();
			}
        }

		o.EL_updateLevelProperties <- function() 
        {
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Helmet.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.EL_DamageRegularReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageRegularReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageRegularReduction * this.m.EL_CurrentLevel));
			this.m.EL_DamageHeadArmorReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageHeadArmorReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageHeadArmorReduction * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Helmet.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
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
			this.m.Condition = this.m.Condition > this.m.ConditionMax ? this.m.ConditionMax : this.m.Condition;
		}

        o.EL_init <- function()
	    {
			this.m.Vision = this.m.EL_BaseNoRankVision;
			this.m.EL_BaseWithRankDamageRegularReduction = 0;
			this.m.EL_BaseWithRankDamageHeadArmorReduction = 0;
			this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
			this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
        }

		o.EL_recordBaseNoRankProperties <- function()
	    {
			this.m.EL_BaseNoRankVision = this.m.Vision;
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
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getUpgradeRankEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				local rank_level = EL_getRankLevel() + 1;
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) 
										* (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Helmet.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else if(this.m.EL_RankLevel != this.Const.EL_Item.Type.Normal)
			{
				result[this.m.EL_RankLevel] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor
											 * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getRecraftEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				local rank_level = this.Math.min(this.m.EL_RankLevel, this.Const.EL_Item.Type.Epic);
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)))
			}
			return result;
		}
	});
    ::mods_hookExactClass("items/legend_helmets/legend_helmet", function ( o )
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
				text = "等阶: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]等级: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(5, {
					id = 23,
					type = "text",
					text = "等级: " + this.m.EL_Level
				});
			}
			local position = 7;
			if (this.getStaminaModifier() < 0)
			{
				++position;
			}
			if (this.getVision() != 0)
			{
				++position;
			}
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					++position;
				}
			}
			if (this.m.EL_EntryList.len() != 0)
			{
				local tool_tip_id = 61;
				for(local i = this.m.EL_EntryList.len() - 1; i >= 0; --i, ++tool_tip_id)
				{
					local tool_tip = this.m.EL_EntryList[i].getTooltip(tool_tip_id);
					if(tool_tip != null)
					{
						//result.push(tool_tip);
						result.insert(position, tool_tip);
					}
				}
				result.insert(position{
					id = 60,
					type = "text",
					text = "——————————————"
				});
			}
			if(this.EL_getDamageHeadArmorReduction())
			{
				result.insert(position, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "头盔耐久固定减伤: " + this.EL_getDamageHeadArmorReduction()
				});
			}
			if(this.EL_getDamageRegularReduction())
			{
				result.insert(position, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "血量固定减伤:  " + this.EL_getDamageRegularReduction()
				});
			}
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.push({
					id = 75,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]当前人物的战斗等级无法发挥装备全部性能。[/color]"
				});
			}
			return result;
		}
		
		local getAddedValue = o.getAddedValue;
		o.getAddedValue = function ( _function, _base, _all = false )
		{
			if(this.Const.EL_Helmet.EL_isDecorativeUpgrade(this))
			{
				return _base;
			}
			return getAddedValue(_function, _base, _all);
		}

		local onUpdateProperties = o.onUpdateProperties;
		o.onUpdateProperties = function ( _properties )
		{
			_properties.EL_DamageHeadArmorReduction += this.EL_getDamageHeadArmorReduction();
			_properties.DamageRegularReduction += this.EL_getDamageRegularReduction();
			onUpdateProperties(_properties);
		}
		
		o.removeArmor = function ( _a )
		{
			local delta = _a;

			for( local i = this.Const.Items.HelmetUpgrades.COUNT - 1; i >= 0; i = i )
			{
				if (this.m.Upgrades[i] != null)
				{
					delta = this.m.Upgrades[i].removeArmor(delta);

					if (delta <= 0)
					{
						break;
					}
				}

				i = --i;
			}

			if (delta > 0)
			{
				this.m.Condition = this.Math.maxf(0, this.m.Condition - delta);
			}
		}

		o.setUpgrade = function ( _upgrade )
		{
			if (_upgrade == null)
			{
				return true;
			}

			if (_upgrade != null && this.m.Blocked[_upgrade.getType()])
			{
				return false;
			}

			local slot = _upgrade.getType();

			if (slot == this.Const.Items.HelmetUpgrades.Vanity && this.m.Upgrades[this.Const.Items.HelmetUpgrades.Vanity] != null)
			{
				slot = this.Const.Items.HelmetUpgrades.ExtraVanity;
			}

			local oldIndex = "Assets" in ::World ? this.World.Assets.getStash().getItemByInstanceID(_upgrade.getInstanceID()) : null;

			if (oldIndex != null)
			{
				oldIndex = oldIndex.index;
			}

			local oldItem;

			if (this.m.Upgrades[slot] != null)
			{
				oldItem = this.removeUpgrade(slot);
			}

			this.m.Upgrades[slot] = _upgrade;
			_upgrade.setArmor(this);
			_upgrade.setVisible(true);

			if (this.m.Container != null)
			{
				_upgrade.onEquip();
				this.getContainer().getActor().getSkills().update();
			}

			local result = {
				item = null,
				index = oldIndex
			};

			if (oldItem != null && !oldItem.isDestroyedOnRemove())
			{
				result.item = oldItem;
			}

			this.updateAppearance();
			return result;
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
			// 		this.logInfo("22222222");
			// foreach( i, upgrade in this.m.Upgrades )
			// {
			// 	if (upgrade != null && i == this.Const.Items.HelmetUpgrades.ExtraVanity)
			// 	{
			// 		this.logInfo("11111111");
			// 		foreach(entry in upgrade.m.EL_EntryList)
			// 		{
			// 			this.EL_addEntry(entry);
			// 		}
			// 	}
			// }
		}

		local onUnequip = o.onUnequip;
		o.onUnequip = function ()
		{
			onUnequip();
			foreach( i, upgrade in this.m.Upgrades )
			{
				if (upgrade != null && i == this.Const.Items.HelmetUpgrades.ExtraVanity)
				{
					upgrade.onUnequip();
				}
			}
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
			this.helmet.EL_addRankLevel();
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
		o.EL_getDamageHeadArmorReduction <- function()
        {
			local result = this.m.EL_DamageHeadArmorReduction;
			foreach(upgrade in this.m.Upgrades)
			{
				if(upgrade != null)
				{
					result += upgrade.EL_getDamageHeadArmorReduction();
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
			for( local i = 0; i < this.Const.Items.HelmetUpgrades.COUNT; ++i )
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
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet[this.m.EL_RankLevel]);
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
			this.helmet.EL_upgradeLevel();
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
			this.helmet.EL_upgradeRank();
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
			this.helmet.EL_disassemble(_itemIndex);
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
			this.helmet.EL_recraft();
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
			this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Helmet.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			this.m.EL_DamageRegularReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageRegularReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageRegularReduction * this.m.EL_CurrentLevel));
			this.m.EL_DamageHeadArmorReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageHeadArmorReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageHeadArmorReduction * this.m.EL_CurrentLevel));
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Helmet.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
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
			this.m.Condition = this.m.Condition > this.m.ConditionMax ? this.m.ConditionMax : this.m.Condition;
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
			this.Const.EL_Item_Other.EL_otherItemInit(this);
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
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
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
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Helmet.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else if(this.m.EL_RankLevel != this.Const.EL_Item.Type.Normal)
			{
				result[this.m.EL_RankLevel] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
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
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
			}
			return result;
		}
	});
    ::mods_hookExactClass("items/legend_helmets/legend_helmet_upgrade", function ( o )
	{
		o.m.EL_BaseNoRankStaminaModifier <- 0;
        o.m.EL_BaseWithRankStaminaModifier <- 0;
		o.m.EL_BaseNoRankVision <-0;
		o.m.EL_DamageHeadArmorReduction <- 0;
		o.m.EL_BaseWithRankDamageHeadArmorReduction <- 0;
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
				text = "等阶: " + this.m.EL_RankLevel + "/" + this.EL_getRankLevelMax()
			});
			if(this.m.EL_CurrentLevel < this.m.EL_Level)
			{
				result.insert(4, {
					id = 23,
					type = "text",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]等级: " + this.m.EL_CurrentLevel + "/" + this.m.EL_Level + "[/color]"
				});
			}
			else
			{
				result.insert(4, {
					id = 23,
					type = "text",
					text = "等级: " + this.m.EL_Level
				});
			}
			local position = 7;
			if (this.getStaminaModifier() < 0)
			{
				++position;
			}
			if (this.getVision() != 0)
			{
				++position;
			}
			if(this.m.EL_DamageHeadArmorReduction)
			{
				result.insert(position, {
					id = 24,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "头盔耐久固定减伤: " + this.m.EL_DamageHeadArmorReduction
				});
			}
			if(this.m.EL_DamageRegularReduction)
			{
				result.insert(position, {
					id = 24,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "血量固定减伤:  " + this.m.EL_DamageRegularReduction
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
					if(tool_tip != null && entry.m.EL_CurrentLevel != 0)
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]当前人物的战斗等级无法发挥装备全部性能。[/color]"
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
			if (this.getVision() != 0)
			{
				_result.push({
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Vision " + ::Legends.S.colorize("" + ::Legends.S.getSign(this.getVision()) + this.Math.abs(this.getVision()), this.getVision())
				});
			}
			if(this.m.EL_EntryList.len() != 0)
			{
				local tool_tip_id = 66;
				foreach(entry in this.m.EL_EntryList)
				{
					local tool_tip = entry.getTooltip(tool_tip_id);
					if(tool_tip != null && entry.m.EL_CurrentLevel != 0)
					{
						_result.push(tool_tip);
						++tool_tip_id;
					}
				}
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
			_out.writeI8(this.m.EL_BaseNoRankVision);
			_out.writeI8(this.m.Vision);
			_out.writeI32(this.m.EL_DamageHeadArmorReduction);
			_out.writeI32(this.m.EL_BaseWithRankDamageHeadArmorReduction);
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
			this.m.EL_BaseNoRankVision = _in.readI8();
			this.m.Vision = _in.readI8();
			this.m.EL_DamageHeadArmorReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageHeadArmorReduction = _in.readI32();
			this.m.EL_DamageRegularReduction = _in.readI32();
			this.m.EL_BaseWithRankDamageRegularReduction = _in.readI32();
			if(this.m.EL_Level != -1)
			{
				this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Armor.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			}
            this.m.Condition = _in.readF32();
		}

		local onUse = o.onUse;
		o.onUse = function ( _actor, _item = null )
		{
			local armor = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head) : _item;

			if (armor != null && armor.EL_getArmorType() == this.Const.EL_Item.ArmorType.UnlayeredArmor)
			{
				return false;
			}
			return onUse(_actor, _item);
		}

		o.isAmountShown = function()
		{
			return true;
		}

		o.getAmountString = function()
		{
			this.Const.EL_Item_Other.EL_otherItemInit(this);
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
		o.EL_getDamageHeadArmorReduction <- function()
        {
			return this.m.EL_DamageHeadArmorReduction;
        }
		o.EL_setDamageHeadArmorReduction <- function( _EL_damageHeadArmorReduction )
        {
			this.m.EL_DamageHeadArmorReduction = _EL_damageHeadArmorReduction;
        }
		o.EL_getBaseWithRankDamageHeadArmorReduction <- function()
        {
			return this.m.EL_BaseWithRankDamageHeadArmorReduction;
        }
		o.EL_setBaseWithRankDamageHeadArmorReduction <- function( _EL_baseWithRankDamageHeadArmorReduction )
        {
			this.m.EL_BaseWithRankDamageHeadArmorReduction = _EL_baseWithRankDamageHeadArmorReduction;
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
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet[this.m.EL_RankLevel]);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;
			EL_updateLevelProperties();
			this.setCondition(this.Math.floor(this.getConditionMax() * percent));
        }

		o.EL_addRankLevel <- function()
		{
			++this.m.EL_RankLevel;
			EL_init();
			foreach(entry in this.m.EL_EntryList)
			{
				entry.EL_onUpgradeRank();
			}
			this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
			this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet [this.m.EL_RankLevel]);
		}

        o.EL_upgradeLevel <- function()
        {
			if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				this.m.IsBought = false;
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
				this.m.IsBought = false;
				++this.m.EL_RankLevel;
				EL_init();
				foreach(entry in this.m.EL_EntryList)
				{
					entry.EL_onUpgradeRank();
				}
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet [this.m.EL_RankLevel]);
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
				this.m.IsBought = false;
				EL_init();
				this.m.EL_EntryList.clear();
				this.m.EL_RankPropertiesImproveIndex.clear();
				this.Const.EL_Helmet.EL_updateRankLevelProperties(this);
				this.Const.EL_Helmet.EL_assignItemEntrys(this, this.Const.EL_Helmet.EL_Entry.EntryNum.NormalHelmet[this.m.EL_RankLevel]);
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function( _isItemUpdate = false )
        {
			if(this.Const.EL_Helmet.EL_isDecorativeUpgrade(this))
			{
				this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Helmet.EL_LevelFactor.Value * this.m.EL_Level));
				local entryNum = this.Const.EL_Helmet.EL_Entry.EntryNum.DecorativeHelmet[this.m.EL_RankLevel] * this.m.EL_CurrentLevel;
				for(local num = 0.0; num < this.m.EL_EntryList.len(); ++num)
				{
					this.m.EL_EntryList[num].EL_setCurrentLevel(entryNum - num);
				}
				this.m.ConditionMax = this.m.EL_BaseNoRankConditionMax;
				this.m.StaminaModifier = this.m.EL_BaseWithRankStaminaModifier;
				this.m.EL_DamageRegularReduction = 0;
				this.m.EL_DamageHeadArmorReduction = 0;
			}
			else
			{
				this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Helmet.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
				this.m.EL_DamageRegularReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageRegularReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageRegularReduction * this.m.EL_CurrentLevel));
				this.m.EL_DamageHeadArmorReduction = this.Math.ceil(this.m.EL_BaseWithRankDamageHeadArmorReduction * (1 + this.Const.EL_Helmet.EL_LevelFactor.DamageHeadArmorReduction * this.m.EL_CurrentLevel));
				this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Helmet.EL_LevelFactor.Value * this.m.EL_Level));
				this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
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
			this.m.Condition = this.m.Condition > this.m.ConditionMax ? this.m.ConditionMax : this.m.Condition;
		}

        o.EL_init <- function()
	    {
			this.m.Vision = this.m.EL_BaseNoRankVision;
			this.m.EL_BaseWithRankDamageRegularReduction = 0;
			this.m.EL_BaseWithRankDamageHeadArmorReduction = 0;
			this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
			this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
        }

		o.EL_recordBaseNoRankProperties <- function()
	    {
			this.m.EL_BaseNoRankVision = this.m.Vision;
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
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			}
			return result;
		}

		o.EL_getUpgradeRankEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(EL_getRankLevel() < EL_getRankLevelMax())
			{
				local rank_level = EL_getRankLevel() + 1;
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				if(rank_level == this.Const.EL_Item.Type.Legendary)
				{
					++result[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeRankFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
				}
				for(local index = 0; index < this.m.EL_Level; ++index)
				{
					result[this.Const.EL_Item.Type.Normal] += this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * index);
				}
				result[this.Const.EL_Item.Type.Normal] = this.Math.floor(this.Math.abs(result[this.Const.EL_Item.Type.Normal]) * this.Const.EL_Helmet.EL_EquipmentEssence.UpgradeLevelFactor 
													  * (this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) - this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel)));
			}
			else if(this.m.EL_StrengthenEntryNum < this.m.EL_EntryList.len())
			{
				result[this.Const.EL_Item.Type.Legendary] += this.Const.EL_Helmet.EL_EquipmentEssence.StrengthenEntryNum;
			}
			return result;
		}

		o.EL_getDisassembleEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
			result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, this.m.EL_RankLevel) * this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor
													* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.m.EL_Level)));
			if(this.m.EL_RankLevel == this.Const.EL_Item.Type.Legendary)
			{
				++result[this.Const.EL_Item.Type.Legendary];
			}
			else if(this.m.EL_RankLevel != this.Const.EL_Item.Type.Normal)
			{
				result[this.m.EL_RankLevel] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.DisassembleFactor * this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
			}
			return result;
		}

		o.EL_getRecraftEquipmentEssenceNum <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				local rank_level = this.Math.min(this.m.EL_RankLevel, this.Const.EL_Item.Type.Epic);
				local min_calculate_weight = this.Const.EL_Helmet.EL_EquipmentEssence.MinCalculateWeight;
				result[this.Const.EL_Item.Type.Normal] += this.Math.floor(this.Math.pow(this.Const.EL_Helmet.EL_EquipmentEssence.RankFactor, rank_level) * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
														* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier) * (1 + this.Const.EL_Helmet.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel)));
				result[rank_level] += this.Math.ceil(this.Const.EL_Helmet.EL_EquipmentEssence.SeniorEquipmentEssenceMult * this.Const.EL_Helmet.EL_EquipmentEssence.RecraftFactor 
									* this.Math.abs(this.Math.min(min_calculate_weight, this.m.EL_BaseNoRankStaminaModifier)));
			}
			return result;
		}
	});
});
