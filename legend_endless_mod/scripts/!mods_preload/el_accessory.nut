local gt = getroottable();

::mods_registerMod("EL_accessory", 1, "EL_accessory");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("items/accessory/accessory", function ( o )
	{
		o.m.EL_RarityEntry <- null;//this.new(this.Const.EL_Accessory.EL_RarityEntry.Pool.Entrys[1].Scripts);//

		local onEquip = o.onEquip;
		o.onEquip = function ()
		{
			onEquip();
			this.addSkill(this.new("scripts/skills/el_items/el_item_level_check_skill"));
			foreach(entry in this.m.EL_Entrylist)
			{
				this.EL_addEntry(entry);
			}
			if(this.m.EL_RarityEntry != null && this.getContainer().getActor().getFaction() == this.Const.Faction.Player)
			{
				this.logInfo("Rarity entry is equip, name = " + this.m.EL_RarityEntry.m.Name);
				this.addSkill(this.m.EL_RarityEntry);
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
			if(this.m.EL_RarityEntry != null)
			{
				_out.writeU8(1);
				_out.writeI32(this.m.EL_RarityEntry.ClassNameHash);
				this.m.EL_RarityEntry.onSerialize(_out);
			}
			else
			{
				_out.writeU8(0);
			}
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
			local has_rarity_entry = _in.readU8();
			//this.logInfo(has_rarity_entry);
			if(has_rarity_entry)
			{
				this.m.EL_RarityEntry = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
				this.m.EL_RarityEntry.onDeserialize(_in);
			}
			EL_updateLevelProperties();
		}

		o.EL_addRarityEntry <- function ( _EL_rarityEntry )
		{
		}

		o.EL_getRankLevel <- function()
		{
			return 0;
		}
	});

	for(local i = 0; i < this.Const.EL_Accessory.EL_ValidAccessory.len(); ++i) {
		::mods_hookExactClass("items/" + this.Const.EL_Accessory.EL_ValidAccessory[i], function ( o )
		{
			local getTooltip = o.getTooltip;
			o.getTooltip = function ()
			{
				local result = getTooltip();
				if(this.m.EL_RarityEntry != null)
				{
					result[0] = {
						id = 1,
						type = "title",
						text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary] +"]" + this.getName() + "[/color]"
					};
				}
				else if(this.m.EL_RankLevel == 0)
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
				if (this.m.EL_Level > 0 || this.m.EL_RarityEntry != null)
				{
					result.push({
						id = 60,
						type = "text",
						text = "——————————————"
					});
					if(this.m.EL_RarityEntry != null)
					{
						result.push({
							id = 61,
							type = "text",
							text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.m.EL_RarityEntry.getName() + "[/color]"
						});
					}
					local _id = 62;
					foreach(entry in this.m.EL_Entrylist)
					{
						if(entry.m.EL_CurrentLevel != 0)
						{
							result.push(entry.getTooltip(_id));
							++_id;
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

			o.isAmountShown <- function()
			{
				return true;
			}

			o.getAmountString <- function()
			{
				return "lv" + this.m.EL_Level;
			}

			o.getAmountColor <- function()
			{
				if(this.m.EL_RarityEntry == null)
				{
					return this.Const.EL_Item.Colour[this.m.EL_RankLevel];
				}
				else
				{
					return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
				}
			}
			//EL_additionalRarityChance
			o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
			{
				if(this.m.EL_Level == -1)
				{
					EL_init();
					this.m.EL_RankLevel = this.Math.min(this.m.EL_RankLevel + _EL_rankLevel, 3);
					this.m.EL_Level = this.Math.min(this.Const.EL_Item.MaxLevel, EL_level);
					this.m.EL_CurrentLevel = this.m.EL_Level;
					EL_updateRankLevelProperties();
					this.Const.EL_Accessory.EL_assignItemRarityEntry(this, EL_additionalRarityChance);
					this.Const.EL_Accessory.EL_assignItemEntrys(this, this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[this.m.EL_RankLevel] * this.m.EL_Level);
					EL_updateLevelProperties();
				}
				this.m.EL_CurrentLevel = this.m.EL_Level;
			}

			o.EL_upgrade <- function()
			{
				if(this.m.EL_Level < this.Const.EL_Item.MaxLevel)
				{
					this.m.EL_Level += 1;
					this.m.EL_CurrentLevel += 1;
					if(this.m.EL_Level == 1)
					{
						this.Const.EL_Accessory.EL_addItemEntry(this);
					}
					else if(this.m.EL_Entrylist[this.m.EL_Entrylist.len() - 1].m.EL_CurrentLevel != 1.0)
					{
						this.m.EL_Entrylist[this.m.EL_Entrylist.len() - 1].EL_upgrade(this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[this.m.EL_RankLevel]);
					}
					else
					{
						this.Const.EL_Accessory.EL_addItemEntry(this);
					}
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
				if(this.m.EL_RarityEntry == null)
				{
					this.Const.EL_Accessory.EL_assignItemRarityEntry(this);
				}
				this.m.EL_Entrylist.clear();
				this.Const.EL_Accessory.EL_assignItemEntrys(this, this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[this.m.EL_RankLevel] * this.m.EL_Level);
				EL_updateRankLevelProperties();
				EL_updateLevelProperties();
			}

			o.EL_updateLevelProperties <- function()
			{
				this.m.Value = this.Math.ceil(this.m.EL_BaseWithRankValue * (1 + this.Const.EL_Accessory.EL_LevelFactor.Value * this.m.EL_Level));
				local entryNum = this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[this.m.EL_RankLevel] * this.m.EL_CurrentLevel;
				for(local num = 0.0; num < this.m.EL_Entrylist.len(); ++num)
				{
					this.m.EL_Entrylist[num].EL_setCurrentLevel(entryNum - num);
				}
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
				if(this.m.EL_RarityEntry != null)
				{
					this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * this.Const.EL_Accessory.EL_RankValue[this.Const.EL_Item.Type.Legendary];
				}
				else
				{
					this.m.EL_BaseWithRankValue = this.m.EL_BaseNoRankValue * this.Const.EL_Accessory.EL_RankValue[this.m.EL_RankLevel];
				}
			}

			o.EL_init <- function()
			{
				this.m.EL_BaseNoRankValue = this.m.Value;
				this.m.EL_BaseWithRankValue = this.m.Value;
			}

			o.isDroppedAsLoot <- function()
			{
				if (!this.item.isDroppedAsLoot())
				{
					return false;
				}
				if (this.m.EL_RarityEntry != null || this.Math.rand(1, 100) <= this.Const.EL_Accessory.EL_DroppedChance[this.m.EL_RankLevel])
				{
					return true;
				}

				return false;
			}

			o.EL_addRarityEntry <- function ( _EL_rarityEntry )
			{
				this.m.EL_RarityEntry = _EL_rarityEntry;
			}

			o.EL_getRankLevel <- function()
			{
				return (this.m.EL_RarityEntry == null) ? this.m.EL_RankLevel : this.Const.EL_Item.Type.Legendary;
			}

			o.EL_getUpgradeEssence <- function()
			{
				local result = [0, 0, 0, 0, 0];
				result[this.m.EL_RankLevel] += this.Math.round(this.Const.EL_Accessory.EL_Essence.SlotFactor * this.Const.EL_Accessory.EL_Essence.UpgradeFactor * this.Math.pow((1 + this.Const.EL_Accessory.EL_Essence.LevelFactor * this.m.EL_Level), this.Const.EL_Accessory.EL_Essence.PowFactor));
				return result;
			}

			o.EL_getDisassembleEssence <- function()
			{
				local result = [0, 0, 0, 0, 0];
				result[this.m.EL_RankLevel] += this.Math.round(this.Const.EL_Accessory.EL_Essence.SlotFactor * this.Const.EL_Accessory.EL_Essence.DisassembleFactor * this.Math.pow((1 + this.Const.EL_Accessory.EL_Essence.LevelFactor * this.m.EL_Level), this.Const.EL_Accessory.EL_Essence.PowFactor));
				return result;
			}

			o.EL_getRecraftEssence <- function()
			{
				local result = [0, 0, 0, 0, 0];
				result[this.m.EL_RankLevel] += this.Math.round(this.Const.EL_Accessory.EL_Essence.SlotFactor * this.Const.EL_Accessory.EL_Essence.RecraftFactor * this.Math.pow((1 + this.Const.EL_Accessory.EL_Essence.LevelFactor * this.World.Assets.m.EL_WorldLevel), this.Const.EL_Accessory.EL_Essence.PowFactor));
				return result;
			}
		});
	}

	for(local i = 0; i < this.Const.EL_Accessory.EL_SeniorAccessoryList.len(); ++i) {
		::mods_hookExactClass("items/" + this.Const.EL_Accessory.EL_SeniorAccessoryList[i], function ( o )
		{
			o.m.EL_RankLevel <- 1;
		});
	}

	::mods_hookExactClass("items/accessory/oathtaker_skull_01_item", function ( o )
	{
		local create = o.create;
        o.create = function()
        {
            create();
            EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, 0);
        }
	});

	::mods_hookExactClass("items/accessory/oathtaker_skull_02_item", function ( o )
	{
		local create = o.create;
        o.create = function()
        {
            create();
            EL_generateByRankAndLevel(this.Const.EL_Item.Type.Epic, 0);
        }
	});

	::mods_hookExactClass("items/accessory/sergeant_badge_item", function ( o )
	{
		o.getBuyPrice = function()
		{
			if (this.isSold())
			{
				return this.getSellPrice();
			}

			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
			{
				return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getBuyPriceMult() * this.getPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()]));
			}
			else
			{
				return this.Math.ceil(this.getValue() * this.getPriceMult());
			}
		}
	});
});
