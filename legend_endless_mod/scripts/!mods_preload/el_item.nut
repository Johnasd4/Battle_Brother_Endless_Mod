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

		o.EL_hasEntry <- function( _id )
		{
			foreach(entry in this.m.EL_Entrylist)
			{
				if(_id == entry.getID())
				{
					return true;
				}
			}
			return false;
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

		o.EL_setBaseNoRankConditionMax <- function( _EL_baseNoRankConditionMax )
		{
			this.m.EL_BaseNoRankConditionMax = _EL_baseNoRankConditionMax;
		}

		o.EL_getBaseWithRankConditionMax <- function()
		{
			return this.m.EL_BaseWithRankConditionMax;
		}

		o.EL_setBaseWithRankConditionMax <- function( _EL_baseWithRankConditionMax )
		{
			this.m.EL_BaseWithRankConditionMax = _EL_baseWithRankConditionMax;
		}

		o.EL_getBaseNoRankValue <- function()
		{
			return this.m.EL_BaseNoRankValue;
		}

		o.EL_setBaseNoRankValue <- function( _EL_baseNoRankValue )
		{
			this.m.EL_BaseNoRankValue = _EL_baseNoRankValue;
		}

		o.EL_getLevelAddtionStaminaModifier <- function()
		{
			return 0;
		}

		o.EL_getLevel <- function()
		{
			return this.m.EL_Level;
		}

		o.EL_setLevel <- function( _EL_level )
		{
			if(this.m.EL_Level != -1)
			{
				this.m.EL_Level = this.Math.max(0, this.Math.min(this.m.EL_Level, _EL_level));
				this.m.EL_CurrentLevel = this.m.EL_Level;
				EL_updateLevelProperties();
				this.m.Condition = (this.m.Condition > this.m.ConditionMax) ? this.m.ConditionMax : this.m.Condition;
			}
		}

		o.EL_getCurrentLevel <- function()
		{
			return this.m.EL_CurrentLevel;
		}

		o.EL_setCurrentLevel <- function( _EL_level )
		{
			if(this.m.EL_Level != -1)
			{
				this.m.EL_CurrentLevel = this.Math.max(0, this.Math.min(this.m.EL_Level, _EL_level));
				EL_updateLevelProperties();
				this.m.Condition = (this.m.Condition > this.m.ConditionMax) ? this.m.ConditionMax : this.m.Condition;
			}
		}

		o.EL_getRankLevel <- function()
		{
			return this.m.EL_RankLevel;
		}

		o.EL_setRankLevel <- function( _EL_rankLevel )
		{
			this.m.EL_RankLevel = _EL_rankLevel;
			EL_recraft();
		}

		o.EL_addRankLevel <- function()
		{
			++this.m.EL_RankLevel;
			EL_recraft();
		}

		o.EL_getLevelString <- function()
		{
			return "";
		}

		o.EL_getLevelStringColour <- function()
		{
			return "#ffffff";
		}

		o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
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

		o.EL_getUpgradeEssence <- function()
		{
			return 0;
		}

		o.EL_getDisassembleEssence <- function()
		{
			return 0;
		}

		o.EL_getRecraftEssence <- function()
		{
			return 0;
		}
	});

	
	for(local i = 0; i < this.Const.EL_Item_Other.EL_InValidItem.len(); ++i) {	
		::mods_hookExactClass("items/" + this.Const.EL_Item_Other.EL_InValidItem[i], function ( o )
		{
			o.EL_generateByRankAndLevel <- function( _EL_rankLevel, EL_level, EL_additionalRarityChance = 0 )
			{
			}

			o.EL_updateLevelProperties <- function()
			{
			}

			o.isAmountShown <- function()
			{
				return false;
			}
		});
	}
});