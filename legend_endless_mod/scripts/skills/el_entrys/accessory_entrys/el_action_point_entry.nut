this.el_action_point_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_ActionPointAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_ActionPoint.ID;
		this.m.EL_ActionPointAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_ActionPoint.ActionPoint;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "Action Points + " + this.m.EL_ActionPointAddition + "[/color]"
		};
		return result;
	}
	function EL_setCurrentLevel(_EL_currentLevel)
	{
		if(_EL_currentLevel >= 1)
		{
			this.m.EL_CurrentLevel = 1.0;
		}
		else
		{
			this.m.EL_CurrentLevel = 0.0;
		}
	}
	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		if(this.m.EL_CurrentLevel)
		{
			_properties.ActionPoints += this.m.EL_ActionPointAddition;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		if(this.m.EL_CurrentLevel)
		{
			_EL_totalEntry.m.EL_ActionPointAddition += this.m.EL_ActionPointAddition;
		}
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ActionPointAddition);
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ActionPointAddition = _in.readI32();
		this.m.EL_CurrentLevel = _in.readF32();
	}
});