local gt = getroottable();

::mods_registerMod("el_weapon", 1, "el_weapon");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/weapons/weapon", function ( o )
	{
		o.m.EL_Vision <- 0;
		o.m.EL_AdditionalExplosionRange <- 0;

        o.m.EL_BaseNoRankShieldDamage <- 0;
		o.m.EL_BaseNoRankRegularDamage <- 0;
		o.m.EL_BaseNoRankRegularDamageMax <- 0;
		o.m.EL_BaseNoRankStaminaModifier <- 0;

        o.m.EL_BaseWithRankShieldDamage <- 0;
		o.m.EL_BaseWithRankRegularDamage <- 0;
		o.m.EL_BaseWithRankRegularDamageMax <- 0;
		o.m.EL_BaseWithRankStaminaModifier <- 0;

		o.m.EL_BaseNoRankAmmoMax <- 0;
		o.m.EL_BaseNoRankArmorDamageMult <- 0.0;
		o.m.EL_BaseNoRankDirectDamageAdd <- 0.0;
		o.m.EL_BaseNoRankChanceToHitHead <- 0;
		o.m.EL_BaseNoRankAdditionalAccuracy <- 0;
		o.m.EL_BaseNoRankFatigueOnSkillUse <- 0;
		o.m.EL_BaseNoRankRangeMax <- 0;

		o.m.EL_BaseWithRankVision <- 0;
		o.m.EL_BaseWithRankAmmoMax <- 0;
		o.m.EL_BaseWithRankArmorDamageMult <- 0.0;
		o.m.EL_BaseWithRankDirectDamageAdd <- 0.0;
		o.m.EL_BaseWithRankChanceToHitHead <- 0;
		o.m.EL_BaseWithRankAdditionalAccuracy <- 0;
		o.m.EL_BaseWithRankFatigueOnSkillUse <- 0;
		o.m.EL_BaseWithRankRangeMax <- 0;

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
			if (this.m.EL_Vision != 0)
			{
				result.push({
					id = 23,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Vision: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.EL_Vision + "[/color]"
				});
			}
			if (this.m.EL_AdditionalExplosionRange != 0)
			{
				result.push({
					id = 23,
					type = "text",
					text = "Additional explosion range: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.EL_AdditionalExplosionRange + "[/color]"
				});
			}
			if (this.m.EL_Entrylist.len() != 0)
			{
				result.push({
					id = 60,
					type = "text",
					text = "——————————————"
				});
				// for(local index = this.m.SkillPtrs.len()-1; index > 0; --index)
				// {
				// 	this.logInfo("33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333");
				// 	if(this.m.SkillPtrs[index].isType(this.Const.SkillType.EL_Entry))
				// 	{
				// 		this.logInfo("11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
				// 		result.push(this.m.SkillPtrs[index].getToolTip(41));
				// 	}
				// }
				//this.logInfo("11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
				local _id = 61;
				foreach(entry in this.m.EL_Entrylist)
				{
					result.push(entry.getTooltip(_id));
					++_id;
				}
			}
			// if(this.m.EL_RarityEntry != -1)
			// {
			// 	result.push({
			// 		id = 71,
			// 		type = "text",
			// 		text = "[color=" + this.Const.EL_UI.Color.LegendColour + "]" + this.Const.EL_Entry.EL_RarityEntryToolTip[entry.ID] +"[/color]"
			// 	});
			// }
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
			onUpdateProperties(_properties);
			_properties.Vision += this.m.EL_Vision;
			//local currentProperties = getContainer().getActor().getCurrentProperties();
			//_properties.Hitpoints += _properties.Hitpoints * 0.2;
			//_properties.Bravery += 20;
			// for(local index = this.m.SkillPtrs.len()-1; index > 0; --index)
			// {
			// 	this.m.SkillPtrs[index].onUpdateProperties(_properties);
			// }
		}

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			// local combatLevel = this.getContainer().getActor().EL_getCombatLevel();

			// if( EL_CombatLevel < this.m.EL_Level )
			// {
			// 	this.m.EL_CurrentLevel = combatLevel;
			// 	EL_updateLevelProperties(combatLevel);
			// 	this.m.Condition = this.m.ConditionMax;
			// 	getTooltip();
			// }

			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check"));
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

			_out.writeF32(this.m.ArmorDamageMult);
			_out.writeU8(this.m.ChanceToHitHead);
			_out.writeI16(this.m.AdditionalAccuracy);
			_out.writeF32(this.m.DirectDamageAdd);
			_out.writeI16(this.m.FatigueOnSkillUse);
			_out.writeU16(this.m.AmmoMax);
			_out.writeI32(this.m.EL_Vision);
			_out.writeI32(this.m.EL_AdditionalExplosionRange);

			_out.writeI32(this.m.EL_BaseNoRankShieldDamage);
			_out.writeI32(this.m.EL_BaseNoRankRegularDamage);
			_out.writeI32(this.m.EL_BaseNoRankRegularDamageMax);
            _out.writeI32(this.m.EL_BaseNoRankStaminaModifier);

			_out.writeI32(this.m.EL_BaseWithRankShieldDamage);
			_out.writeI32(this.m.EL_BaseWithRankRegularDamage);
			_out.writeI32(this.m.EL_BaseWithRankRegularDamageMax);
            _out.writeI32(this.m.EL_BaseWithRankStaminaModifier);

			_out.writeI32(this.m.EL_BaseNoRankAmmoMax);
			_out.writeF32(this.m.EL_BaseNoRankArmorDamageMult);
            _out.writeF32(this.m.EL_BaseNoRankDirectDamageAdd);
			_out.writeI32(this.m.EL_BaseNoRankChanceToHitHead);
			_out.writeI32(this.m.EL_BaseNoRankAdditionalAccuracy);
			_out.writeI32(this.m.EL_BaseNoRankFatigueOnSkillUse);
			_out.writeI32(this.m.EL_BaseNoRankRangeMax);

			_out.writeI32(this.m.EL_BaseWithRankVision);
			_out.writeI32(this.m.EL_BaseWithRankAmmoMax);
			_out.writeF32(this.m.EL_BaseWithRankArmorDamageMult);
            _out.writeF32(this.m.EL_BaseWithRankDirectDamageAdd);
			_out.writeI32(this.m.EL_BaseWithRankChanceToHitHead);
			_out.writeI32(this.m.EL_BaseWithRankAdditionalAccuracy);
			_out.writeI32(this.m.EL_BaseWithRankFatigueOnSkillUse);
			_out.writeI32(this.m.EL_BaseWithRankRangeMax);
			_out.writeF32(this.m.Condition);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);

			local EL_EntrylistLen = _in.readU8();
			for( local i = 0; i != EL_EntrylistLen; ++i )
			{
				local entry = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
				entry.onDeserialize(_in);
				this.m.EL_Entrylist.push(entry);
			}

			this.m.ArmorDamageMult = _in.readF32();
			this.m.ChanceToHitHead = _in.readU8();
			this.m.AdditionalAccuracy = _in.readI16();
			this.m.DirectDamageAdd = _in.readF32();
			this.m.FatigueOnSkillUse = _in.readI16();
			this.m.AmmoMax = _in.readU16();
			this.m.EL_Vision = _in.readI32();
			this.m.EL_AdditionalExplosionRange = _in.readI32();

			this.m.EL_BaseNoRankShieldDamage = _in.readI32();
			this.m.EL_BaseNoRankRegularDamage = _in.readI32();
			this.m.EL_BaseNoRankRegularDamageMax = _in.readI32();
            this.m.EL_BaseNoRankStaminaModifier = _in.readI32();
			this.m.EL_BaseWithRankShieldDamage = _in.readI32();
			this.m.EL_BaseWithRankRegularDamage = _in.readI32();
			this.m.EL_BaseWithRankRegularDamageMax = _in.readI32();
            this.m.EL_BaseWithRankStaminaModifier = _in.readI32();

			this.m.EL_BaseNoRankAmmoMax = _in.readI32();
			this.m.EL_BaseNoRankArmorDamageMult = _in.readF32();
            this.m.EL_BaseNoRankDirectDamageAdd = _in.readF32();
			this.m.EL_BaseNoRankChanceToHitHead = _in.readI32();
			this.m.EL_BaseNoRankAdditionalAccuracy = _in.readI32();
			this.m.EL_BaseNoRankFatigueOnSkillUse = _in.readI32();
			this.m.EL_BaseNoRankRangeMax = _in.readI32();

			this.m.EL_BaseWithRankVision = _in.readI32();
			this.m.EL_BaseWithRankAmmoMax = _in.readI32();
			this.m.EL_BaseWithRankArmorDamageMult = _in.readF32();
            this.m.EL_BaseWithRankDirectDamageAdd = _in.readF32();
			this.m.EL_BaseWithRankChanceToHitHead = _in.readI32();
			this.m.EL_BaseWithRankAdditionalAccuracy = _in.readI32();
			this.m.EL_BaseWithRankFatigueOnSkillUse = _in.readI32();
			this.m.EL_BaseWithRankRangeMax = _in.readI32();
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

		o.EL_getBaseNoRankShieldDamage <- function()
        {
			return this.m.EL_BaseNoRankShieldDamage;
        }
		o.EL_setBaseNoRankShieldDamage <- function( _EL_baseNoRankShieldDamage )
        {
			this.m.EL_BaseNoRankShieldDamage = _EL_baseNoRankShieldDamage;
        }
		o.EL_getBaseNoRankRegularDamage <- function()
        {
			return this.m.EL_BaseNoRankRegularDamage;
        }
		o.EL_setBaseNoRankRegularDamage <- function( _EL_baseNoRankRegularDamage )
        {
			this.m.EL_BaseNoRankRegularDamage = _EL_baseNoRankRegularDamage;
        }
		o.EL_getBaseNoRankRegularDamageMax <- function()
        {
			return this.m.EL_BaseNoRankRegularDamageMax;
        }
		o.EL_setBaseNoRankRegularDamageMax <- function( _EL_baseNoRankRegularDamageMax )
        {
			this.m.EL_BaseNoRankRegularDamageMax = _EL_baseNoRankRegularDamageMax;
        }
		o.EL_getBaseNoRankStaminaModifier <- function()
        {
			return this.m.EL_BaseNoRankStaminaModifier;
        }
		o.EL_setBaseNoRankStaminaModifier <- function( _EL_baseNoRankStaminaModifier )
        {
			this.m.EL_BaseNoRankStaminaModifier = _EL_baseNoRankStaminaModifier;
        }
		o.EL_getBaseWithRankShieldDamage <- function()
        {
			return this.m.EL_BaseWithRankShieldDamage;
        }
		o.EL_setBaseWithRankShieldDamage <- function( _EL_baseWithRankShieldDamage )
        {
			this.m.EL_BaseWithRankShieldDamage = _EL_baseWithRankShieldDamage;
        }
		o.EL_getBaseWithRankRegularDamage <- function()
        {
			return this.m.EL_BaseWithRankRegularDamage;
        }
		o.EL_setBaseWithRankRegularDamage <- function( _EL_baseWithRankRegularDamage )
        {
			this.m.EL_BaseWithRankRegularDamage = _EL_baseWithRankRegularDamage;
        }
		o.EL_getBaseWithRankRegularDamageMax <- function()
        {
			return this.m.EL_BaseWithRankRegularDamageMax;
        }
		o.EL_setBaseWithRankRegularDamageMax <- function( _EL_baseWithRankRegularDamageMax )
        {
			this.m.EL_BaseWithRankRegularDamageMax = _EL_baseWithRankRegularDamageMax;
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

			local percent = 0;
			if(this.m.ConditionMax != 0)
			{
				percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			}
			if(this.m.EL_Level == -1)
			{
				this.m.EL_RankLevel += _EL_rankLevel;
				this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
				local entryCount = (this.isItemType(this.Const.Items.ItemType.OneHanded)) ? this.Const.EL_Weapon.EL_Entry.EntryNum.OneHanded[this.m.EL_RankLevel] : this.Const.EL_Weapon.EL_Entry.EntryNum.TwoHanded[this.m.EL_RankLevel];
        		EL_init();
				EL_updateRankLevelProperties();
				this.Const.EL_Weapon.EL_assignItemEntrys(this, entryCount);
			}
			this.m.EL_CurrentLevel = this.m.EL_Level;

			EL_updateLevelProperties();
			if(this.m.ConditionMax != 0)
			{
				this.m.Condition = this.m.ConditionMax * percent;
			}
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

		o.EL_disassemble <- function()
		{
			local stash = this.World.Assets.getStash();
			stash.remove(this);
		}

		o.EL_recraft <- function()
        {
			if(this.m.EL_RankLevel && this.m.EL_Level != -1)
			{
				this.m.EL_Vision = 0;
				this.m.EL_AdditionalExplosionRange = 0;
				this.m.ArmorDamageMult = this.m.EL_BaseNoRankArmorDamageMult;
				this.m.DirectDamageAdd = this.m.EL_BaseNoRankDirectDamageAdd;
				this.m.ChanceToHitHead = this.m.EL_BaseNoRankChanceToHitHead;
				this.m.AmmoMax = this.m.EL_BaseNoRankAmmoMax;
				this.m.AdditionalAccuracy = this.m.EL_BaseNoRankAdditionalAccuracy;
				this.m.FatigueOnSkillUse = this.m.EL_BaseNoRankFatigueOnSkillUse;
				this.m.RangeMax = this.m.EL_BaseNoRankRangeMax;
				this.m.EL_BaseWithRankConditionMax = this.m.EL_BaseNoRankConditionMax;
				this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue;
				this.m.EL_BaseWithRankRegularDamage = this.m.EL_BaseNoRankRegularDamage;
			    this.m.EL_BaseWithRankRegularDamageMax = this.m.EL_BaseNoRankRegularDamageMax;
		  	    this.m.EL_BaseWithRankStaminaModifier = this.m.EL_BaseNoRankStaminaModifier;
				this.m.EL_BaseWithRankShieldDamage = this.m.EL_BaseNoRankShieldDamage;
				this.m.EL_Entrylist.clear();
				local entryCount = (this.isItemType(this.Const.Items.ItemType.OneHanded)) ? this.Const.EL_Weapon.EL_Entry.EntryNum.OneHanded[this.m.EL_RankLevel] : this.Const.EL_Weapon.EL_Entry.EntryNum.TwoHanded[this.m.EL_RankLevel];
        		this.Const.EL_Weapon.EL_assignItemEntrys(this, entryCount);
        	    EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}
        }

		o.EL_updateLevelProperties <- function()
        {
			if(this.m.ConditionMax != 1)
			{
				this.m.ConditionMax = this.Math.ceil(this.m.EL_BaseWithRankConditionMax * (1 + this.Const.EL_Weapon.EL_LevelFactor.Condition * this.m.EL_CurrentLevel));
			}
			this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Weapon.EL_LevelFactor.Value * this.m.EL_Level));
			this.m.RegularDamage = this.Math.ceil(this.m.EL_BaseWithRankRegularDamage * (1 + this.Const.EL_Weapon.EL_LevelFactor.RegularDamage * this.m.EL_CurrentLevel));
			this.m.RegularDamageMax = this.Math.ceil(this.m.EL_BaseWithRankRegularDamageMax * (1 + this.Const.EL_Weapon.EL_LevelFactor.RegularDamageMax * this.m.EL_CurrentLevel));
			this.m.StaminaModifier = this.Math.floor(this.m.EL_BaseWithRankStaminaModifier * (1 + this.Const.EL_Weapon.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			this.m.ShieldDamage = this.Math.ceil(this.m.EL_BaseWithRankShieldDamage * (1 + this.Const.EL_Weapon.EL_LevelFactor.ShieldDamage * this.m.EL_CurrentLevel));
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
			this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * gt.Const.EL_Weapon.EL_RankValue[this.m.EL_RankLevel];
			local isReduceWeight = this.Math.rand(0, 1);
			if(this.m.EL_RankLevel >= 1 && this.m.EL_RankLevel != 4)
			{
				local available = [];
				local weightList = [];
				local weightSum = 0;
				foreach	(func in gt.Const.EL_Weapon.EL_RankPropertiesInitFunctions)
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
				foreach	(func in gt.Const.EL_Weapon.EL_RankPropertiesInitFunctions)
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
		    this.m.EL_BaseNoRankRegularDamage = this.m.RegularDamage;
		    this.m.EL_BaseNoRankRegularDamageMax = this.m.RegularDamageMax;
		    this.m.EL_BaseNoRankStaminaModifier = this.m.StaminaModifier;
			this.m.EL_BaseNoRankShieldDamage = this.m.ShieldDamage;

			this.m.EL_BaseNoRankArmorDamageMult = this.m.ArmorDamageMult;
			this.m.EL_BaseNoRankDirectDamageAdd = this.m.DirectDamageAdd;
			this.m.EL_BaseNoRankChanceToHitHead = this.m.ChanceToHitHead;
			this.m.EL_BaseNoRankAdditionalAccuracy = this.m.AdditionalAccuracy;
			this.m.EL_BaseNoRankFatigueOnSkillUse = this.m.FatigueOnSkillUse;
			this.m.EL_BaseNoRankRangeMax = this.m.RangeMax;
			this.m.EL_BaseNoRankAmmoMax = this.m.AmmoMax;

			this.m.EL_BaseWithRankConditionMax = this.m.ConditionMax;
			this.m.EL_BaseWithRankValue = this.m.Value;
			this.m.EL_BaseWithRankRegularDamage = this.m.RegularDamage;
		    this.m.EL_BaseWithRankRegularDamageMax = this.m.RegularDamageMax;
		    this.m.EL_BaseWithRankStaminaModifier = this.m.StaminaModifier;
			this.m.EL_BaseWithRankShieldDamage = this.m.ShieldDamage;

			this.m.EL_BaseWithRankArmorDamageMult = this.m.ArmorDamageMult;
            this.m.EL_BaseWithRankDirectDamageAdd = this.m.DirectDamageAdd;
			this.m.EL_BaseWithRankChanceToHitHead = this.m.ChanceToHitHead;
			this.m.EL_BaseWithRankAdditionalAccuracy = this.m.AdditionalAccuracy;
			this.m.EL_BaseWithRankFatigueOnSkillUse = this.m.FatigueOnSkillUse;
			this.m.EL_BaseWithRankRangeMax = this.m.RangeMax;
			this.m.EL_BaseWithRankAmmoMax = this.m.AmmoMax;
        }

		o.EL_getUpgradeEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Weapon.EL_Essence.SlotFactor * this.Const.EL_Weapon.EL_Essence.UpgradeFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Weapon.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			return result;
		}

		o.EL_getDisassembleEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			result[this.m.EL_RankLevel] += this.Const.EL_Weapon.EL_Essence.SlotFactor * this.Const.EL_Weapon.EL_Essence.DisassembleFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Weapon.EL_LevelFactor.StaminaModifier * this.m.EL_Level));
			return result;
		}

		o.EL_getRecraftEssence <- function()
		{
			local result = [0, 0, 0, 0, 0];
			if(this.m.EL_RankLevel)
			{
				result[this.m.EL_RankLevel] += this.Const.EL_Weapon.EL_Essence.SlotFactor * this.Const.EL_Weapon.EL_Essence.RecraftFactor * this.Math.floor(-1 * this.Math.min(-1, this.m.EL_BaseWithRankStaminaModifier) * (1 + this.Const.EL_Weapon.EL_LevelFactor.StaminaModifier * this.World.Assets.m.EL_WorldLevel));
			}
			return result;
		}
	});

	::mods_hookExactClass("skills/actives/fire_handgonne_skill", function(o) {
        //local getAffectedTiles = o.getAffectedTiles;
		o.getAffectedTiles = function( _targetTile )
		{
			local ret = [
				_targetTile
			];
			local ownTile = this.m.Container.getActor().getTile();
			local dir = ownTile.getDirectionTo(_targetTile);
			local dist = ownTile.getDistanceTo(_targetTile);
			local isTakingAim = this.getContainer().hasSkill("effects.ptr_take_aim");

			if (_targetTile.hasNextTile(dir))
			{
				local forwardTile = _targetTile.getNextTile(dir);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}

				if (dist < 3 && isTakingAim)
				{
					if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
				}
                for( local count = 0; count < this.getItem().m.EL_AdditionalExplosionRange; ++count )
                {
                    if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
                }
			}

			local left = dir - 1 < 0 ? 5 : dir - 1;

			if (_targetTile.hasNextTile(left))
			{
				local forwardTile = _targetTile.getNextTile(left);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}

				if (forwardTile.hasNextTile(dir))
				{
					forwardTile = forwardTile.getNextTile(dir);

					if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
					{
						ret.push(forwardTile);
					}
				}

				if (dist < 3 && isTakingAim)
				{
					if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
				}
                for( local count = 0; count < this.getItem().m.EL_AdditionalExplosionRange; ++count )
                {
                    if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
                }
			}

			local right = dir + 1 > 5 ? 0 : dir + 1;

			if (_targetTile.hasNextTile(right))
			{
				local forwardTile = _targetTile.getNextTile(right);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}

				if (forwardTile.hasNextTile(dir))
				{
					forwardTile = forwardTile.getNextTile(dir);

					if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
					{
						ret.push(forwardTile);
					}
				}

				if (dist < 3 && isTakingAim)
				{
					if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
				}
                for( local count = 0; count < this.getItem().m.EL_AdditionalExplosionRange; ++count )
                {
                    if (forwardTile.hasNextTile(dir))
					{
						forwardTile = forwardTile.getNextTile(dir);

						if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(forwardTile);
						}
					}
                }
			}

			return ret;
		}
        o.getTooltip = function()
	    {
	    	local ret = this.getRangedTooltip(this.getDefaultTooltip());
	    	ret.push({
    			id = 10,
    			type = "text",
    			icon = "ui/icons/items.png",
    			text = "Can hit up to " + (3 * (2 + this.getItem().m.EL_AdditionalExplosionRange)) + " targets"
    		});
    		local ammo = this.getAmmo();
	    	if (ammo > 0)
	    	{
	    		ret.push({
		    		id = 8,
	    			type = "text",
	       			icon = "ui/icons/ammo.png",
	    			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] shots left"
	    		});
	    	}
	    	else
	    	{
	    		ret.push({
	    			id = 8,
	    			type = "text",
	    			icon = "ui/tooltips/warning.png",
	    			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Needs a non-empty powder bag equipped[/color]"
	    		});
	    	}

	    	if (!this.getItem().isLoaded())
	    	{
	    		ret.push({
	    			id = 9,
	    			type = "text",
	    			icon = "ui/tooltips/warning.png",
	    			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Must be reloaded before firing again[/color]"
	    		});
	    	}
    		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
    		{
    			ret.push({
    				id = 9,
    				type = "text",
	    			icon = "ui/tooltips/warning.png",
	    			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
	    		});
	    	}
	    	return ret;
    	}
	});

    ::mods_hookExactClass("items/ammo/ammo", function ( o )
	{
		local consumeAmmo = o.consumeAmmo;
		o.consumeAmmo = function()
		{
			local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if(item != null)
			{
				foreach(entry in this.m.EL_Entrylist)
				{
					if(entry.getID() == "weapon_entry.el_save_ammo" && this.Math.rand(1, 1000) < this.m.EL_SaveAmmoChance * 10)
					{
						if (skills.hasSkill("entry.el_pursuit_of_wind") || skills.hasSkill("entry.el_eye_of_death") || skills.hasSkill("entry.el_gunfire_licks_the_heavens") || skills.hasSkill("entry.el_infinite_penetration"))
						{
						}
						else
						{
							consumeAmmo();
						}
						return;
					}
				}
			}

		}
	});
});
