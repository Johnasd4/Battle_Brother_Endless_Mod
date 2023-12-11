this.el_immue_overwhelm_dazed_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {},
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_ImmueOverwhelmDazed.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]免疫压制，茫然[/color]"
		};
		
		if(this.m.EL_CurrentLevel != 1)
		{
			result.text += "[color=" + this.Const.EL_Item.Type.Normal + "] (等级不足，暂不生效)[/color]";
		}
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_CurrentLevel)
		{
            _properties.IsImmuneToOverwhelm = true;
            _properties.IsImmuneToDaze = true;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		if(this.m.EL_CurrentLevel == 1)
		{
			++_EL_totalEntry.m.EL_EntryNum;
			_EL_totalEntry.m.EL_ImmueOverwhelmDazed = true;
		}
	}

    function onSerialize( _out )
	{
		this.el_accessory_entry.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.el_accessory_entry.onDeserialize(_in);
	}
});