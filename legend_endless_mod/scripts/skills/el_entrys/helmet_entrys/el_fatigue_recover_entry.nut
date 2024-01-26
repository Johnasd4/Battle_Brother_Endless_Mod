this.el_fatigue_recover_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_FatigueRecoverAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]疲劳恢复 + " + this.m.EL_FatigueRecoverAddition * this.m.EL_StrengthLevel + "[/color]"
		};
		if(this.m.EL_CurrentLevel != 1)
		{
			result.text += "[color=" + this.Const.EL_Item.Type.Normal + "] (等级不足，暂不生效)[/color]";
		}
		return result;
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.RandomMinFatigueRecover[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.RandomMaxFatigueRecover[this.getItem().m.EL_RankLevel];
		this.m.EL_FatigueRecoverAddition = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.BaseFatigueRecover + this.Math.rand(randomMin, randomMax);
	}
	
	function EL_getEntryColour()
	{
		if(this.m.EL_FatigueRecover > this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.FatigueRecover)
		{
			return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
		}
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function EL_strengthen()
	{
		this.m.EL_FatigueRecover = this.Const.EL_Helmet.EL_Entry.EntryStrengthenMult * this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.FatigueRecover;
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.FatigueRecoveryRate += this.m.EL_FatigueRecoverAddition * this.m.EL_StrengthLevel;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		if(this.m.EL_CurrentLevel == 1)
		{
			++_EL_totalEntry.m.EL_EntryNum;
			_EL_totalEntry.m.EL_FatigueRecover += this.m.EL_FatigueRecover * this.m.EL_StrengthLevel;
		}
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_FatigueRecoverAddition);
		_out.writeI32(this.m.EL_StrengthLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_FatigueRecoverAddition = _in.readI32();
		this.m.EL_StrengthLevel = _in.readI32();
	}
});