this.el_fatigue_recover_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_FatigueRecover = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_FatigueRecover.ID;
		this.m.EL_FatigueRecover = this.Const.EL_Shield.EL_Entry.Factor.EL_FatigueRecover.FatigueRecover;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Fatigue Recovery per turn + " + this.m.EL_FatigueRecover + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += this.m.EL_FatigueRecover;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_FatigueRecover += this.m.EL_FatigueRecover;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_FatigueRecover);
	}

	function onDeserialize( _in )
	{
		this.m.EL_FatigueRecover = _in.readI32();
	}
});