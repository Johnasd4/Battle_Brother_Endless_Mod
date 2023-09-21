local gt = getroottable();

::mods_registerMod("el_item", 1, "el_item");
::mods_queue(null, "el_world", function ()
{
    ::mods_hookClass("items/item", function(o) {
		while(!("onEquip" in o)) o = o[o.SuperName];
		o.m.EL_Entrylist <- [];
		o.m.EL_Level <- -1;
		o.m.EL_CurrentLevel <- -1;
		o.m.EL_RankLevel <- 0;
		o.m.EL_BaseNoRankConditionMax <- 0;
		o.m.EL_BaseWithRankConditionMax <- 0;
		o.m.EL_BaseNoRankValue <- 0;
		o.m.EL_BaseWithRankValue <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function( _out )
		{
			onSerialize(_out);
			_out.writeI32(this.m.EL_Level);
			_out.writeI32(this.m.EL_CurrentLevel);
			_out.writeI32(this.m.EL_RankLevel);
			_out.writeI32(this.m.EL_BaseNoRankConditionMax);
			_out.writeI32(this.m.EL_BaseWithRankConditionMax);
			_out.writeI32(this.m.EL_BaseNoRankValue);
			_out.writeI32(this.m.EL_BaseWithRankValue);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function( _in )
		{
			onDeserialize(_in);
			this.m.EL_Level = _in.readI32();
			this.m.EL_CurrentLevel = _in.readI32();
			this.m.EL_RankLevel = _in.readI32();
			this.m.EL_BaseNoRankConditionMax = _in.readI32();
			this.m.EL_BaseWithRankConditionMax = _in.readI32();
			this.m.EL_BaseNoRankValue = _in.readI32();
			this.m.EL_BaseWithRankValue = _in.readI32();
		}

		o.EL_addEntryList <- function( _entry )
		{
			_entry.setItem(this);
			this.m.EL_Entrylist.push(_entry);
		}

		o.EL_addEntry <- function( _entry )
		{
			this.m.SkillPtrs.push(_entry);
			this.getContainer().getActor().getSkills().add(_entry);
		}

		o.EL_getBaseNoRankConditionMax <- function()
		{
			return this.m.EL_BaseNoRankConditionMax;
		}

		o.EL_setBaseNoRankConditionMax <- function( EL_baseNoRankConditionMax )
		{
			this.m.EL_BaseNoRankConditionMax = EL_baseNoRankConditionMax;
		}

		o.EL_getBaseWithRankConditionMax <- function()
		{
			return this.m.EL_BaseWithRankConditionMax;
		}

		o.EL_setBaseWithRankConditionMax <- function( EL_baseWithRankConditionMax )
		{
			this.m.EL_BaseWithRankConditionMax = EL_baseWithRankConditionMax;
		}

		o.EL_getBaseNoRankValue <- function()
		{
			return this.m.EL_BaseNoRankValue;
		}

		o.EL_setBaseNoRankValue <- function( EL_BaseNoRankValue )
		{
			this.m.EL_BaseNoRankValue = EL_BaseNoRankValue;
		}

		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return 0;
		}

		o.EL_getLevel <- function()
		{
			return this.m.EL_Level;
		}

		o.EL_setLevel <- function( EL_level )
		{
			this.m.EL_Level = EL_level;
			this.m.EL_CurrentLevel = EL_level;
			EL_updateLevelProperties();
		}

		o.EL_getCurrentLevel <- function()
		{
			return this.m.EL_CurrentLevel;
		}

		o.EL_setCurrentLevel <- function( EL_level )
		{
			this.m.EL_CurrentLevel = EL_level;
			local percent = (this.m.Condition * 1.0)/ this.m.ConditionMax;
			EL_updateLevelProperties();
			this.m.Condition = this.Math.round(this.m.ConditionMax * percent);
		}

		o.EL_getRankLevel <- function()
		{
			return this.m.EL_RankLevel;
		}

		o.EL_setRankLevel <- function( EL_rankLevel )
		{
			this.m.EL_RankLevel = EL_rankLevel;
			EL_recast();
		}

		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return 0;
		}

		o.EL_getLevelString <- function()
		{
			return "";
		}

		o.EL_getLevelStringColour <- function()
		{
			return "#ffffff";
		}

		o.EL_generateByRankAndLevel <- function( EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
		{
		}

		o.EL_updateLevelProperties <- function()
		{
		}

		o.EL_updateRankLevelProperties <- function()
		{
		}

		o.EL_init <- function()
		{
		}

		o.EL_upgrade <- function()
		{
		}

		o.EL_disassemble <- function()
		{
		}

		o.EL_recraft <- function()
		{
		}

		o.EL_getUpgradeEquipmentEssence <- function()
		{
			return 0;
		}

		o.EL_getDisassembleEquipmentEssence <- function()
		{
			return 0;
		}

		o.EL_getRecastEquipmentEssence <- function()
		{
			return 0;
		}

	});



	// ::mods_hookNewObjectOnce("ui/global/data_helper", o.( o )
    // {
	//     local convertItemToUIData = o.convertItemToUIData;
	//     o.convertItemToUIData = o.( _item, _forceSmallIcon, _owner = null )
    // 	{
    // 		if (_item == null) return null;
    // 		local result = convertItemToUIData(_item, _forceSmallIcon, _owner);
    // 		if(_item.isItemType(this.Const.Items.ItemType.Weapon))
    // 		{
    // 			result.level <- _item.EL_getItemLevelString();
    //             //this.logInfo("输入成功");
	// 	    }
	//     	return result;
	//     }
    // });
});