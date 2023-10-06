this.el_action_point_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ActionPointAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_ActionPoint.ID;
		this.m.EL_ActionPointAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_ActionPoint.ActionPoint;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Action Points + " + this.m.EL_ActionPointAddition + "[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.ActionPoints += this.m.EL_ActionPointAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_ActionPointAddition += this.m.EL_ActionPointAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ActionPointAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ActionPointAddition = _in.readI32();
	}
});