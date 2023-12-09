this.el_vision_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_Vision = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.ID;
		this.m.EL_Vision = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.Vision;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]视野 + " + this.m.EL_Vision + "[/color]"
		};
		if(this.m.EL_CurrentLevel != 1)
		{
			result.text += "[color=" + this.Const.EL_Item.Type.Normal + "] (等级不足，暂不生效)[/color]";
		}
		return result;
	}	
	
	function EL_getEntryColour()
	{
		if(this.m.EL_Vision > this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.Vision)
		{
			return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
		}
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function EL_strengthen()
	{
		this.m.EL_Vision = this.Const.EL_Helmet.EL_Entry.EntryStrengthenMult * this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.Vision;
	}

	function onUpdate( _properties )
	{
		_properties.Vision += this.m.EL_Vision;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_Vision += this.m.EL_Vision;
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_CurrentLevel)
		{
			_properties.Vision += this.m.EL_Vision;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		if(this.m.EL_CurrentLevel == 1)
		{
			++_EL_totalEntry.m.EL_EntryNum;
			_EL_totalEntry.m.EL_Vision += this.m.EL_Vision;
		}
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_Vision);
	}

	function onDeserialize( _in )
	{
		this.m.EL_Vision = _in.readI32();
	}
});