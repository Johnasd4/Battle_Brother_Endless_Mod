this.el_value_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ValueMult = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_ValueMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Worth regard as a trade goods[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ValueMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ValueMult = _in.readI32();
	}
});