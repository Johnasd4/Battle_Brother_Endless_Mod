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
			text = "[color=" + colour + "]疲劳恢复 + " + this.m.EL_FatigueRecoverAddition + "[/color]"
		};
		if(this.m.EL_CurrentLevel != 1)
		{
			result.text += "[color=" + this.Const.EL_Item.Type.Normal + "] (暂不生效)[/color]";
		}
		return result;
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.RandomMinFatigueRecover[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.RandomMaxFatigueRecover[this.getItem().m.EL_RankLevel];
		this.m.EL_FatigueRecoverAddition = this.Const.EL_Helmet.EL_Entry.Factor.EL_FatigueRecover.BaseFatigueRecover + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.FatigueRecoveryRate += this.m.EL_FatigueRecoverAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_FatigueRecoverAddition += this.m.EL_FatigueRecoverAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_FatigueRecoverAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_FatigueRecoverAddition = _in.readI32();
	}
});